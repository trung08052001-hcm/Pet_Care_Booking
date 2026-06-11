const asyncHandler = require("../../middlewares/asyncHandler");
const pickUser = require("../../utils/pickUser");
const authService = require("./auth.service");

const getRequestMetadata = (req) => ({
  userAgent: req.get("user-agent"),
  ipAddress: req.ip,
});

const register = asyncHandler(async (req, res) => {
  const result = await authService.register(req.body, getRequestMetadata(req));

  res.status(201).json({
    success: true,
    message: "User registered successfully.",
    data: result,
  });
});

const login = asyncHandler(async (req, res) => {
  const result = await authService.login(req.body, getRequestMetadata(req));

  res.status(200).json({
    success: true,
    message: "Login successful.",
    data: result,
  });
});

const adminLogin = asyncHandler(async (req, res) => {
  const result = await authService.loginAdmin(req.body, getRequestMetadata(req));

  res.status(200).json({
    success: true,
    message: "Admin login successful.",
    data: result,
  });
});

const refreshToken = asyncHandler(async (req, res) => {
  const result = await authService.refreshAuthTokens(
    req.body.refreshToken,
    getRequestMetadata(req)
  );

  res.status(200).json({
    success: true,
    message: "Token refreshed successfully.",
    data: result,
  });
});

const logout = asyncHandler(async (req, res) => {
  await authService.logout(req.body.refreshToken);

  res.status(200).json({
    success: true,
    message: "Logout successful.",
  });
});

const forgotPassword = asyncHandler(async (req, res) => {
  const result = await authService.forgotPassword(req.body);

  res.status(200).json({
    success: true,
    message: "If the account exists, a verification code has been sent.",
    data: result,
  });
});

const verifyResetOtp = asyncHandler(async (req, res) => {
  const result = await authService.verifyResetOtp(req.body);

  res.status(200).json({
    success: true,
    message: "OTP verified successfully.",
    data: result,
  });
});

const resetPassword = asyncHandler(async (req, res) => {
  const result = await authService.resetPassword(
    req.body,
    getRequestMetadata(req)
  );

  res.status(200).json({
    success: true,
    message: "Password reset successful.",
    data: result,
  });
});

const googleLogin = asyncHandler(async (req, res) => {
  const result = await authService.loginWithGoogle(
    req.body,
    getRequestMetadata(req)
  );

  res.status(200).json({
    success: true,
    message: "Google login successful.",
    data: result,
  });
});

const zaloLogin = asyncHandler(async (req, res) => {
  const result = await authService.loginWithZalo(req.body, getRequestMetadata(req));

  res.status(200).json({
    success: true,
    message: "Zalo login successful.",
    data: result,
  });
});

const getMe = asyncHandler(async (req, res) => {
  res.status(200).json({
    success: true,
    message: "Current user fetched successfully.",
    data: {
      user: pickUser(req.user),
    },
  });
});

const getMyAddress = asyncHandler(async (req, res) => {
  const address = await authService.getMyAddress(req.user._id);

  res.status(200).json({
    success: true,
    message: "Address fetched successfully.",
    data: {
      address,
    },
  });
});

const updateMyProfile = asyncHandler(async (req, res) => {
  const user = await authService.updateMyProfile(req.user._id, req.body);

  res.status(200).json({
    success: true,
    message: "Profile updated successfully.",
    data: {
      user: pickUser(user),
    },
  });
});

const changeMyPassword = asyncHandler(async (req, res) => {
  await authService.changeMyPassword(req.user._id, req.body);

  res.status(200).json({
    success: true,
    message: "Password changed successfully.",
  });
});

const updateMyAddress = asyncHandler(async (req, res) => {
  const address = await authService.updateMyAddress(req.user._id, req.body);

  res.status(200).json({
    success: true,
    message: "Address saved successfully.",
    data: {
      address,
    },
  });
});

module.exports = {
  register,
  login,
  adminLogin,
  refreshToken,
  logout,
  forgotPassword,
  verifyResetOtp,
  resetPassword,
  getMe,
  googleLogin,
  zaloLogin,
  getMyAddress,
  updateMyProfile,
  changeMyPassword,
  updateMyAddress,
};
