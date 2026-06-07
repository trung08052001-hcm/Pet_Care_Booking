const asyncHandler = require("../../middlewares/asyncHandler");
const notificationService = require("./notification.service");

const registerDeviceToken = asyncHandler(async (req, res) => {
  await notificationService.registerDeviceToken(req.user._id, req.body);

  res.status(200).json({
    success: true,
    message: "Device token registered successfully.",
  });
});

const sendTestNotification = asyncHandler(async (req, res) => {
  const result = await notificationService.sendToUser(req.user._id, {
    title: req.body.title || "Test notification",
    body: req.body.body || "Firebase Cloud Messaging is working.",
    data: {
      type: "developer_test",
      sentAt: new Date().toISOString(),
    },
  });

  res.status(200).json({
    success: true,
    message: "Test notification sent.",
    data: result,
  });
});

module.exports = {
  registerDeviceToken,
  sendTestNotification,
};
