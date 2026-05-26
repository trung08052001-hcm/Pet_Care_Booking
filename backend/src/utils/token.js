const crypto = require("crypto");

const env = require("../config/env");

const parseExpiresIn = (value) => {
  const normalizedValue = String(value || "").trim().toLowerCase();
  const match = normalizedValue.match(/^(\d+)([smhd])?$/);

  if (!match) {
    throw new Error(`Unsupported expiresIn format: ${value}`);
  }

  const amount = Number(match[1]);
  const unit = match[2] || "s";
  const multiplierMap = {
    s: 1,
    m: 60,
    h: 60 * 60,
    d: 60 * 60 * 24,
  };

  return amount * multiplierMap[unit];
};

const encodeBase64Url = (value) =>
  Buffer.from(JSON.stringify(value)).toString("base64url");

const decodeBase64Url = (value) =>
  JSON.parse(Buffer.from(value, "base64url").toString("utf8"));

const signToken = (payload, secret, expiresIn) => {
  const nowInSeconds = Math.floor(Date.now() / 1000);
  const header = {
    alg: "HS256",
    typ: "JWT",
  };
  const signedPayload = {
    ...payload,
    iat: nowInSeconds,
    exp: nowInSeconds + parseExpiresIn(expiresIn),
  };
  const encodedHeader = encodeBase64Url(header);
  const encodedPayload = encodeBase64Url(signedPayload);
  const unsignedToken = `${encodedHeader}.${encodedPayload}`;
  const signature = crypto
    .createHmac("sha256", secret)
    .update(unsignedToken)
    .digest("base64url");

  return `${unsignedToken}.${signature}`;
};

const verifyToken = (token, secret) => {
  const tokenParts = String(token || "").split(".");

  if (tokenParts.length !== 3) {
    throw new Error("Invalid token format.");
  }

  const [encodedHeader, encodedPayload, signature] = tokenParts;
  const unsignedToken = `${encodedHeader}.${encodedPayload}`;
  const expectedSignature = crypto
    .createHmac("sha256", secret)
    .update(unsignedToken)
    .digest("base64url");
  const signatureBuffer = Buffer.from(signature);
  const expectedSignatureBuffer = Buffer.from(expectedSignature);

  if (
    signatureBuffer.length !== expectedSignatureBuffer.length ||
    !crypto.timingSafeEqual(signatureBuffer, expectedSignatureBuffer)
  ) {
    throw new Error("Invalid token signature.");
  }

  const payload = decodeBase64Url(encodedPayload);

  if (payload.exp && payload.exp < Math.floor(Date.now() / 1000)) {
    throw new Error("Token has expired.");
  }

  return payload;
};

const signAccessToken = (user) =>
  signToken(
    {
      sub: user._id.toString(),
      role: user.role,
      type: "access",
    },
    env.accessTokenSecret,
    env.accessTokenExpiresIn
  );

const signRefreshToken = ({ userId, sessionId }) =>
  signToken(
    {
      sub: userId,
      sessionId,
      type: "refresh",
    },
    env.refreshTokenSecret,
    env.refreshTokenExpiresIn
  );

const verifyAccessToken = (token) => verifyToken(token, env.accessTokenSecret);

const verifyRefreshToken = (token) =>
  verifyToken(token, env.refreshTokenSecret);

const createTokenHash = (token) =>
  crypto.createHash("sha256").update(token).digest("hex");

const getTokenExpiryDate = (token) => {
  const [, encodedPayload] = String(token || "").split(".");
  const decoded = encodedPayload ? decodeBase64Url(encodedPayload) : null;

  if (!decoded || !decoded.exp) {
    throw new Error("Unable to determine token expiry.");
  }

  return new Date(decoded.exp * 1000);
};

module.exports = {
  signAccessToken,
  signRefreshToken,
  verifyAccessToken,
  verifyRefreshToken,
  createTokenHash,
  getTokenExpiryDate,
};
