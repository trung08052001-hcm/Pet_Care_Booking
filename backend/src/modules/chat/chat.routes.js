const express = require("express");

const { authenticate } = require("../../middlewares/auth.middleware");
const validate = require("../../middlewares/validate");
const {
  getOrCreateMyConversation,
  listConversations,
  listMessages,
  markConversationRead,
  sendMessage,
} = require("./chat.controller");
const { sendMessageSchema } = require("./chat.schemas");

const router = express.Router();

router.use((req, res, next) => {
  res.set("Cache-Control", "no-store, no-cache, must-revalidate, proxy-revalidate");
  res.set("Pragma", "no-cache");
  res.set("Expires", "0");
  next();
});
router.use(authenticate);

router.get("/conversations", listConversations);
router.post("/conversations", getOrCreateMyConversation);
router.get("/conversations/:conversationId/messages", listMessages);
router.post(
  "/conversations/:conversationId/messages",
  validate(sendMessageSchema),
  sendMessage
);
router.patch("/conversations/:conversationId/read", markConversationRead);

module.exports = router;
