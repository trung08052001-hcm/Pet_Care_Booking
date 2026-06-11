const Joi = require("joi");

const createAppReviewSchema = Joi.object({
  rating: Joi.number().integer().min(1).max(5).required(),
  comment: Joi.string().trim().min(1).max(1000).required(),
});

module.exports = {
  createAppReviewSchema,
};
