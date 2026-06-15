const BlogArticle = require("../../models/blogArticle.model");
const ApiError = require("../../utils/apiError");
const seedArticles = require("./blogArticle.seed.json");

const normalizeSeedArticle = (article, index) => ({
  sourceId: article.id,
  title: article.title,
  slug: article.slug,
  mainCategory: article.mainCategory,
  category: article.category,
  tag: article.tag,
  image: article.image,
  author: article.author,
  publishedDate: article.publishedDate,
  readTime: article.readTime,
  shortDescription: article.shortDescription,
  content: article.content,
  sortOrder: index + 1,
  isActive: true,
});

const mapArticle = (article) => ({
  id: article._id.toString(),
  sourceId: article.sourceId,
  title: article.title,
  slug: article.slug,
  mainCategory: article.mainCategory,
  category: article.category,
  tag: article.tag,
  image: article.image,
  author: article.author,
  publishedDate: article.publishedDate,
  readTime: article.readTime,
  shortDescription: article.shortDescription,
  content: article.content,
  sortOrder: article.sortOrder,
  createdAt: article.createdAt,
  updatedAt: article.updatedAt,
});

const ensureSeedArticles = async () => {
  const count = await BlogArticle.estimatedDocumentCount();

  if (count === 0) {
    await BlogArticle.insertMany(seedArticles.map(normalizeSeedArticle));
    return;
  }

  await Promise.all(
    seedArticles.map(async (article, index) => {
      const existing = await BlogArticle.exists({
        $or: [{ sourceId: article.id }, { slug: article.slug }],
      });

      if (!existing) {
        await BlogArticle.create(normalizeSeedArticle(article, index));
      }
    })
  );
};

const buildArticleQuery = (query = {}) => {
  const filter = {
    isActive: true,
  };

  if (query.mainCategory) {
    filter.mainCategory = query.mainCategory;
  }

  return filter;
};

const listArticles = async (query = {}) => {
  await ensureSeedArticles();

  const limit = Math.min(
    Math.max(Number.parseInt(query.limit, 10) || 5, 1),
    40
  );
  const articles = await BlogArticle.find(buildArticleQuery(query))
    .sort({ sortOrder: 1, createdAt: 1 })
    .limit(limit)
    .lean();

  return articles.map(mapArticle);
};

const getArticleByIdOrSlug = async (articleId) => {
  await ensureSeedArticles();

  const query = /^[a-f\d]{24}$/i.test(articleId)
    ? { _id: articleId }
    : {
        $or: [
          { slug: articleId },
          { sourceId: articleId },
        ],
      };

  const article = await BlogArticle.findOne({
    ...query,
    isActive: true,
  }).lean();

  if (!article) {
    throw new ApiError(404, "Blog article not found.");
  }

  return mapArticle(article);
};

module.exports = {
  listArticles,
  getArticleByIdOrSlug,
};
