const express = require("express");
const cors = require("cors");
const helmet = require("helmet");
const morgan = require("morgan");
const compression = require("compression");
const rateLimit = require("express-rate-limit");

const env = require("./config/env");
const apiRoutes = require("./routes");
const notFound = require("./middlewares/notFound");
const errorHandler = require("./middlewares/errorHandler");

const app = express();

const allowedOrigins = env.clientUrl
  .split(",")
  .map((origin) => origin.trim())
  .filter(Boolean);

const localhostPattern =
  /^https?:\/\/(localhost|127\.0\.0\.1)(:\d+)?$/i;
const lanPattern =
  /^https?:\/\/192\.168\.\d{1,3}\.\d{1,3}(:\d+)?$/i;

const isAllowedOrigin = (origin) => {
  if (!origin) {
    return true;
  }

  if (allowedOrigins.includes(origin)) {
    return true;
  }

  return localhostPattern.test(origin) || lanPattern.test(origin);
};

app.use(helmet());
app.use(
  cors({
    origin(origin, callback) {
      if (isAllowedOrigin(origin)) {
        return callback(null, true);
      }

      return callback(new Error("CORS origin is not allowed."));
    },
    credentials: true,
  })
);
app.use(
  rateLimit({
    windowMs: 15 * 60 * 1000,
    max: 200,
    standardHeaders: true,
    legacyHeaders: false,
  })
);
app.use(compression());
app.use(morgan(env.nodeEnv === "production" ? "combined" : "dev"));
app.use(express.json({ limit: "30mb" }));
app.use(express.urlencoded({ extended: true, limit: "30mb" }));

app.get("/", (req, res) => {
  res.status(200).json({
    success: true,
    message: "Welcome to the pet booking backend API.",
    docs: `${env.apiPrefix}/health`,
  });
});

app.use(env.apiPrefix, apiRoutes);
app.use(notFound);
app.use(errorHandler);

module.exports = app;
