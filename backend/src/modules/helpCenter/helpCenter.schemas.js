const Joi = require("joi");

const feedbackSchema = Joi.object({
  message: Joi.string().trim().min(1).max(1000).required(),
});

module.exports = {
  feedbackSchema,
};
