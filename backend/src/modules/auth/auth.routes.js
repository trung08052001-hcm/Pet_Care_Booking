const express = require("express");

const validate = require("../../middlewares/validate");
const {
  authenticate,
} = require("../../middlewares/auth.middleware");
const {
  forgotPassword,
  getMe,
  googleLogin,
  adminLogin,
  login,
  logout,
  refreshToken,
  resetPassword,
  register,
  verifyResetOtp,
  zaloLogin,
} = require("./auth.controller");
const {
  forgotPasswordSchema,
  googleLoginSchema,
  loginSchema,
  refreshTokenSchema,
  registerSchema,
  resetPasswordSchema,
  verifyResetOtpSchema,
  zaloLoginSchema,
} = require("./auth.schemas");

const router = express.Router();

router.post("/register", validate(registerSchema), register);
router.post("/login", validate(loginSchema), login);
router.post("/admin/login", validate(loginSchema), adminLogin);
router.post("/forgot-password", validate(forgotPasswordSchema), forgotPassword);
router.post("/verify-reset-otp", validate(verifyResetOtpSchema), verifyResetOtp);
router.post("/reset-password", validate(resetPasswordSchema), resetPassword);
router.post("/refresh-token", validate(refreshTokenSchema), refreshToken);
router.post("/logout", validate(refreshTokenSchema), logout);
router.post("/social/google", validate(googleLoginSchema), googleLogin);
router.post("/social/zalo", validate(zaloLoginSchema), zaloLogin);
router.get("/me", authenticate, getMe);

module.exports = router;
