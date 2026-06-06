const express = require("express");

const { authenticate } = require("../../middlewares/auth.middleware");
const validate = require("../../middlewares/validate");
const { registerDeviceToken } = require("./notification.controller");
const { registerDeviceTokenSchema } = require("./notification.schemas");

const router = express.Router();

router.use(authenticate);
router.post(
  "/device-token",
  validate(registerDeviceTokenSchema),
  registerDeviceToken
);

module.exports = router;
