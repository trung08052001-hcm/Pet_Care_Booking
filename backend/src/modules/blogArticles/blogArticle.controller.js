const asyncHandler = require("../../middlewares/asyncHandler");
const blogArticleService = require("./blogArticle.service");

const listArticles = asyncHandler(async (req, res) => {
  const articles = await blogArticleService.listArticles(req.query);

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

module.exports = {
  listArticles,
  getArticleDetail,
};
