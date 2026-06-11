const asyncHandler = require("../../middlewares/asyncHandler");
const appReviewService = require("./appReview.service");

const createReview = asyncHandler(async (req, res) => {
  const review = await appReviewService.createReview({
    userId: req.user._id,
    rating: req.body.rating,
    comment: req.body.comment,
  });

  res.status(201).json({
    success: true,
    message: "App review submitted successfully.",
    data: { review },
  });
});

const listReviews = asyncHandler(async (req, res) => {
  const data = await appReviewService.listReviews(req.query);

  res.status(200).json({
    success: true,
    message: "App reviews fetched successfully.",
    data,
  });
});

module.exports = {
  createReview,
  listReviews,
};
