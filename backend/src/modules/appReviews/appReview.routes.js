const express = require("express");

const { authenticate, authorize } = require("../../middlewares/auth.middleware");
const validate = require("../../middlewares/validate");
const { createReview, listReviews } = require("./appReview.controller");
const { createAppReviewSchema } = require("./appReview.schemas");

const router = express.Router();

router.use(authenticate);

router.post("/", validate(createAppReviewSchema), createReview);
router.get("/", authorize("admin"), listReviews);

module.exports = router;
