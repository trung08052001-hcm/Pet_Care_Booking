const mongoose = require("mongoose");
const http = require("http");
const { Server } = require("socket.io");

const app = require("./app");
const env = require("./config/env");
const connectDatabase = require("./config/db");
const { initializeChatSocket } = require("./socket/chatSocket");
const {
  startBookingReminderScheduler,
  stopBookingReminderScheduler,
} = require("./modules/bookings/bookingReminder.service");

const startServer = async () => {
  await connectDatabase();

  const server = http.createServer(app);
  const io = new Server(server, {
    cors: {
      origin: true,
      credentials: true,
    },
  });

  initializeChatSocket(io);

  server.listen(env.port, () => {
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
