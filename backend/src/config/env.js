const path = require("path");
const dotenv = require("dotenv");

dotenv.config({ path: path.resolve(process.cwd(), ".env") });

const env = {
  nodeEnv: process.env.NODE_ENV || "development",
  port: Number(process.env.PORT) || 5000,
  apiPrefix: process.env.API_PREFIX || "/api/v1",
  mongoUri:
    process.env.MONGODB_URI || "mongodb://127.0.0.1:27017/pet-booking",
  clientUrl: process.env.CLIENT_URL || "http://localhost:3000",
  accessTokenSecret:
    process.env.ACCESS_TOKEN_SECRET || "replace-with-dev-access-secret",
  accessTokenExpiresIn: process.env.ACCESS_TOKEN_EXPIRES_IN || "15m",
  refreshTokenSecret:
    process.env.REFRESH_TOKEN_SECRET || "replace-with-dev-refresh-secret",
  refreshTokenExpiresIn: process.env.REFRESH_TOKEN_EXPIRES_IN || "7d",
  zaloAppId: process.env.ZALO_APP_ID || "",
  zaloAppSecret: process.env.ZALO_APP_SECRET || "",
  zaloCallbackUrl: process.env.ZALO_CALLBACK_URL || "",
  firebaseServiceAccountPath:
    process.env.FIREBASE_SERVICE_ACCOUNT_PATH ||
    "src/firebase/serviceAccountKey.json",
  googleOAuthClientIds: process.env.GOOGLE_OAUTH_CLIENT_IDS || "",
};

module.exports = env;
