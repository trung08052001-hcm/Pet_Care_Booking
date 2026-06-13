const asyncHandler = require("../../middlewares/asyncHandler");
const chatService = require("./chat.service");

const listConversations = asyncHandler(async (req, res) => {
  const conversations = await chatService.listConversations(req.user);

  res.status(200).json({
    success: true,
    message: "Conversations fetched successfully.",
    data: {
      conversations,
    },
  });
});

const getOrCreateMyConversation = asyncHandler(async (req, res) => {
  const conversation = await chatService.getOrCreateMyConversation(req.user);

  res.status(200).json({
    success: true,
    message: "Conversation ready.",
    data: {
      conversation,
    },
  });
});

const listMessages = asyncHandler(async (req, res) => {
  const messages = await chatService.getMessages(
    req.params.conversationId,
    req.user,
    req.query
  );

  res.status(200).json({
    success: true,
    message: "Messages fetched successfully.",
    data: {
      messages,
    },
  });
});

const sendMessage = asyncHandler(async (req, res) => {
  const result = await chatService.sendMessage(
    req.params.conversationId,
    req.user,
    req.body
  );

  res.status(201).json({
    success: true,
    message: "Message sent successfully.",
    data: result,
  });
});

const markConversationRead = asyncHandler(async (req, res) => {
  const conversation = await chatService.markConversationRead(
    req.params.conversationId,
    req.user
  );

  res.status(200).json({
    success: true,
    message: "Conversation marked as read.",
    data: {
      conversation,
    },
  });
});

module.exports = {
  getOrCreateMyConversation,
  listConversations,
  listMessages,
  markConversationRead,
  sendMessage,
};
