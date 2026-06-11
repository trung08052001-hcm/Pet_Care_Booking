const AppReview = require("../../models/appReview.model");

const createReview = async ({ userId, rating, comment }) => {
  const review = await AppReview.create({
    user: userId,
    rating,
    comment,
  });

  return {
    id: review._id,
    user: review.user,
    rating: review.rating,
    comment: review.comment,
    status: review.status,
    createdAt: review.createdAt,
  };
};

const listReviews = async ({ page = 1, limit = 20 }) => {
  const safePage = Math.max(Number(page) || 1, 1);
  const safeLimit = Math.min(Math.max(Number(limit) || 20, 1), 100);
  const skip = (safePage - 1) * safeLimit;

  const [items, total] = await Promise.all([
    AppReview.find()
      .sort({ createdAt: -1 })
      .skip(skip)
      .limit(safeLimit)
      .populate("user", "fullName email phone")
      .lean(),
    AppReview.countDocuments(),
  ]);

  return {
    items,
    pagination: {
      page: safePage,
      limit: safeLimit,
      total,
      totalPages: Math.ceil(total / safeLimit),
    },
  };
};

module.exports = {
  createReview,
  listReviews,
};
