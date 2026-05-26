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
      default: null,
      sparse: true,
      unique: true,
    },
    role: {
      type: String,
      enum: ["customer", "staff", "admin"],
      default: "customer",
    },
    isActive: {
      type: Boolean,
      default: true,
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
