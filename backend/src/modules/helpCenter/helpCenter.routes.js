const express = require("express");

const { authenticate } = require("../../middlewares/auth.middleware");
const validate = require("../../middlewares/validate");
const { createFeedback, getHelpCenter } = require("./helpCenter.controller");
const { feedbackSchema } = require("./helpCenter.schemas");

const router = express.Router();

router.get("/", getHelpCenter);
router.post("/feedback", authenticate, validate(feedbackSchema), createFeedback);

module.exports = router;
