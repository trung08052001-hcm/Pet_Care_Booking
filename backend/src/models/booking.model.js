const mongoose = require("mongoose");

const bookingSchema = new mongoose.Schema(
  {
    user: {
      type: mongoose.Schema.Types.ObjectId,
      ref: "User",
      required: true,
      index: true,
    },
    pet: {
      type: mongoose.Schema.Types.ObjectId,
      ref: "Pet",
      required: true,
    },
    serviceIds: {
      type: [String],
      required: true,
      validate: {
        validator: (value) => Array.isArray(value) && value.length > 0,
        message: "At least one service is required.",
      },
    },
    appointmentDate: {
      type: Date,
      required: true,
      index: true,
    },
    dateKey: {
      type: String,
      required: true,
      index: true,
    },
    timeSlotId: {
      type: String,
      required: true,
    },
    timeSlotLabel: {
      type: String,
      required: true,
    },
    totalVnd: {
      type: Number,
      required: true,
      min: 0,
    },
    status: {
      type: String,
      enum: ["upcoming", "completed", "cancelled"],
      default: "upcoming",
      index: true,
    },
    cancelledAt: {
      type: Date,
      default: null,
    },
    reminder1dSentAt: {
      type: Date,
      default: null,
    },
    reminder1hSentAt: {
      type: Date,
      default: null,
    },
  },
  {
    timestamps: true,
  }
);

bookingSchema.index(
  { dateKey: 1, timeSlotId: 1 },
  {
    unique: true,
    partialFilterExpression: {
      status: { $in: ["upcoming", "completed"] },
    },
  }
);

module.exports = mongoose.model("Booking", bookingSchema);
