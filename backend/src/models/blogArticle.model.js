const mongoose = require("mongoose");

const blogArticleSectionSchema = new mongoose.Schema(
  {
    heading: {
      type: String,
      required: true,
      trim: true,
    },
    body: {
      type: String,
      required: true,
      trim: true,
    },
  },
  { _id: false }
);

const blogArticleSchema = new mongoose.Schema(
  {
    sourceId: {
      type: String,
      required: true,
      unique: true,
      index: true,
      trim: true,
    },
    title: {
      type: String,
      required: true,
      trim: true,
      maxlength: 240,
    },
    slug: {
      type: String,
      required: true,
      unique: true,
      index: true,
      trim: true,
      lowercase: true,
      maxlength: 240,
    },
    mainCategory: {
      type: String,
      required: true,
      enum: ["Dinh dưỡng", "Sức khỏe", "Huấn luyện"],
      index: true,
    },
    category: {
      type: String,
      required: true,
      trim: true,
    },
    tag: {
      type: String,
      trim: true,
    },
    image: {
      type: String,
      required: true,
      trim: true,
      maxlength: 1000,
    },
    author: {
      type: String,
      required: true,
      trim: true,
      maxlength: 120,
    },
    publishedDate: {
      type: String,
      required: true,
      trim: true,
      maxlength: 80,
    },
    readTime: {
      type: String,
      required: true,
      trim: true,
      maxlength: 80,
    },
    shortDescription: {
      type: String,
      required: true,
      trim: true,
      maxlength: 600,
    },
    content: {
      intro: {
        type: String,
        required: true,
        trim: true,
      },
      sections: {
        type: [blogArticleSectionSchema],
        default: [],
      },
      tip: {
        type: String,
        trim: true,
      },
      conclusion: {
        type: String,
        trim: true,
      },
    },
    sortOrder: {
      type: Number,
      default: 0,
      index: true,
    },
    isActive: {
      type: Boolean,
      default: true,
      index: true,
    },
  },
  {
    timestamps: true,
  }
);

module.exports = mongoose.model("BlogArticle", blogArticleSchema);
