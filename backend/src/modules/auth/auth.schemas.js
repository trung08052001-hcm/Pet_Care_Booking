const Joi = require("joi");

const {
  PHONE_REGEX,
  emailField,
  normalizeEmail,
  normalizePhone,
  optionalPhoneField,
  passwordField,
} = require("../../validators/common");

const registerSchema = Joi.object({
  fullName: Joi.string().trim().min(1).max(120).required().messages({
    "string.empty": "Full name is required.",
    "any.required": "Full name is required.",
  }),
  email: emailField.required(),
  phone: optionalPhoneField,
  address: Joi.string().trim().max(300).allow("").default("").messages({
    "string.max": "Address cannot exceed 300 characters.",
  }),
  password: passwordField.required(),
  confirmPassword: Joi.string()
    .valid(Joi.ref("password"))
    .required()
    .messages({
      "any.only": "Confirm password does not match.",
      "any.required": "Confirm password is required.",
    }),
  acceptTerms: Joi.boolean()
    .valid(true)
    .required()
    .messages({
      "any.only": "You must accept the terms and privacy policy.",
      "any.required": "You must accept the terms and privacy policy.",
    }),
});

const loginSchema = Joi.object({
  identifier: Joi.string().trim().allow(""),
  email: Joi.string().trim().allow(""),
  phone: Joi.string().trim().allow(""),
  password: passwordField.required(),
})
  .custom((value, helpers) => {
    const raw = String(
      value.identifier || value.email || value.phone || ""
    ).trim();

    if (!raw) {
      return helpers.error("any.custom", {
        message: "Identifier and password are required.",
      });
    }

    const emailRegex = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;

    if (emailRegex.test(raw)) {
      return {
        password: value.password,
        loginBy: "email",
        identifier: normalizeEmail(raw),
      };
    }

    const normalizedPhone = normalizePhone(raw);

    if (PHONE_REGEX.test(normalizedPhone)) {
      return {
        password: value.password,
        loginBy: "phone",
        identifier: normalizedPhone,
      };
    }

    return helpers.error("any.custom", {
      message: "Use a valid email or phone number to login.",
    });
  })
  .messages({
    "any.custom": "{{#message}}",
  });

const forgotPasswordSchema = Joi.object({
  email: emailField.required(),
});

const verifyResetOtpSchema = Joi.object({
  email: emailField.required(),
  otp: Joi.string()
    .trim()
    .pattern(/^\d{6}$/)
    .required()
    .messages({
      "string.pattern.base": "OTP must be a 6-digit code.",
      "any.required": "OTP is required.",
    }),
});

const resetPasswordSchema = Joi.object({
  resetToken: Joi.string().trim().min(1).required().messages({
    "any.required": "Reset token is required.",
    "string.empty": "Reset token is required.",
  }),
  password: passwordField.required(),
  confirmPassword: Joi.string()
    .valid(Joi.ref("password"))
    .required()
    .messages({
      "any.only": "Confirm password does not match.",
      "any.required": "Confirm password is required.",
    }),
});

const googleLoginSchema = Joi.object({
  idToken: Joi.string().trim().min(1).required().messages({
    "any.required": "idToken is required.",
    "string.empty": "idToken is required.",
  }),
});

const zaloLoginSchema = Joi.object({
  oauthCode: Joi.string().trim().allow(""),
  accessToken: Joi.string().trim().allow(""),
  codeVerifier: Joi.string().trim().allow(null, "").empty("").default(null),
}).custom((value, helpers) => {
  const oauthCode = String(value.oauthCode || "").trim();
  const accessToken = String(value.accessToken || "").trim();

  if (!oauthCode && !accessToken) {
    return helpers.error("any.custom", {
      message: "oauthCode or accessToken is required.",
    });
  }

  return {
    oauthCode,
    accessToken,
    codeVerifier: value.codeVerifier || null,
  };
});

const refreshTokenSchema = Joi.object({
  refreshToken: Joi.string().trim().min(1).required().messages({
    "any.required": "Refresh token is required.",
    "string.empty": "Refresh token is required.",
  }),
});

const addressSchema = Joi.object({
  detail: Joi.string().trim().min(1).max(300).required().messages({
    "string.empty": "Address is required.",
    "string.max": "Address cannot exceed 300 characters.",
    "any.required": "Address is required.",
  }),
  label: Joi.string().trim().max(50).allow("").default("").messages({
    "string.max": "Address label cannot exceed 50 characters.",
  }),
  latitude: Joi.number().min(-90).max(90).allow(null).default(null),
  longitude: Joi.number().min(-180).max(180).allow(null).default(null),
});

module.exports = {
  registerSchema,
  loginSchema,
  forgotPasswordSchema,
  verifyResetOtpSchema,
  resetPasswordSchema,
  googleLoginSchema,
  zaloLoginSchema,
  refreshTokenSchema,
  addressSchema,
};
