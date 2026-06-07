const mongoose = require("mongoose");

const RefreshToken = require("../../models/refreshToken.model");
const User = require("../../models/user.model");
const ApiError = require("../../utils/apiError");
const pickUser = require("../../utils/pickUser");
const {
  createTokenHash,
  getTokenExpiryDate,
  signAccessToken,
  signRefreshToken,
  verifyRefreshToken,
} = require("../../utils/token");
const env = require("../../config/env");
const { sendPasswordResetOtpEmail } = require("../../services/email.service");
const { generateOtp } = require("../../utils/otp");
const {
  validateForgotPasswordPayload,
  validateGoogleLoginPayload,
  validateLoginPayload,
  validateRegisterPayload,
  validateResetPasswordPayload,
  validateVerifyResetOtpPayload,
  validateZaloLoginPayload,
} = require("./auth.validation");
const { verifyGoogleIdToken } = require("./google-auth.service");
const {
  exchangeAuthorizationCode,
  fetchZaloUserProfile,
} = require("./zalo-oauth.service");

const buildTokenResponse = (user, tokens) => ({
  user: pickUser(user),
  tokens: {
    tokenType: "Bearer",
    accessToken: tokens.accessToken,
    refreshToken: tokens.refreshToken,
  },
});

const assertAdminRole = (user) => {
  if (user.role !== "admin") {
    throw new ApiError(403, "Only admin accounts can access the admin portal.");
  }
};

const issueAuthTokens = async (user, metadata = {}) => {
  const sessionId = new mongoose.Types.ObjectId().toString();
  const refreshToken = signRefreshToken({
    userId: user._id.toString(),
    sessionId,
  });
  const accessToken = signAccessToken(user);

  await RefreshToken.create({
    _id: sessionId,
    user: user._id,
    tokenHash: createTokenHash(refreshToken),
    expiresAt: getTokenExpiryDate(refreshToken),
    userAgent: metadata.userAgent || null,
    ipAddress: metadata.ipAddress || null,
  });

  return {
    accessToken,
    refreshToken,
  };
};

const register = async (payload, metadata = {}) => {
  const { email, fullName, password, phone } = validateRegisterPayload(payload);

  const existingUser = await User.findOne({
    $or: [{ email }, ...(phone ? [{ phone }] : [])],
  });

  if (existingUser) {
    throw new ApiError(409, "Email or phone number is already in use.");
  }

  const user = await User.create({
    fullName,
    email,
    password,
    phone,
    role: "user",
    acceptedTermsAt: new Date(),
  });

  const tokens = await issueAuthTokens(user, metadata);

  return buildTokenResponse(user, tokens);
};

const loginAdmin = async (payload, metadata = {}) => {
  const result = await login(payload, metadata);

  assertAdminRole(result.user);

  return result;
};

const login = async (payload, metadata = {}) => {
  const { identifier, loginBy, password } = validateLoginPayload(payload);
  const query = loginBy === "email" ? { email: identifier } : { phone: identifier };
  const user = await User.findOne(query).select("+password");

  if (!user) {
    throw new ApiError(401, "Invalid credentials.");
  }

  const isPasswordValid = await user.comparePassword(password);

  if (!isPasswordValid) {
    throw new ApiError(401, "Invalid credentials.");
  }

  if (!user.isActive) {
    throw new ApiError(403, "User account is inactive.");
  }

  user.lastLoginAt = new Date();
  await user.save();

  const tokens = await issueAuthTokens(user, metadata);

  return buildTokenResponse(user, tokens);
};

const refreshAuthTokens = async (refreshToken, metadata = {}) => {
  if (!refreshToken) {
    throw new ApiError(400, "Refresh token is required.");
  }

  let payload;

  try {
    payload = verifyRefreshToken(refreshToken);
  } catch (error) {
    throw new ApiError(401, "Invalid or expired refresh token.");
  }

  if (payload.type !== "refresh") {
    throw new ApiError(401, "Invalid refresh token.");
  }

  const storedToken = await RefreshToken.findOne({
    _id: payload.sessionId,
    user: payload.sub,
    tokenHash: createTokenHash(refreshToken),
    isRevoked: false,
  });

  if (!storedToken) {
    throw new ApiError(401, "Refresh token is not recognized.");
  }

  if (storedToken.expiresAt < new Date()) {
    storedToken.isRevoked = true;
    storedToken.revokedAt = new Date();
    await storedToken.save();
    throw new ApiError(401, "Refresh token has expired.");
  }

  const user = await User.findById(payload.sub);

  if (!user || !user.isActive) {
    throw new ApiError(401, "User is not authorized.");
  }

  storedToken.isRevoked = true;
  storedToken.revokedAt = new Date();
  await storedToken.save();

  const tokens = await issueAuthTokens(user, metadata);

  return buildTokenResponse(user, tokens);
};

const logout = async (refreshToken) => {
  if (!refreshToken) {
    throw new ApiError(400, "Refresh token is required.");
  }

  try {
    const payload = verifyRefreshToken(refreshToken);

    if (payload.type !== "refresh") {
      throw new ApiError(401, "Invalid refresh token.");
    }

    const storedToken = await RefreshToken.findOne({
      _id: payload.sessionId,
      user: payload.sub,
      tokenHash: createTokenHash(refreshToken),
      isRevoked: false,
    });

    if (storedToken) {
      storedToken.isRevoked = true;
      storedToken.revokedAt = new Date();
      await storedToken.save();
    }
  } catch (error) {
    throw new ApiError(401, "Invalid or expired refresh token.");
  }
};

const forgotPassword = async (payload) => {
  const { email } = validateForgotPasswordPayload(payload);
  const user = await User.findOne({ email }).select(
    "+passwordResetTokenHash +passwordResetExpiresAt"
  );

  if (!user || !user.isActive) {
    return {
      expiresAt: null,
    };
  }

  const otp = generateOtp();
  const expiresAt = new Date(
    Date.now() + env.otpExpiresMinutes * 60 * 1000
  );

  user.passwordResetTokenHash = createTokenHash(otp);
  user.passwordResetExpiresAt = expiresAt;
  await user.save();

  await sendPasswordResetOtpEmail({
    to: email,
    otp,
    expiresMinutes: env.otpExpiresMinutes,
  });

  return {
    expiresAt,
  };
};

const verifyResetOtp = async (payload) => {
  const { email, otp } = validateVerifyResetOtpPayload(payload);
  const otpHash = createTokenHash(otp);

  const user = await User.findOne({
    email,
    passwordResetTokenHash: otpHash,
    passwordResetExpiresAt: { $gt: new Date() },
  }).select("+passwordResetTokenHash +passwordResetExpiresAt");

  if (!user) {
    throw new ApiError(400, "OTP is invalid or expired.");
  }

  return {
    verified: true,
    expiresAt: user.passwordResetExpiresAt,
  };
};

const resetPassword = async (payload, metadata = {}) => {
  const { password, resetToken } = validateResetPasswordPayload(payload);
  const resetTokenHash = createTokenHash(resetToken);

  const user = await User.findOne({
    passwordResetTokenHash: resetTokenHash,
    passwordResetExpiresAt: { $gt: new Date() },
  }).select("+password +passwordResetTokenHash +passwordResetExpiresAt");

  if (!user) {
    throw new ApiError(400, "Reset token is invalid or expired.");
  }

  user.password = password;
  user.passwordResetTokenHash = null;
  user.passwordResetExpiresAt = null;
  user.lastLoginAt = new Date();
  await user.save();

  await RefreshToken.updateMany(
    {
      user: user._id,
      isRevoked: false,
    },
    {
      $set: {
        isRevoked: true,
        revokedAt: new Date(),
      },
    }
  );

  const tokens = await issueAuthTokens(user, metadata);

  return buildTokenResponse(user, tokens);
};

const loginWithGoogle = async (payload, metadata = {}) => {
  const { idToken } = validateGoogleLoginPayload(payload);
  const googleProfile = await verifyGoogleIdToken(idToken);
  const email = String(googleProfile.email).toLowerCase();

  let user =
    (await User.findOne({ authProvider: "google", providerId: googleProfile.uid })) ||
    (await User.findOne({ email }));

  if (!user) {
    try {
      user = await User.create({
        fullName: googleProfile.fullName,
        email,
        password: `${googleProfile.uid}_${Date.now()}_${Math.random().toString(16).slice(2)}`,
        authProvider: "google",
        providerId: googleProfile.uid,
        acceptedTermsAt: new Date(),
        role: "user",
      });
    } catch (error) {
      if (error.code !== 11000) {
        throw error;
      }

      user = await User.findOne({ email });
      if (!user) {
        throw new ApiError(
          409,
          "This email is already registered. Sign in with your password or use the same Google account."
        );
      }
    }
  }

  user.fullName = googleProfile.fullName || user.fullName;
  user.email = email;
  user.authProvider = "google";
  user.providerId = googleProfile.uid;
  user.lastLoginAt = new Date();
  await user.save();

  if (!user.isActive) {
    throw new ApiError(403, "User account is inactive.");
  }

  const tokens = await issueAuthTokens(user, metadata);

  return buildTokenResponse(user, tokens);
};

const loginWithZalo = async (payload, metadata = {}) => {
  const { oauthCode, accessToken, codeVerifier } = validateZaloLoginPayload(payload);

  const tokenPayload = accessToken
    ? {
        accessToken,
        refreshToken: null,
        expiresIn: null,
      }
    : await exchangeAuthorizationCode({
        oauthCode,
        codeVerifier,
      });
  const zaloProfile = await fetchZaloUserProfile(tokenPayload.accessToken);

  let user = await User.findOne({
    authProvider: "zalo",
    providerId: zaloProfile.id,
  });

  if (!user && zaloProfile.phone) {
    user = await User.findOne({ phone: zaloProfile.phone });
  }

  if (!user) {
    user = await User.create({
      fullName: zaloProfile.fullName,
      email: `zalo_${zaloProfile.id}@zalo.local`,
      phone: zaloProfile.phone,
      password: `${zaloProfile.id}_${Date.now()}_${Math.random().toString(16).slice(2)}`,
      authProvider: "zalo",
      providerId: zaloProfile.id,
      acceptedTermsAt: new Date(),
      role: "user",
    });
  } else {
    user.fullName = zaloProfile.fullName || user.fullName;
    user.phone = zaloProfile.phone || user.phone;
    user.authProvider = "zalo";
    user.providerId = zaloProfile.id;
    user.lastLoginAt = new Date();
    await user.save();
  }

  if (!user.lastLoginAt) {
    user.lastLoginAt = new Date();
    await user.save();
  }

  const tokens = await issueAuthTokens(user, metadata);

  return buildTokenResponse(user, tokens);
};

module.exports = {
  register,
  login,
  loginAdmin,
  refreshAuthTokens,
  logout,
  forgotPassword,
  verifyResetOtp,
  resetPassword,
  loginWithGoogle,
  loginWithZalo,
};
