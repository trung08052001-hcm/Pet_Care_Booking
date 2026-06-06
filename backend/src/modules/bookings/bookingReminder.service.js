const Booking = require("../../models/booking.model");
const notificationService = require("../notifications/notification.service");

const REMINDER_INTERVAL_MS = 5 * 60 * 1000;
let timer = null;

const sendReminder = async (booking, type) => {
  try {
    const label = type === "reminder_1d" ? "trước 1 ngày" : "trước 1 giờ";
    await notificationService.sendToUser(booking.user, {
      title: `Nhắc lịch ${label}`,
      body: `${booking.timeSlotLabel}, ${booking.dateKey}`,
      data: {
        type,
        bookingId: booking._id,
        status: booking.status,
      },
    });
  } catch (error) {
    console.warn("Failed to send booking reminder:", error.message);
  }
};

const processReminderWindow = async ({
  from,
  to,
  sentField,
  type,
}) => {
  const bookings = await Booking.find({
    status: "upcoming",
    appointmentDate: { $gte: from, $lte: to },
    [sentField]: null,
  }).select("user appointmentDate dateKey timeSlotLabel status");

  for (const booking of bookings) {
    await sendReminder(booking, type);
    booking[sentField] = new Date();
    await booking.save();
  }
};

const processDueReminders = async () => {
  const now = new Date();
  const inOneDay = new Date(now.getTime() + 24 * 60 * 60 * 1000);
  const inOneHour = new Date(now.getTime() + 60 * 60 * 1000);

  await processReminderWindow({
    from: inOneDay,
    to: new Date(inOneDay.getTime() + REMINDER_INTERVAL_MS),
    sentField: "reminder1dSentAt",
    type: "reminder_1d",
  });
  await processReminderWindow({
    from: inOneHour,
    to: new Date(inOneHour.getTime() + REMINDER_INTERVAL_MS),
    sentField: "reminder1hSentAt",
    type: "reminder_1h",
  });
};

const startBookingReminderScheduler = () => {
  if (timer) {
    return;
  }

  timer = setInterval(() => {
    processDueReminders().catch((error) => {
      console.warn("Booking reminder scheduler failed:", error.message);
    });
  }, REMINDER_INTERVAL_MS);
  timer.unref?.();
};

const stopBookingReminderScheduler = () => {
  if (timer) {
    clearInterval(timer);
    timer = null;
  }
};

module.exports = {
  processDueReminders,
  startBookingReminderScheduler,
  stopBookingReminderScheduler,
};
