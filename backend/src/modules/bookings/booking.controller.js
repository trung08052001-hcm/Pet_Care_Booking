const listBookings = (req, res) => {
  res.status(501).json({
    success: false,
    message: "Booking module is not implemented yet.",
  });
};

const createBooking = (req, res) => {
  res.status(501).json({
    success: false,
    message: "Create booking endpoint is not implemented yet.",
  });
};

module.exports = {
  listBookings,
  createBooking,
};
