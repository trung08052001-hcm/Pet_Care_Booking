const Joi = require("joi");

const serviceImageField = Joi.string()
  .trim()
  .max(5500000)
  .required()
  .messages({
    "string.empty": "Service image is required.",
    "string.max": "Service image is too large.",
    "any.required": "Service image is required.",
  });

const servicePayload = {
  slug: Joi.string().trim().lowercase().min(2).max(120),
  title: Joi.string().trim().min(2).max(120).required().messages({
    "string.empty": "Service title is required.",
    "any.required": "Service title is required.",
  }),
  description: Joi.string().trim().min(5).max(500).required().messages({
    "string.empty": "Service description is required.",
    "any.required": "Service description is required.",
  }),
  detail: Joi.string().trim().min(5).max(1200).required().messages({
    "string.empty": "Service detail is required.",
    "any.required": "Service detail is required.",
  }),
  priceText: Joi.string().trim().min(1).max(80).required().messages({
    "string.empty": "Service price is required.",
    "any.required": "Service price is required.",
  }),
  image: serviceImageField,
  category: Joi.string().valid("all", "dog", "cat").required().messages({
    "any.only": "Service category must be all, dog or cat.",
    "any.required": "Service category is required.",
  }),
  badge: Joi.string().trim().uppercase().min(1).max(24).required().messages({
    "string.empty": "Service badge is required.",
    "any.required": "Service badge is required.",
  }),
  isActive: Joi.boolean().default(true),
  isFeatured: Joi.boolean().default(false),
  icon: Joi.string().trim().max(60).allow("", null),
  ratingText: Joi.string().trim().max(24).allow("", null),
  reviewText: Joi.string().trim().max(80).allow("", null),
  usageText: Joi.string().trim().max(80).allow("", null),
  durationText: Joi.string().trim().max(80).allow("", null),
  promo: Joi.object({
    title: Joi.string().trim().max(120).allow("", null),
    description: Joi.string().trim().max(300).allow("", null),
    discountText: Joi.string().trim().max(40).allow("", null),
    tone: Joi.string().valid("orange", "green").default("orange"),
  }).optional(),
  includedItems: Joi.array().items(Joi.string().trim().max(160)).default([]),
  benefits: Joi.array().items(Joi.string().trim().max(160)).default([]),
  noticeText: Joi.string().trim().max(300).allow("", null),
  sortOrder: Joi.number().integer().min(0).default(0),
};

const createServiceSchema = Joi.object(servicePayload);

const updateServiceSchema = Joi.object(
  Object.fromEntries(
    Object.entries(servicePayload).map(([key, schema]) => [key, schema.optional()])
  )
).min(1);

module.exports = {
  createServiceSchema,
  updateServiceSchema,
};
