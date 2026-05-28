const fs = require("fs");
const path = require("path");
const admin = require("firebase-admin");

const env = require("./env");

let initialized = false;

const initializeFirebaseAdmin = () => {
  if (initialized) {
    return admin;
  }

  const serviceAccountPath = path.resolve(
    process.cwd(),
    env.firebaseServiceAccountPath
  );

  if (!fs.existsSync(serviceAccountPath)) {
    throw new Error(
      `Firebase service account not found at ${serviceAccountPath}`
    );
  }

  const serviceAccount = require(serviceAccountPath);

  admin.initializeApp({
    credential: admin.credential.cert(serviceAccount),
  });

  initialized = true;
  return admin;
};

const getFirebaseAuth = () => {
  initializeFirebaseAdmin();
  return admin.auth();
};

module.exports = {
  initializeFirebaseAdmin,
  getFirebaseAuth,
};
