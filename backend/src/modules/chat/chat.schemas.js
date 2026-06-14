const Joi = require("joi");

const attachmentSchema = Joi.object({
  type: Joi.string().valid("image", "file").required(),
  name: Joi.string().trim().min(1).max(180).required(),
  dataUrl: Joi.string().trim().min(1).max(8 * 1024 * 1024).required(),
  mimeType: Joi.string().trim().allow("").max(120),
  sizeBytes: Joi.number().integer().min(0).max(5 * 1024 * 1024),
});

const sendMessageSchema = Joi.object({
  text: Joi.string().trim().allow("").max(2000).default(""),
  attachments: Joi.array().items(attachmentSchema).max(1).default([]),
}).custom((value, helpers) => {
  const text = String(value.text || "").trim();
  if (!text && value.attachments.length === 0) {
    return helpers.error("any.custom", {
      message: "Message text or attachment is required.",
    });
  }

  return {
    ...value,
    text,
  };
});

module.exports = {
  sendMessageSchema,
};
