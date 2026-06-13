const pickUser = require("../../utils/pickUser");

const mapConversation = (conversation) => ({
  id: conversation._id,
  customer: conversation.customer ? pickUser(conversation.customer) : null,
  assignedAdmin: conversation.assignedAdmin
    ? pickUser(conversation.assignedAdmin)
    : null,
  status: conversation.status,
  lastMessage: conversation.lastMessage,
  unreadForCustomer: conversation.unreadForCustomer,
  unreadForAdmin: conversation.unreadForAdmin,
  createdAt: conversation.createdAt,
  updatedAt: conversation.updatedAt,
});

const mapMessage = (message) => ({
  id: message._id,
  conversationId: message.conversation,
  sender: message.sender ? pickUser(message.sender) : null,
  senderRole: message.senderRole,
  type: message.type,
  text: message.text,
  readBy: message.readBy,
  createdAt: message.createdAt,
  updatedAt: message.updatedAt,
});

module.exports = {
  mapConversation,
  mapMessage,
};
