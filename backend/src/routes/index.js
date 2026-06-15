const express = require("express");

const appReviewRoutes = require("../modules/appReviews/appReview.routes");
const authRoutes = require("../modules/auth/auth.routes");
const blogArticleRoutes = require("../modules/blogArticles/blogArticle.routes");
const bookingRoutes = require("../modules/bookings/booking.routes");
const chatRoutes = require("../modules/chat/chat.routes");
const healthRoutes = require("../modules/health/health.routes");
const helpCenterRoutes = require("../modules/helpCenter/helpCenter.routes");
const notificationRoutes = require("../modules/notifications/notification.routes");
const petRoutes = require("../modules/pets/pet.routes");
const serviceRoutes = require("../modules/services/service.routes");

const router = express.Router();

router.use("/health", healthRoutes);
router.use("/help-center", helpCenterRoutes);
router.use("/auth", authRoutes);
router.use("/blog-posts", blogArticleRoutes);
router.use("/pets", petRoutes);
router.use("/services", serviceRoutes);
router.use("/bookings", bookingRoutes);
router.use("/chat", chatRoutes);
router.use("/notifications", notificationRoutes);
router.use("/app-reviews", appReviewRoutes);

module.exports = router;
