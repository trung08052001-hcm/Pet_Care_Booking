const mongoose = require("mongoose");
const env = require("./env");
const User = require("../models/user.model");

const connectDatabase = async () => {
  mongoose.set("strictQuery", true);
  await mongoose.connect(env.mongoUri);

  // Recreate phone index when the partial-filter spec changes (dev-friendly).
  await User.collection.dropIndex("phone_1").catch(() => {});
  await User.syncIndexes();

  console.log("[db] MongoDB connected");
};

module.exports = connectDatabase;
