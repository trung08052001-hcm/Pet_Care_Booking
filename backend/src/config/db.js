const mongoose = require("mongoose");
const env = require("./env");

const connectDatabase = async () => {
  mongoose.set("strictQuery", true);
  await mongoose.connect(env.mongoUri);
  console.log("[db] MongoDB connected");
};

module.exports = connectDatabase;
