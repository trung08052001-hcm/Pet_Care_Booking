const asyncHandler = require("../../middlewares/asyncHandler");
const notificationService = require("./notification.service");

const registerDeviceToken = asyncHandler(async (req, res) => {
  await notificationService.registerDeviceToken(req.user._id, req.body);

  res.status(200).json({
    success: true,
    message: "Device token registered successfully.",
  });
});

module.exports = {
  registerDeviceToken,
};
