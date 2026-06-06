const asyncHandler = require("../../middlewares/asyncHandler");
const bookingService = require("./booking.service");

const listBookings = asyncHandler(async (req, res) => {
  const bookings = await bookingService.listBookings(req.user._id);

  res.status(200).json({
    success: true,
    message: "Bookings fetched successfully.",
    data: {
      bookings,
    },
  });
});

const createBooking = asyncHandler(async (req, res) => {
  const booking = await bookingService.createBooking(req.user._id, req.body);

  res.status(201).json({
    success: true,
    message: "Booking created successfully.",
    data: {
      booking,
    },
  });
});

const getBooking = asyncHandler(async (req, res) => {
  const booking = await bookingService.getBookingById(
    req.user._id,
    req.params.bookingId
  );

  res.status(200).json({
    success: true,
    message: "Booking fetched successfully.",
    data: {
      booking,
    },
  });
});

const cancelBooking = asyncHandler(async (req, res) => {
  const booking = await bookingService.cancelBooking(
    req.user._id,
    req.params.bookingId
  );

  res.status(200).json({
    success: true,
    message: "Booking cancelled successfully.",
    data: {
      booking,
    },
  });
});

const getAvailability = asyncHandler(async (req, res) => {
  const slots = await bookingService.getAvailability(req.query);

  res.status(200).json({
    success: true,
    message: "Booking availability fetched successfully.",
    data: {
      slots,
    },
  });
});

module.exports = {
  listBookings,
  createBooking,
  getBooking,
  cancelBooking,
  getAvailability,
};
