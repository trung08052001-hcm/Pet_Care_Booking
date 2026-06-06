const Booking = require("../../models/booking.model");
const Pet = require("../../models/pet.model");
const ApiError = require("../../utils/apiError");

const SERVICE_NAMES = {
  "booking-spa": "Tắm & spa",
  "booking-grooming": "Cắt tỉa lông",
  "booking-boarding": "Lưu trú",
  "booking-health": "Khám sức khỏe",
  "booking-walking": "Dắt đi dạo",
};

const dateKeyFromDate = (date) => {
  const value = new Date(date);
  return value.toISOString().slice(0, 10);
};

const pickBooking = (booking) => {
  const pet = booking.pet || {};
  const petName = pet.name || "Thú cưng";
  const petType = pet.petType || "dog";
  const petTypeLabel = {
    dog: "Chó",
    cat: "Mèo",
    rabbit: "Thỏ",
    bird: "Chim",
  }[petType] || "Thú cưng";
  const petSubtitle = [
    petTypeLabel,
    typeof pet.ageYears === "number" ? `${pet.ageYears} tuổi` : null,
    typeof pet.weightKg === "number" ? `${pet.weightKg}kg` : null,
  ]
    .filter(Boolean)
    .join(" • ");
  const services = booking.serviceIds.map((id) => ({
    id,
    name: SERVICE_NAMES[id] || id,
    amountVnd: Math.round(booking.totalVnd / booking.serviceIds.length),
  }));

  return {
    id: booking._id,
    displayCode: `#${booking._id.toString().slice(-6).toUpperCase()}`,
    status: booking.status,
    petId: pet._id || booking.pet,
    petName,
    petSubtitle,
    petImageDataUrl: pet.imageDataUrl || null,
    services,
    appointmentDate: booking.appointmentDate,
    dateKey: booking.dateKey,
    timeSlotId: booking.timeSlotId,
    timeSlotLabel: booking.timeSlotLabel,
    locationName: "PawSitive Sanctuary",
    locationAddress: "123 Đường Hạnh Phúc, Quận 1, TP. HCM",
    subtotalVnd: booking.totalVnd,
    discountLabel: "Giảm giá",
    discountVnd: 0,
    totalVnd: booking.totalVnd,
    paymentStatusLabel: "Thanh toán tại cửa hàng",
    createdAt: booking.createdAt,
    updatedAt: booking.updatedAt,
    cancelledAt: booking.cancelledAt,
  };
};

const listBookings = async (userId) => {
  const bookings = await Booking.find({ user: userId })
    .populate("pet")
    .sort({ appointmentDate: -1, createdAt: -1 });
  return bookings.map(pickBooking);
};

const getBookingById = async (userId, bookingId) => {
  const booking = await Booking.findOne({ _id: bookingId, user: userId }).populate("pet");
  if (!booking) {
    throw new ApiError(404, "Booking not found.");
  }
  return pickBooking(booking);
};

const createBooking = async (userId, payload) => {
  const pet = await Pet.findOne({ _id: payload.petId, owner: userId });
  if (!pet) {
    throw new ApiError(404, "Pet not found.");
  }

  const appointmentDate = new Date(payload.appointmentDate);
  if (Number.isNaN(appointmentDate.getTime())) {
    throw new ApiError(400, "Appointment date is invalid.");
  }

  if (appointmentDate.getFullYear() !== 2026) {
    throw new ApiError(400, "Appointment date must be in 2026.");
  }

  const dateKey = dateKeyFromDate(appointmentDate);
  const existing = await Booking.findOne({
    dateKey,
    timeSlotId: payload.timeSlotId,
    status: { $ne: "cancelled" },
  });

  if (existing) {
    throw new ApiError(409, "This time slot has already been booked.");
  }

  try {
    const booking = await Booking.create({
      user: userId,
      pet: payload.petId,
      serviceIds: payload.serviceIds,
      appointmentDate,
      dateKey,
      timeSlotId: payload.timeSlotId,
      timeSlotLabel: payload.timeSlotLabel,
      totalVnd: payload.totalVnd,
    });
    await booking.populate("pet");
    return pickBooking(booking);
  } catch (error) {
    if (error.code === 11000) {
      throw new ApiError(409, "This time slot has already been booked.");
    }
    throw error;
  }
};

const cancelBooking = async (userId, bookingId) => {
  const booking = await Booking.findOne({ _id: bookingId, user: userId }).populate("pet");
  if (!booking) {
    throw new ApiError(404, "Booking not found.");
  }
  if (booking.status === "cancelled") {
    return pickBooking(booking);
  }
  booking.status = "cancelled";
  booking.cancelledAt = new Date();
  await booking.save();
  return pickBooking(booking);
};

const getAvailability = async ({ from, to }) => {
  const query = { status: { $ne: "cancelled" } };
  if (from || to) {
    query.dateKey = {};
    if (from) query.dateKey.$gte = String(from).slice(0, 10);
    if (to) query.dateKey.$lte = String(to).slice(0, 10);
  }

  const bookings = await Booking.find(query).select("dateKey timeSlotId");
  return bookings.map((booking) => ({
    dateKey: booking.dateKey,
    timeSlotId: booking.timeSlotId,
  }));
};

module.exports = {
  listBookings,
  getBookingById,
  createBooking,
  cancelBooking,
  getAvailability,
};
