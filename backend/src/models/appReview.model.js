const mongoose = require("mongoose");

const appReviewSchema = new mongoose.Schema(
  {
    user: {
      type: mongoose.Schema.Types.ObjectId,
      ref: "User",
      required: true,
    },
    rating: {
      type: Number,
      required: [true, "Rating is required."],
      min: 1,
      max: 5,
    },
    comment: {
      type: String,
      required: [true, "Review comment is required."],
      trim: true,
      maxlength: 1000,
    },
    status: {
      type: String,
      enum: ["new", "reviewed", "archived"],
      default: "new",
    },
  },
  {
    timestamps: true,
  }
);

module.exports = mongoose.model("AppReview", appReviewSchema);
