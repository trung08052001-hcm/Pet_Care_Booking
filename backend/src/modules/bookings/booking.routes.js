const express = require("express");

const { authenticate } = require("../../middlewares/auth.middleware");
const validate = require("../../middlewares/validate");
const {
  cancelBooking,
  createBooking,
  getAvailability,
  getBooking,
  listBookings,
} = require("./booking.controller");
const { createBookingSchema } = require("./booking.schemas");

const router = express.Router();

router.use(authenticate);

router.get("/availability", getAvailability);
router.get("/", listBookings);
router.post("/", validate(createBookingSchema), createBooking);
router.get("/:bookingId", getBooking);
router.patch("/:bookingId/cancel", cancelBooking);

module.exports = router;
