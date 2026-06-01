const errorHandler = (err, req, res, next) => {
  if (res.headersSent) {
    return next(err);
  }

  let statusCode = err.statusCode || 500;
  let message = err.message || "Internal server error";

  if (err.isJoi) {
    statusCode = 400;
    message = err.details
      .map((detail) => detail.message.replace(/"/g, ""))
      .join(", ");
  }

  if (err.name === "ValidationError") {
    statusCode = 400;
    message = Object.values(err.errors)
      .map((item) => item.message)
      .join(", ");
  }

  if (err.code === 11000) {
    statusCode = 409;
    const duplicateField = Object.keys(err.keyPattern || {})[0];
    if (duplicateField === "email") {
      message =
        "This email is already registered. Sign in with your password or use the same Google account.";
    } else if (duplicateField === "phone") {
      message = "This phone number is already registered.";
    } else {
      message = "Duplicate value detected.";
    }
  }

  if (err.name === "CastError") {
    statusCode = 400;
    message = `Invalid ${err.path}: ${err.value}`;
  }

  res.status(statusCode).json({
    success: false,
    message,
    stack: process.env.NODE_ENV === "development" ? err.stack : undefined,
  });
};

module.exports = errorHandler;
