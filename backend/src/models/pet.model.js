const mongoose = require("mongoose");

const petSchema = new mongoose.Schema(
  {
    owner: {
      type: mongoose.Schema.Types.ObjectId,
      ref: "User",
      required: true,
      index: true,
    },
    name: {
      type: String,
      required: [true, "Pet name is required."],
      trim: true,
      maxlength: 80,
    },
    ageYears: {
      type: Number,
      required: [true, "Pet age is required."],
      min: 0,
      max: 80,
    },
    weightKg: {
      type: Number,
      required: [true, "Pet weight is required."],
      min: 0.1,
      max: 300,
    },
    petType: {
      type: String,
      enum: ["dog", "cat", "rabbit", "bird"],
      default: "dog",
    },
    vaccinationStatus: {
      type: String,
      enum: ["vaccinated", "not_vaccinated", "unknown", "needs_booster"],
      default: "unknown",
    },
    imageDataUrl: {
      type: String,
      default: null,
    },
  },
  {
    timestamps: true,
  }
);

module.exports = mongoose.model("Pet", petSchema);
