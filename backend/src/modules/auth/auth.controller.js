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
    message: "If the account exists, a reset instruction has been created.",
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

module.exports = {
  register,
  login,
  refreshToken,
  logout,
  forgotPassword,
  resetPassword,
  getMe,
  googleLogin: (req, res) => {
    res.status(501).json({
      success: false,
      message: "Google login is not configured yet.",
    });
  },
  zaloLogin,
};
