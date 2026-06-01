const ApiError = require("../utils/apiError");
const { formatJoiMessage } = require("../utils/parseSchema");

/**
 * Express middleware — validates req[property] with a Joi schema.
 * Sanitized value is written back to req[property].
 */
const validate =
  (schema, property = "body") =>
  (req, res, next) => {
    const { error, value } = schema.validate(req[property], {
      abortEarly: false,
      stripUnknown: true,
      convert: true,
    });

    if (error) {
      return next(new ApiError(400, formatJoiMessage(error)));
    }

    req[property] = value;
    return next();
  };

module.exports = validate;
