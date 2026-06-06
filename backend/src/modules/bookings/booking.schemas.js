const Joi = require("joi");

const createBookingSchema = Joi.object({
  petId: Joi.string().trim().required().messages({
    "any.required": "Pet is required.",
    "string.empty": "Pet is required.",
  }),
  serviceIds: Joi.array().items(Joi.string().trim().min(1)).min(1).required(),
  appointmentDate: Joi.date().iso().required().messages({
    "date.base": "Appointment date is invalid.",
    "any.required": "Appointment date is required.",
  }),
  timeSlotId: Joi.string().trim().min(1).required(),
  timeSlotLabel: Joi.string().trim().min(1).required(),
  totalVnd: Joi.number().integer().min(0).required(),
});

module.exports = {
  createBookingSchema,
};
