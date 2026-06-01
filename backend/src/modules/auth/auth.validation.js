const { parseSchema } = require("../../utils/parseSchema");
const { normalizeEmail, normalizePhone } = require("../../validators/common");
const {
  forgotPasswordSchema,
  googleLoginSchema,
  loginSchema,
  registerSchema,
  resetPasswordSchema,
  verifyResetOtpSchema,
  zaloLoginSchema,
} = require("./auth.schemas");

const validateRegisterPayload = (payload) =>
  parseSchema(registerSchema, payload);

const validateLoginPayload = (payload) => parseSchema(loginSchema, payload);

const validateForgotPasswordPayload = (payload) =>
  parseSchema(forgotPasswordSchema, payload);

const validateVerifyResetOtpPayload = (payload) =>
  parseSchema(verifyResetOtpSchema, payload);

const validateResetPasswordPayload = (payload) =>
  parseSchema(resetPasswordSchema, payload);

const validateGoogleLoginPayload = (payload) =>
  parseSchema(googleLoginSchema, payload);

const validateZaloLoginPayload = (payload) =>
  parseSchema(zaloLoginSchema, payload);

module.exports = {
  normalizeEmail,
  normalizePhone,
  validateRegisterPayload,
  validateLoginPayload,
  validateForgotPasswordPayload,
  validateVerifyResetOtpPayload,
  validateResetPasswordPayload,
  validateGoogleLoginPayload,
  validateZaloLoginPayload,
};
