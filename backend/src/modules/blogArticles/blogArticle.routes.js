const express = require("express");

const { authenticate, authorize } = require("../../middlewares/auth.middleware");
const validate = require("../../middlewares/validate");
const {
  createArticle,
  deleteArticle,
  addArticleComment,
  getArticleDetail,
  getArticleSocial,
  listArticles,
  registerArticleShare,
  toggleArticleLike,
  updateArticle,
} = require("./blogArticle.controller");
const {
  createCommentSchema,
  createArticleSchema,
  updateArticleSchema,
} = require("./blogArticle.schemas");

const router = express.Router();

const optionalAuthenticate = (req, res, next) => {
  if (!req.headers.authorization) {
    return next();
  }
  return authenticate(req, res, next);
};

router.get("/", optionalAuthenticate, listArticles);
router.get("/:articleId/social", optionalAuthenticate, getArticleSocial);
router.post("/:articleId/likes", authenticate, toggleArticleLike);
router.post(
  "/:articleId/comments",
  authenticate,
  validate(createCommentSchema),
  addArticleComment
);
router.post("/:articleId/shares", optionalAuthenticate, registerArticleShare);
router.post(
  "/",
  authenticate,
  authorize("admin"),
  validate(createArticleSchema),
  createArticle
);
router.patch(
  "/:articleId",
  authenticate,
  authorize("admin"),
  validate(updateArticleSchema),
  updateArticle
);
router.delete("/:articleId", authenticate, authorize("admin"), deleteArticle);
router.get("/:articleId", getArticleDetail);

module.exports = router;
