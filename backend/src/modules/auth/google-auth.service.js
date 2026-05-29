const { OAuth2Client } = require("google-auth-library");

const ApiError = require("../../utils/apiError");
const env = require("../../config/env");
const { getFirebaseAuth } = require("../../config/firebase");

const DEFAULT_GOOGLE_CLIENT_IDS = [
  "674702415842-qp6pb8fg2tf0eujddj4o97mtobug60lm.apps.googleusercontent.com",
  "674702415842-aob7322jl4932pau902kgc3tqmt3kimf.apps.googleusercontent.com",
];

const getGoogleOAuthClientIds = () => {
  if (!env.googleOAuthClientIds) {
    return DEFAULT_GOOGLE_CLIENT_IDS;
  }

  return env.googleOAuthClientIds
    .split(",")
    .map((value) => value.trim())
    .filter(Boolean);
};

const decodeTokenPayload = (idToken) => {
  const parts = String(idToken || "").split(".");
  if (parts.length < 2) {
    return null;
  }

  try {
    const payload = parts[1].replace(/-/g, "+").replace(/_/g, "/");
    const padded = payload.padEnd(payload.length + ((4 - (payload.length % 4)) % 4), "=");
    return JSON.parse(Buffer.from(padded, "base64").toString("utf8"));
  } catch {
    return null;
  }
};

const mapGoogleProfile = ({ uid, email, fullName, avatar, emailVerified }) => ({
  uid,
  email: String(email).toLowerCase(),
  fullName: fullName || String(email).split("@")[0],
  avatar: avatar || null,
  emailVerified: emailVerified === true,
});

const verifyFirebaseIdToken = async (idToken) => {
  try {
    const decoded = await getFirebaseAuth().verifyIdToken(idToken, true);

    if (!decoded.email) {
      throw new ApiError(400, "Google account does not include an email.");
    }

    return mapGoogleProfile({
      uid: decoded.uid,
      email: decoded.email,
      fullName: decoded.name,
      avatar: decoded.picture,
      emailVerified: decoded.email_verified,
    });
  } catch (error) {
    if (error instanceof ApiError) {
      throw error;
    }

    const message =
      env.nodeEnv === "development" && error?.message
        ? `Firebase token verification failed: ${error.message}`
        : "Invalid or expired Google ID token.";

    throw new ApiError(401, message);
  }
};

const verifyGoogleOAuthIdToken = async (idToken) => {
  const client = new OAuth2Client();

  try {
    const ticket = await client.verifyIdToken({
      idToken,
      audience: getGoogleOAuthClientIds(),
    });
    const payload = ticket.getPayload();

    if (!payload?.email) {
      throw new ApiError(400, "Google account does not include an email.");
    }

    return mapGoogleProfile({
      uid: payload.sub,
      email: payload.email,
      fullName: payload.name,
      avatar: payload.picture,
      emailVerified: payload.email_verified,
    });
  } catch (error) {
    if (error instanceof ApiError) {
      throw error;
    }

    const message =
      env.nodeEnv === "development" && error?.message
        ? `Google token verification failed: ${error.message}`
        : "Invalid or expired Google ID token.";

    throw new ApiError(401, message);
  }
};

const verifyGoogleIdToken = async (idToken) => {
  const payload = decodeTokenPayload(idToken);
  const issuer = payload?.iss || "";

  if (issuer.includes("securetoken.google.com")) {
    return verifyFirebaseIdToken(idToken);
  }

  if (issuer === "accounts.google.com" || issuer === "https://accounts.google.com") {
    return verifyGoogleOAuthIdToken(idToken);
  }

  throw new ApiError(401, "Unsupported Google ID token issuer.");
};

module.exports = {
  verifyGoogleIdToken,
};
