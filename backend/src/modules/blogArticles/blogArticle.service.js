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

const slugify = (value) =>
  String(value || "")
    .normalize("NFD")
    .replace(/[\u0300-\u036f]/g, "")
    .toLowerCase()
    .replace(/[^a-z0-9]+/g, "-")
    .replace(/^-+|-+$/g, "")
    .slice(0, 120);

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
  likeCount: article.likedBy?.length || 0,
  commentCount: article.comments?.length || 0,
  shareCount: article.shareCount || 0,
  createdAt: article.createdAt,
  updatedAt: article.updatedAt,
});

const mapComment = (comment) => ({
  id: comment._id.toString(),
  userId: comment.user?.toString?.() || String(comment.user),
  userName: comment.userName,
  userAvatar: comment.userAvatar || "",
  body: comment.body,
  createdAt: comment.createdAt,
});

const mapSocial = (article, userId) => {
  const currentUserId = userId?.toString();
  return {
    likeCount: article.likedBy?.length || 0,
    commentCount: article.comments?.length || 0,
    shareCount: article.shareCount || 0,
    likedByMe: Boolean(
      currentUserId &&
        article.likedBy?.some((likedUserId) => likedUserId.toString() === currentUserId)
    ),
    comments: [...(article.comments || [])]
      .sort((a, b) => new Date(a.createdAt) - new Date(b.createdAt))
      .map(mapComment),
  };
};

const ensureSeedArticles = async () => {
  const count = await BlogArticle.estimatedDocumentCount();

  if (count === 0) {
    await BlogArticle.insertMany(seedArticles.map(normalizeSeedArticle));
    return;
  }

  await Promise.all(
    seedArticles.map(async (article, index) => {
      await BlogArticle.updateOne(
        {
          $or: [{ sourceId: article.id }, { slug: article.slug }],
        },
        {
          $set: normalizeSeedArticle(article, index),
        }
      );
    })
  );
};

const buildArticleQuery = (query = {}, options = {}) => {
  const filter = {
    ...(options.includeInactive ? {} : { isActive: true }),
  };

  if (query.mainCategory) {
    filter.mainCategory = query.mainCategory;
  }

  return filter;
};

const listArticles = async (query = {}, options = {}) => {
  await ensureSeedArticles();

  const limit = Math.min(
    Math.max(Number.parseInt(query.limit, 10) || 5, 1),
    40
  );
  const articles = await BlogArticle.find(buildArticleQuery(query, options))
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

const findArticleForSocial = async (articleId) => {
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
  });

  if (!article) {
    throw new ApiError(404, "Blog article not found.");
  }

  return article;
};

const getArticleSocial = async (articleId, userId) => {
  await ensureSeedArticles();
  const article = await findArticleForSocial(articleId);
  return mapSocial(article, userId);
};

const toggleArticleLike = async (articleId, userId) => {
  const article = await findArticleForSocial(articleId);
  const likedIndex = article.likedBy.findIndex(
    (likedUserId) => likedUserId.toString() === userId.toString()
  );

  if (likedIndex >= 0) {
    article.likedBy.splice(likedIndex, 1);
  } else {
    article.likedBy.push(userId);
  }

  await article.save();
  return mapSocial(article, userId);
};

const addArticleComment = async (articleId, user, body) => {
  const article = await findArticleForSocial(articleId);
  article.comments.push({
    user: user._id,
    userName: user.fullName,
    userAvatar: user.avatar || "",
    body,
  });

  await article.save();
  return mapSocial(article, user._id);
};

const registerArticleShare = async (articleId, userId) => {
  const article = await findArticleForSocial(articleId);
  article.shareCount += 1;
  await article.save();
  return mapSocial(article, userId);
};

const createArticle = async (payload) => {
  await ensureSeedArticles();

  const slug = payload.slug || slugify(payload.title);
  const article = await BlogArticle.create({
    ...payload,
    sourceId: payload.sourceId || `admin-${Date.now()}`,
    slug,
    sortOrder: payload.sortOrder || 0,
    isActive: payload.isActive !== false,
  });

  return mapArticle(article);
};

const updateArticle = async (articleId, payload) => {
  await ensureSeedArticles();

  const updatePayload = {
    ...payload,
    ...(payload.title && !payload.slug ? { slug: slugify(payload.title) } : {}),
  };

  const query = /^[a-f\d]{24}$/i.test(articleId)
    ? { _id: articleId }
    : {
        $or: [
          { slug: articleId },
          { sourceId: articleId },
        ],
      };

  const article = await BlogArticle.findOneAndUpdate(
    query,
    { $set: updatePayload },
    { new: true, runValidators: true }
  );

  if (!article) {
    throw new ApiError(404, "Blog article not found.");
  }

  return mapArticle(article);
};

const deleteArticle = async (articleId) => {
  const query = /^[a-f\d]{24}$/i.test(articleId)
    ? { _id: articleId }
    : {
        $or: [
          { slug: articleId },
          { sourceId: articleId },
        ],
      };

  const article = await BlogArticle.findOneAndDelete(query);

  if (!article) {
    throw new ApiError(404, "Blog article not found.");
  }
};

module.exports = {
  listArticles,
  getArticleByIdOrSlug,
  getArticleSocial,
  toggleArticleLike,
  addArticleComment,
  registerArticleShare,
  createArticle,
  updateArticle,
  deleteArticle,
};
