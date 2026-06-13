const User = require("../models/user.model");
const { verifyAccessToken } = require("../utils/token");

let ioInstance = null;

const userRoom = (userId) => `user:${userId}`;
const conversationRoom = (conversationId) => `conversation:${conversationId}`;

const pickPresenceUser = (user) => ({
  id: user._id.toString(),
  isOnline: Boolean(user.isOnline),
  lastSeenAt: user.lastSeenAt || null,
});

const authenticateSocket = async (socket, next) => {
  const rawToken =
    socket.handshake.auth?.token ||
    socket.handshake.headers?.authorization?.replace(/^Bearer\s+/i, "");

  if (!rawToken) {
    return next(new Error("Authentication token is required."));
  }

  try {
    const payload = verifyAccessToken(rawToken);
    if (payload.type !== "access") {
      return next(new Error("Invalid access token."));
    }

    const user = await User.findById(payload.sub);
    if (!user || !user.isActive) {
      return next(new Error("User is not authorized."));
    }

    socket.data.user = user;
    return next();
  } catch (error) {
    return next(new Error("Invalid or expired access token."));
  }
};

const initializeChatSocket = (io) => {
  ioInstance = io;
  io.use(authenticateSocket);

  io.on("connection", (socket) => {
    const user = socket.data.user;
    const userId = user._id.toString();
    socket.join(userRoom(userId));
    if (user.role === "admin") {
      socket.join("admins");
    }

    const markOnline = async () => {
      user.isOnline = true;
      user.lastSeenAt = new Date();
      await user.save();
      io.to("admins").emit("presence:user-updated", {
        user: pickPresenceUser(user),
      });
    };

    const markOfflineIfNoActiveSockets = async () => {
      const room = io.sockets.adapter.rooms.get(userRoom(userId));
      if (room && room.size > 0) {
        return;
      }

      const nextUser = await User.findById(userId);
      if (!nextUser) {
        return;
      }
      nextUser.isOnline = false;
      nextUser.lastSeenAt = new Date();
      await nextUser.save();
      io.to("admins").emit("presence:user-updated", {
        user: pickPresenceUser(nextUser),
      });
    };

    markOnline().catch((error) => {
      console.warn("[socket] Unable to mark user online", error.message);
    });

    socket.on("presence:online", () => {
      markOnline().catch((error) => {
        console.warn("[socket] Unable to refresh user presence", error.message);
      });
    });

    socket.on("disconnect", () => {
      setTimeout(() => {
        markOfflineIfNoActiveSockets().catch((error) => {
          console.warn("[socket] Unable to mark user offline", error.message);
        });
      }, 1500);
    });

    socket.on("chat:join", async ({ conversationId } = {}, ack) => {
      if (!conversationId) {
        ack?.({ success: false, message: "Conversation id is required." });
        return;
      }
      try {
        const chatService = require("../modules/chat/chat.service");
        await chatService.getMessages(conversationId, user, { limit: 1 });
        socket.join(conversationRoom(conversationId));
        ack?.({ success: true });
      } catch (error) {
        ack?.({
          success: false,
          message: error.message || "Unable to join conversation.",
        });
      }
    });

    socket.on("chat:typing", ({ conversationId, isTyping } = {}) => {
      if (!conversationId) {
        return;
      }
      socket.to(conversationRoom(conversationId)).emit("chat:typing", {
        conversationId,
        userId: user._id.toString(),
        isTyping: Boolean(isTyping),
      });
    });

    socket.on("chat:send", async ({ conversationId, text } = {}, ack) => {
      try {
        const chatService = require("../modules/chat/chat.service");
        const result = await chatService.sendMessage(conversationId, user, {
          text,
        });
        ack?.({ success: true, data: result });
      } catch (error) {
        ack?.({
          success: false,
          message: error.message || "Unable to send message.",
        });
      }
    });
  });
};

const getChatSocket = () => {
  if (!ioInstance) {
    return null;
  }

  return {
    emitToConversation(conversationId, event, payload) {
      ioInstance.to(conversationRoom(conversationId)).emit(event, payload);
    },
    emitToUser(userId, event, payload) {
      ioInstance.to(userRoom(userId)).emit(event, payload);
    },
    emitToAdmins(event, payload) {
      ioInstance.to("admins").emit(event, payload);
    },
  };
};

module.exports = {
  initializeChatSocket,
  getChatSocket,
};
