const express = require("express");

const {
  getArticleDetail,
  listArticles,
} = require("./blogArticle.controller");

const router = express.Router();

router.get("/", listArticles);
router.get("/:articleId", getArticleDetail);

module.exports = router;
