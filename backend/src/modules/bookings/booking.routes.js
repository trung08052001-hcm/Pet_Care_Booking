const express = require("express");

const { createBooking, listBookings } = require("./booking.controller");

const router = express.Router();

router.get("/", listBookings);
router.post("/", createBooking);

module.exports = router;
