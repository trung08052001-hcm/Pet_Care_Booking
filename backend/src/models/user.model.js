const mongoose = require("mongoose");

const {
  comparePassword,
  hashPassword,
} = require("../utils/password");

const userSchema = new mongoose.Schema(
  {
    fullName: {
      type: String,
      required: [true, "Full name is required."],
      trim: true,
    },
    email: {
      type: String,
      required: [true, "Email is required."],
      unique: true,
      lowercase: true,
      trim: true,
    },
    password: {
      type: String,
      required: [true, "Password is required."],
      minlength: 8,
      select: false,
    },
    phone: {
      type: String,
      trim: true,
    },
    avatar: {
      type: String,
      trim: true,
      maxlength: 5500000,
      default: null,
    },
    address: {
      label: {
        type: String,
        trim: true,
        maxlength: 50,
        default: "",
      },
      detail: {
        type: String,
        trim: true,
        maxlength: 300,
        default: "",
      },
      latitude: {
        type: Number,
        default: null,
      },
      longitude: {
        type: Number,
        default: null,
      },
      updatedAt: {
        type: Date,
        default: null,
      },
    },
    role: {
      type: String,
      enum: ["user", "customer", "staff", "admin"],
      default: "user",
    },
    isActive: {
      type: Boolean,
      default: true,
    },
    isOnline: {
      type: Boolean,
      default: false,
      index: true,
    },
    lastSeenAt: {
      type: Date,
      default: null,
    },
    authProvider: {
      type: String,
      enum: ["local", "google", "zalo"],
      default: "local",
    },
    providerId: {
      type: String,
      default: null,
    },
    acceptedTermsAt: {
      type: Date,
      default: null,
    },
    passwordResetTokenHash: {
      type: String,
      default: null,
      select: false,
    },
    passwordResetExpiresAt: {
      type: Date,
      default: null,
      select: false,
    },
    lastLoginAt: {
      type: Date,
      default: null,
    },
  },
  {
    timestamps: true,
  }
);

// Only enforce uniqueness when phone is a non-empty string (multiple users may omit phone).
userSchema.index(
  { phone: 1 },
  {
    unique: true,
    partialFilterExpression: {
      phone: { $type: "string", $gt: "" },
    },
  }
);

userSchema.pre("save", async function hashUserPassword() {
  if (!this.isModified("password")) {
    return;
  }

  this.password = await hashPassword(this.password);
});

userSchema.methods.comparePassword = function compareUserPassword(
  candidatePassword
) {
  return comparePassword(candidatePassword, this.password);
};

module.exports = mongoose.model("User", userSchema);
