const mongoose = require("mongoose");

const serviceSchema = new mongoose.Schema(
  {
    title: {
      type: String,
      required: [true, "Service title is required."],
      trim: true,
      maxlength: 120,
    },
    slug: {
      type: String,
      trim: true,
      lowercase: true,
      maxlength: 120,
      index: true,
      unique: true,
      sparse: true,
    },
    description: {
      type: String,
      required: [true, "Service description is required."],
      trim: true,
      maxlength: 500,
    },
    detail: {
      type: String,
      required: [true, "Service detail is required."],
      trim: true,
      maxlength: 1200,
    },
    priceText: {
      type: String,
      required: [true, "Service price is required."],
      trim: true,
      maxlength: 80,
    },
    image: {
      type: String,
      required: [true, "Service image is required."],
      trim: true,
      maxlength: 5500000,
    },
    category: {
      type: String,
      enum: ["all", "dog", "cat"],
      required: true,
      index: true,
    },
    badge: {
      type: String,
      required: true,
      trim: true,
      uppercase: true,
      maxlength: 24,
    },
    isActive: {
      type: Boolean,
      default: true,
      index: true,
    },
    isFeatured: {
      type: Boolean,
      default: false,
      index: true,
    },
    icon: {
      type: String,
      trim: true,
      maxlength: 60,
    },
    ratingText: {
      type: String,
      trim: true,
      maxlength: 24,
    },
    reviewText: {
      type: String,
      trim: true,
      maxlength: 80,
    },
    usageText: {
      type: String,
      trim: true,
      maxlength: 80,
    },
    durationText: {
      type: String,
      trim: true,
      maxlength: 80,
    },
    promo: {
      title: {
        type: String,
        trim: true,
        maxlength: 120,
      },
      description: {
        type: String,
        trim: true,
        maxlength: 300,
      },
      discountText: {
        type: String,
        trim: true,
        maxlength: 40,
      },
      tone: {
        type: String,
        enum: ["orange", "green"],
        default: "orange",
      },
    },
    includedItems: {
      type: [String],
      default: [],
    },
    benefits: {
      type: [String],
      default: [],
    },
    noticeText: {
      type: String,
      trim: true,
      maxlength: 300,
    },
    sortOrder: {
      type: Number,
      default: 0,
      index: true,
    },
  },
  {
    timestamps: true,
  }
);

module.exports = mongoose.model("Service", serviceSchema);
