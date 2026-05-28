const ApiError = require("../../utils/apiError");
const { getFirebaseAuth } = require("../../config/firebase");

const verifyGoogleIdToken = async (idToken) => {
  try {
    const decoded = await getFirebaseAuth().verifyIdToken(idToken, true);

    if (!decoded.email) {
      throw new ApiError(400, "Google account does not include an email.");
    }

    return {
      uid: decoded.uid,
      email: decoded.email.toLowerCase(),
      fullName: decoded.name || decoded.email.split("@")[0],
      avatar: decoded.picture || null,
      emailVerified: decoded.email_verified === true,
    };
  } catch (error) {
    if (error instanceof ApiError) {
      throw error;
    }

    throw new ApiError(401, "Invalid or expired Google ID token.");
  }
};

module.exports = {
  verifyGoogleIdToken,
};
