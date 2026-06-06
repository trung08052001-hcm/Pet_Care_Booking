const mongoose = require("mongoose");

const app = require("./app");
const env = require("./config/env");
const connectDatabase = require("./config/db");
const {
  startBookingReminderScheduler,
  stopBookingReminderScheduler,
} = require("./modules/bookings/bookingReminder.service");

const startServer = async () => {
  await connectDatabase();

  const server = app.listen(env.port, () => {
    console.log(`[server] Listening on port ${env.port}`);
  });
  startBookingReminderScheduler();

  const shutdown = (signal) => {
    console.log(`[server] ${signal} received, shutting down...`);

    server.close(async () => {
      stopBookingReminderScheduler();
      await mongoose.connection.close();
      process.exit(0);
    });
  };

  process.on("SIGINT", () => shutdown("SIGINT"));
  process.on("SIGTERM", () => shutdown("SIGTERM"));
};

startServer().catch((error) => {
  console.error("[server] Failed to start application", error);
  process.exit(1);
});
