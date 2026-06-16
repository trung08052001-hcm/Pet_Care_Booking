const Joi = require("joi");

const imageField = Joi.string().trim().max(5500000).required().messages({
  "string.empty": "Article image is required.",
  "string.max": "Article image is too large.",
  "any.required": "Article image is required.",
});

const sectionSchema = Joi.object({
  heading: Joi.string().trim().min(2).max(240).required(),
  body: Joi.string().trim().min(5).max(2000).required(),
  image: imageField,
});

const articlePayload = {
  sourceId: Joi.string().trim().max(80).allow("", null),
  slug: Joi.string().trim().lowercase().min(2).max(240).allow("", null),
  title: Joi.string().trim().min(2).max(240).required(),
  mainCategory: Joi.string()
    .valid("Dinh dưỡng", "Sức khỏe", "Huấn luyện")
    .required(),
  category: Joi.string().trim().min(2).max(120).required(),
  tag: Joi.string().trim().max(120).allow("", null),
  image: imageField,
  author: Joi.string().trim().min(2).max(120).required(),
  publishedDate: Joi.string().trim().min(2).max(80).required(),
  readTime: Joi.string().trim().min(2).max(80).required(),
  shortDescription: Joi.string().trim().min(5).max(600).required(),
  content: Joi.object({
    intro: Joi.string().trim().min(5).max(3000).required(),
    sections: Joi.array().items(sectionSchema).min(1).max(8).required(),
    tip: Joi.string().trim().max(1000).allow("", null),
    conclusion: Joi.string().trim().max(3000).allow("", null),
  }).required(),
  sortOrder: Joi.number().integer().min(0).default(0),
  isActive: Joi.boolean().default(true),
};

const createArticleSchema = Joi.object(articlePayload);

const updateArticleSchema = Joi.object(
  Object.fromEntries(
    Object.entries(articlePayload).map(([key, schema]) => [key, schema.optional()])
  )
).min(1);

const createCommentSchema = Joi.object({
  body: Joi.string().trim().min(1).max(1000).required().messages({
    "string.empty": "Comment is required.",
    "any.required": "Comment is required.",
  }),
});

module.exports = {
  createArticleSchema,
  updateArticleSchema,
  createCommentSchema,
};
