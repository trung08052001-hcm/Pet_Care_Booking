const Joi = require("joi");

const PHONE_REGEX = /^\+?[0-9]{9,15}$/;

const normalizeEmail = (email) => String(email || "").trim().toLowerCase();

const normalizePhone = (phone) => String(phone || "").replace(/\s+/g, "").trim();

const passwordField = Joi.string().min(8).max(128).messages({
  "string.min": "Password must be at least 8 characters.",
  "any.required": "Password is required.",
});

const emailField = Joi.string()
  .trim()
  .lowercase()
  .email({ tlds: { allow: false } })
  .messages({
    "string.email": "A valid email is required.",
    "any.required": "Email is required.",
  });

const optionalPhoneField = Joi.string()
  .trim()
  .allow(null, "")
  .custom((value, helpers) => {
    if (!value) {
      return null;
    }

    if (!PHONE_REGEX.test(value)) {
      return helpers.error("any.custom", {
        message: "Phone number is invalid.",
      });
    }

    return value;
  });

module.exports = {
  PHONE_REGEX,
  normalizeEmail,
  normalizePhone,
  passwordField,
  emailField,
  optionalPhoneField,
};
