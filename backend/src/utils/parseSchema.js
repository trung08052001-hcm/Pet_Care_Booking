const ApiError = require("./apiError");

const formatJoiMessage = (error) =>
  error.details
    .map((detail) => detail.message.replace(/"/g, ""))
    .join(", ");

const parseSchema = (schema, payload, options = {}) => {
  const { error, value } = schema.validate(payload, {
    abortEarly: false,
    stripUnknown: true,
    convert: true,
    ...options,
  });

  if (error) {
    throw new ApiError(400, formatJoiMessage(error));
  }

  return value;
};

module.exports = {
  parseSchema,
  formatJoiMessage,
};
