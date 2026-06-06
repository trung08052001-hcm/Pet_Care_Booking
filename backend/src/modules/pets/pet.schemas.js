const Joi = require("joi");

const imageDataUrlField = Joi.string()
  .trim()
  .max(5500000)
  .pattern(/^data:image\/(png|jpe?g|webp);base64,[A-Za-z0-9+/=]+$/)
  .allow(null, "")
  .messages({
    "string.max": "Pet image is too large.",
    "string.pattern.base": "Pet image must be a base64 data URL.",
  });

const createPetSchema = Joi.object({
  name: Joi.string().trim().min(1).max(80).required().messages({
    "string.empty": "Pet name is required.",
    "any.required": "Pet name is required.",
  }),
  ageYears: Joi.number().min(0).max(80).required().messages({
    "number.base": "Pet age must be a number.",
    "number.min": "Pet age cannot be negative.",
    "number.max": "Pet age is too high.",
    "any.required": "Pet age is required.",
  }),
  weightKg: Joi.number().min(0.1).max(300).required().messages({
    "number.base": "Pet weight must be a number.",
    "number.min": "Pet weight must be greater than zero.",
    "number.max": "Pet weight is too high.",
    "any.required": "Pet weight is required.",
  }),
  petType: Joi.string().valid("dog", "cat", "rabbit", "bird").default("dog"),
  vaccinationStatus: Joi.string()
    .valid("vaccinated", "not_vaccinated", "unknown", "needs_booster")
    .default("unknown"),
  imageDataUrl: imageDataUrlField.default(null),
});

module.exports = {
  createPetSchema,
};
