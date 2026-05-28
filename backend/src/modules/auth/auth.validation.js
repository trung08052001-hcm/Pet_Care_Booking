const ApiError = require("../../utils/apiError");

const EMAIL_REGEX = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;
const PHONE_REGEX = /^\+?[0-9]{9,15}$/;

const normalizeEmail = (email) => String(email || "").trim().toLowerCase();
const normalizePhone = (phone) => String(phone || "").replace(/\s+/g, "").trim();
const normalizeIdentifier = (value) => String(value || "").trim();

const validateEmail = (email) => EMAIL_REGEX.test(email);
const validatePhone = (phone) => PHONE_REGEX.test(phone);

const ensurePasswordStrength = (password) => {
  if (String(password || "").length < 8) {
    throw new ApiError(400, "Password must be at least 8 characters.");
  }
};

const validateRegisterPayload = (payload) => {
  const fullName = String(payload.fullName || "").trim();
  const email = normalizeEmail(payload.email);
  const phone = payload.phone ? normalizePhone(payload.phone) : null;
  const password = String(payload.password || "");
  const confirmPassword = String(payload.confirmPassword || "");
  const acceptTerms = Boolean(payload.acceptTerms);

  if (!fullName) {
    throw new ApiError(400, "Full name is required.");
  }

  if (!email || !validateEmail(email)) {
    throw new ApiError(400, "A valid email is required.");
  }

  if (phone && !validatePhone(phone)) {
    throw new ApiError(400, "Phone number is invalid.");
  }

  ensurePasswordStrength(password);

  if (password !== confirmPassword) {
    throw new ApiError(400, "Confirm password does not match.");
  }

  if (!acceptTerms) {
    throw new ApiError(400, "You must accept the terms and privacy policy.");
  }

  return {
    fullName,
    email,
    phone,
    password,
    acceptTerms,
  };
};

const validateLoginPayload = (payload) => {
  const identifier = normalizeIdentifier(payload.identifier || payload.email || payload.phone);
  const password = String(payload.password || "");

  if (!identifier || !password) {
    throw new ApiError(400, "Identifier and password are required.");
  }

  ensurePasswordStrength(password);

  const loginBy = validateEmail(identifier)
    ? "email"
    : validatePhone(normalizePhone(identifier))
    ? "phone"
    : null;

  if (!loginBy) {
    throw new ApiError(400, "Use a valid email or phone number to login.");
  }

  return {
    password,
    loginBy,
    identifier: loginBy === "email" ? normalizeEmail(identifier) : normalizePhone(identifier),
  };
};

const validateForgotPasswordPayload = (payload) => {
  const email = normalizeEmail(payload.email);

  if (!email || !validateEmail(email)) {
    throw new ApiError(400, "A valid email is required.");
  }

  return { email };
};

const validateResetPasswordPayload = (payload) => {
  const resetToken = String(payload.resetToken || "").trim();
  const password = String(payload.password || "");
  const confirmPassword = String(payload.confirmPassword || "");

  if (!resetToken) {
    throw new ApiError(400, "Reset token is required.");
  }

  ensurePasswordStrength(password);

  if (password !== confirmPassword) {
    throw new ApiError(400, "Confirm password does not match.");
  }

  return {
    resetToken,
    password,
  };
};

const validateGoogleLoginPayload = (payload) => {
  const idToken = String(payload.idToken || "").trim();

  if (!idToken) {
    throw new ApiError(400, "idToken is required.");
  }

  return { idToken };
};

const validateZaloLoginPayload = (payload) => {
  const oauthCode = String(payload.oauthCode || "").trim();
  const accessToken = String(payload.accessToken || "").trim();
  const codeVerifier = payload.codeVerifier
    ? String(payload.codeVerifier).trim()
    : null;

  if (!oauthCode && !accessToken) {
    throw new ApiError(400, "oauthCode or accessToken is required.");
  }

  return {
    oauthCode,
    accessToken,
    codeVerifier,
  };
};

module.exports = {
  normalizeEmail,
  normalizePhone,
  validateRegisterPayload,
  validateLoginPayload,
  validateForgotPasswordPayload,
  validateResetPasswordPayload,
  validateGoogleLoginPayload,
  validateZaloLoginPayload,
};
