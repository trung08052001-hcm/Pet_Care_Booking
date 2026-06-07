const express = require("express");

const { authenticate } = require("../../middlewares/auth.middleware");
const validate = require("../../middlewares/validate");
const {
  registerDeviceToken,
  sendTestNotification,
} = require("./notification.controller");
const {
  registerDeviceTokenSchema,
  testNotificationSchema,
} = require("./notification.schemas");

const router = express.Router();

router.use(authenticate);
router.post(
  "/device-token",
  validate(registerDeviceTokenSchema),
  registerDeviceToken
);
router.post("/test", validate(testNotificationSchema), sendTestNotification);

module.exports = router;
