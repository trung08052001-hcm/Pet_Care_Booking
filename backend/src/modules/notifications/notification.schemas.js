const Joi = require("joi");

const registerDeviceTokenSchema = Joi.object({
  token: Joi.string().trim().min(10).required(),
  platform: Joi.string()
    .valid("android", "ios", "web", "flutter", "unknown")
    .default("unknown"),
  deviceId: Joi.string().trim().allow(null, ""),
});

module.exports = {
  registerDeviceTokenSchema,
};
