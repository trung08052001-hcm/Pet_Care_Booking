const mongoose = require("mongoose");

const helpFeedbackSchema = new mongoose.Schema(
  {
    user: {
      type: mongoose.Schema.Types.ObjectId,
      ref: "User",
      default: null,
    },
    message: {
      type: String,
      required: [true, "Feedback message is required."],
      trim: true,
      maxlength: 1000,
    },
    status: {
      type: String,
      enum: ["new", "reviewing", "resolved"],
      default: "new",
    },
  },
  {
    timestamps: true,
  }
);

module.exports = mongoose.model("HelpFeedback", helpFeedbackSchema);
