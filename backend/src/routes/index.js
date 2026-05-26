const express = require("express");

const authRoutes = require("../modules/auth/auth.routes");
const bookingRoutes = require("../modules/bookings/booking.routes");
const healthRoutes = require("../modules/health/health.routes");
const petRoutes = require("../modules/pets/pet.routes");
const serviceRoutes = require("../modules/services/service.routes");

const router = express.Router();

router.use("/health", healthRoutes);
router.use("/auth", authRoutes);
router.use("/pets", petRoutes);
router.use("/services", serviceRoutes);
router.use("/bookings", bookingRoutes);

module.exports = router;
