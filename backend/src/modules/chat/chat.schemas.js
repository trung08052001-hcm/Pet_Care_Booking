const Joi = require("joi");

const sendMessageSchema = Joi.object({
  text: Joi.string().trim().min(1).max(2000).required().messages({
    "any.required": "Message text is required.",
    "string.empty": "Message text is required.",
  }),
});

module.exports = {
  sendMessageSchema,
};
