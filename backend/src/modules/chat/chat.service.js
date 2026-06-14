const mongoose = require("mongoose");

const ChatConversation = require("../../models/chatConversation.model");
const ChatMessage = require("../../models/chatMessage.model");
const User = require("../../models/user.model");
const ApiError = require("../../utils/apiError");
const notificationService = require("../notifications/notification.service");
const { getChatSocket } = require("../../socket/chatSocket");
const { mapConversation, mapMessage } = require("./chat.mapper");

const isAdmin = (user) => user.role === "admin";

const getSenderRole = (user) => (isAdmin(user) ? "admin" : "customer");

const toIdString = (value) => {
  if (!value) {
    return "";
  }

  if (value._id) {
    return value._id.toString();
  }

  return value.toString();
};

const buildMessagePreview = (message) => {
  if (message.text) {
    return message.text;
  }

  const attachment = message.attachments?.[0];
  if (!attachment) {
    return "";
  }

  return attachment.type === "image"
    ? "Đã gửi một hình ảnh"
    : `Đã gửi tệp ${attachment.name}`;
};

const normalizeAttachments = (attachments = []) =>
  attachments.map((attachment) => ({
    type: attachment.type === "image" ? "image" : "file",
    name: String(attachment.name || "attachment").trim(),
    dataUrl: String(attachment.dataUrl || "").trim(),
    mimeType: String(attachment.mimeType || "").trim(),
    sizeBytes: Number(attachment.sizeBytes) || 0,
  }));

const assertConversationAccess = (conversation, user) => {
  if (!conversation) {
    throw new ApiError(404, "Conversation not found.");
  }

  if (isAdmin(user)) {
    return;
  }

  if (toIdString(conversation.customer) !== user._id.toString()) {
    throw new ApiError(403, "You do not have access to this conversation.");
  }
};

const ensureCustomerConversation = async (user) => {
  let conversation = await ChatConversation.findOne({
    customer: user._id,
    status: "open",
  });

  if (!conversation) {
    conversation = await ChatConversation.create({
      customer: user._id,
      participants: [
        {
          user: user._id,
          role: "customer",
        },
      ],
    });
  }

  return conversation.populate(["customer", "assignedAdmin"]);
};

const listConversations = async (user) => {
  const query = isAdmin(user)
    ? {}
    : {
        customer: user._id,
      };

  const conversations = await ChatConversation.find(query)
    .populate(["customer", "assignedAdmin"])
    .sort({ updatedAt: -1 });

  return conversations.map(mapConversation);
};

const getOrCreateMyConversation = async (user) => {
  const conversation = await ensureCustomerConversation(user);
  return mapConversation(conversation);
};

const getMessages = async (conversationId, user, query = {}) => {
  if (!mongoose.Types.ObjectId.isValid(conversationId)) {
    throw new ApiError(400, "Conversation id is invalid.");
  }

  const conversation = await ChatConversation.findById(conversationId);
  assertConversationAccess(conversation, user);

  const limit = Math.min(Number(query.limit) || 50, 100);
  const messages = await ChatMessage.find({ conversation: conversationId })
    .populate("sender")
    .sort({ createdAt: -1 })
    .limit(limit);

  return messages.reverse().map(mapMessage);
};

const getAdminRecipients = async (conversation) => {
  if (conversation.assignedAdmin) {
    return [toIdString(conversation.assignedAdmin)];
  }

  const admins = await User.find({
    role: "admin",
    isActive: true,
  }).select("_id");

  return admins.map((admin) => admin._id);
};

const sendChatNotification = async ({ conversation, message, sender }) => {
  const senderRole = getSenderRole(sender);
  const recipients =
    senderRole === "admin"
      ? [toIdString(conversation.customer)]
      : await getAdminRecipients(conversation);

  try {
    await Promise.all(
      recipients
        .filter((recipientId) => toIdString(recipientId) !== sender._id.toString())
        .map((recipientId) =>
          notificationService.sendToUser(recipientId, {
            title:
              senderRole === "admin"
                ? "Admin đã trả lời bạn"
                : "Tin nhắn mới từ khách hàng",
            body: buildMessagePreview(message),
            data: {
              type: "chat_message",
              conversationId: conversation._id.toString(),
              messageId: message._id.toString(),
            },
          })
        )
    );
  } catch (error) {
    console.warn("[chat] Unable to send FCM notification", error.message);
  }
};

const emitMessage = (conversation, mappedMessage) => {
  const chatSocket = getChatSocket();
  if (!chatSocket) {
    return;
  }

  chatSocket.emitToConversation(conversation._id.toString(), "chat:message", {
    conversation: mapConversation(conversation),
    message: mappedMessage,
  });
  chatSocket.emitToAdmins("chat:conversation-updated", {
    conversation: mapConversation(conversation),
  });
  chatSocket.emitToUser(toIdString(conversation.customer), "chat:conversation-updated", {
    conversation: mapConversation(conversation),
  });
};

const sendMessage = async (conversationId, user, payload) => {
  const conversation = conversationId
    ? await ChatConversation.findById(conversationId)
    : await ensureCustomerConversation(user);

  assertConversationAccess(conversation, user);

  const senderRole = getSenderRole(user);
  const attachments = normalizeAttachments(payload.attachments);
  const messageType = attachments[0]?.type || "text";

  if (senderRole === "admin" && !conversation.assignedAdmin) {
    conversation.assignedAdmin = user._id;
    const hasAdminParticipant = conversation.participants.some(
      (participant) =>
        participant.user.toString() === user._id.toString() &&
        participant.role === "admin"
    );
    if (!hasAdminParticipant) {
      conversation.participants.push({
        user: user._id,
        role: "admin",
      });
    }
  }

  const message = await ChatMessage.create({
    conversation: conversation._id,
    sender: user._id,
    senderRole,
    type: messageType,
    text: payload.text || "",
    attachments,
    readBy: [
      {
        user: user._id,
        readAt: new Date(),
      },
    ],
  });

  conversation.lastMessage = {
    text: buildMessagePreview(message),
    sender: user._id,
    senderRole,
    createdAt: message.createdAt,
  };
  if (senderRole === "admin") {
    conversation.unreadForCustomer += 1;
    conversation.unreadForAdmin = 0;
  } else {
    conversation.unreadForAdmin += 1;
    conversation.unreadForCustomer = 0;
  }
  await conversation.save();

  await conversation.populate(["customer", "assignedAdmin"]);
  await message.populate("sender");

  const mappedMessage = mapMessage(message);
  emitMessage(conversation, mappedMessage);
  await sendChatNotification({
    conversation,
    message,
    sender: user,
  });

  return {
    conversation: mapConversation(conversation),
    message: mappedMessage,
  };
};

const markConversationRead = async (conversationId, user) => {
  const conversation = await ChatConversation.findById(conversationId);
  assertConversationAccess(conversation, user);

  if (isAdmin(user)) {
    conversation.unreadForAdmin = 0;
  } else {
    conversation.unreadForCustomer = 0;
  }
  await conversation.save();
  await conversation.populate(["customer", "assignedAdmin"]);

  return mapConversation(conversation);
};

module.exports = {
  getMessages,
  getOrCreateMyConversation,
  listConversations,
  markConversationRead,
  sendMessage,
};
