const mongoose = require("mongoose");

const env = require("../src/config/env");
const User = require("../src/models/user.model");

const seedAdmin = async () => {
  const email = process.env.ADMIN_EMAIL || "admin@pawcare.local";
  const password = process.env.ADMIN_PASSWORD || "Admin@123456";
  const fullName = process.env.ADMIN_FULL_NAME || "PawCare Admin";
  const phone = process.env.ADMIN_PHONE || "";

  await mongoose.connect(env.mongoUri);

  let user = await User.findOne({ email }).select("+password");

  if (!user) {
    user = new User({
      fullName,
      email,
      password,
      phone,
      role: "admin",
      authProvider: "local",
      acceptedTermsAt: new Date(),
      isActive: true,
    });
  } else {
    user.fullName = user.fullName || fullName;
    user.phone = user.phone || phone;
    user.role = "admin";
    user.authProvider = "local";
    user.isActive = true;
    user.password = password;
    user.acceptedTermsAt = user.acceptedTermsAt || new Date();
  }

  await user.save();

  console.log(
    JSON.stringify(
      {
        message: "Admin account is ready.",
        email: user.email,
        password,
        role: user.role,
      },
      null,
      2
    )
  );

  await mongoose.connection.close();
};

seedAdmin().catch(async (error) => {
  console.error(error);

  try {
    await mongoose.connection.close();
  } catch (_) {
    // Ignore shutdown errors in a failed seed command.
  }

  process.exit(1);
});
