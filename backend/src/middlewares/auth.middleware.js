const User = require("../models/user.model");
const ApiError = require("../utils/apiError");
const { verifyAccessToken } = require("../utils/token");

const authenticate = async (req, res, next) => {
  const authHeader = req.headers.authorization || "";

  if (!authHeader.startsWith("Bearer ")) {
    return next(new ApiError(401, "Authorization token is required."));
  }

  const token = authHeader.split(" ")[1];

  try {
    const payload = verifyAccessToken(token);

    if (payload.type !== "access") {
      return next(new ApiError(401, "Invalid access token."));
    }

    const user = await User.findById(payload.sub);

    if (!user || !user.isActive) {
      return next(new ApiError(401, "User is not authorized."));
    }

    req.user = user;
    next();
  } catch (error) {
    next(new ApiError(401, "Invalid or expired access token."));
  }
};

const authorize = (...roles) => (req, res, next) => {
  if (!req.user) {
    return next(new ApiError(401, "Authentication is required."));
  }

  if (!roles.includes(req.user.role)) {
    return next(new ApiError(403, "You do not have access to this resource."));
  }

  next();
};

module.exports = {
  authenticate,
  authorize,
};
