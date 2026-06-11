const asyncHandler = require("../../middlewares/asyncHandler");
const helpCenterService = require("./helpCenter.service");

const getHelpCenter = asyncHandler(async (req, res) => {
  res.status(200).json({
    success: true,
    message: "Help center fetched successfully.",
    data: helpCenterService.getHelpCenter(),
  });
});

const createFeedback = asyncHandler(async (req, res) => {
  const feedback = await helpCenterService.createFeedback({
    userId: req.user?._id,
    message: req.body.message,
  });

  res.status(201).json({
    success: true,
    message: "Feedback submitted successfully.",
    data: { feedback },
  });
});

module.exports = {
  createFeedback,
  getHelpCenter,
};
