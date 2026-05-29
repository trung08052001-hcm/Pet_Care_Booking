const express = require("express");

const {
  authenticate,
} = require("../../middlewares/auth.middleware");
const {
  forgotPassword,
  getMe,
  googleLogin,
  login,
  logout,
  refreshToken,
  resetPassword,
  register,
  verifyResetOtp,
  zaloLogin,
} = require("./auth.controller");

const router = express.Router();

router.post("/register", register);
router.post("/login", login);
router.post("/forgot-password", forgotPassword);
router.post("/verify-reset-otp", verifyResetOtp);
router.post("/reset-password", resetPassword);
router.post("/refresh-token", refreshToken);
router.post("/logout", logout);
router.post("/social/google", googleLogin);
router.post("/social/zalo", zaloLogin);
router.get("/me", authenticate, getMe);

module.exports = router;
