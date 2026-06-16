const asyncHandler = require("../../middlewares/asyncHandler");
const blogArticleService = require("./blogArticle.service");

const listArticles = asyncHandler(async (req, res) => {
  const articles = await blogArticleService.listArticles(req.query, {
    includeInactive: req.user?.role === "admin",
  });

  res.status(200).json({
    success: true,
    message: "Blog articles fetched successfully.",
    data: {
      articles,
    },
  });
});

const getArticleDetail = asyncHandler(async (req, res) => {
  const article = await blogArticleService.getArticleByIdOrSlug(
    req.params.articleId
  );

  res.status(200).json({
    success: true,
    message: "Blog article fetched successfully.",
    data: {
      article,
    },
  });
});

const getArticleSocial = asyncHandler(async (req, res) => {
  const social = await blogArticleService.getArticleSocial(
    req.params.articleId,
    req.user?._id
  );

  res.status(200).json({
    success: true,
    message: "Blog article social data fetched successfully.",
    data: {
      social,
    },
  });
});

const toggleArticleLike = asyncHandler(async (req, res) => {
  const social = await blogArticleService.toggleArticleLike(
    req.params.articleId,
    req.user._id
  );

  res.status(200).json({
    success: true,
    message: "Blog article like updated successfully.",
    data: {
      social,
    },
  });
});

const addArticleComment = asyncHandler(async (req, res) => {
  const social = await blogArticleService.addArticleComment(
    req.params.articleId,
    req.user,
    req.body.body
  );

  res.status(201).json({
    success: true,
    message: "Blog article comment created successfully.",
    data: {
      social,
    },
  });
});

const registerArticleShare = asyncHandler(async (req, res) => {
  const social = await blogArticleService.registerArticleShare(
    req.params.articleId,
    req.user?._id
  );

  res.status(200).json({
    success: true,
    message: "Blog article share registered successfully.",
    data: {
      social,
    },
  });
});

const createArticle = asyncHandler(async (req, res) => {
  const article = await blogArticleService.createArticle(req.body);

  res.status(201).json({
    success: true,
    message: "Blog article created successfully.",
    data: {
      article,
    },
  });
});

const updateArticle = asyncHandler(async (req, res) => {
  const article = await blogArticleService.updateArticle(
    req.params.articleId,
    req.body
  );

  res.status(200).json({
    success: true,
    message: "Blog article updated successfully.",
    data: {
      article,
    },
  });
});

const deleteArticle = asyncHandler(async (req, res) => {
  await blogArticleService.deleteArticle(req.params.articleId);

  res.status(200).json({
    success: true,
    message: "Blog article deleted successfully.",
    data: null,
  });
});

module.exports = {
  listArticles,
  getArticleDetail,
  getArticleSocial,
  toggleArticleLike,
  addArticleComment,
  registerArticleShare,
  createArticle,
  updateArticle,
  deleteArticle,
};
