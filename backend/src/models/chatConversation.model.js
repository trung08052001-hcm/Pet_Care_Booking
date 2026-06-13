const mongoose = require("mongoose");

const participantSchema = new mongoose.Schema(
  {
    user: {
      type: mongoose.Schema.Types.ObjectId,
      ref: "User",
      required: true,
      index: true,
    },
    role: {
      type: String,
      enum: ["customer", "admin"],
      required: true,
    },
  },
  {
    _id: false,
  }
);

const chatConversationSchema = new mongoose.Schema(
  {
    customer: {
      type: mongoose.Schema.Types.ObjectId,
      ref: "User",
      required: true,
      index: true,
    },
    assignedAdmin: {
      type: mongoose.Schema.Types.ObjectId,
      ref: "User",
      default: null,
      index: true,
    },
    participants: {
      type: [participantSchema],
      default: [],
    },
    status: {
      type: String,
      enum: ["open", "closed"],
      default: "open",
      index: true,
    },
    lastMessage: {
      text: {
        type: String,
        default: "",
      },
      sender: {
        type: mongoose.Schema.Types.ObjectId,
        ref: "User",
        default: null,
      },
      senderRole: {
        type: String,
        enum: ["customer", "admin", null],
        default: null,
      },
      createdAt: {
        type: Date,
        default: null,
      },
    },
    unreadForCustomer: {
      type: Number,
      default: 0,
      min: 0,
    },
    unreadForAdmin: {
      type: Number,
      default: 0,
      min: 0,
    },
  },
  {
    timestamps: true,
  }
);

chatConversationSchema.index({ customer: 1, status: 1 });
chatConversationSchema.index({ "participants.user": 1, updatedAt: -1 });

module.exports = mongoose.model("ChatConversation", chatConversationSchema);
