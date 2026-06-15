const Service = require("../../models/service.model");
const ApiError = require("../../utils/apiError");
const { sampleServices } = require("./service.seed");

const mapService = (service) => ({
  id: service._id.toString(),
  slug: service.slug,
  title: service.title,
  description: service.description,
  detail: service.detail,
  priceText: service.priceText,
  image: service.image,
  category: service.category,
  badge: service.badge,
  isActive: service.isActive,
  isFeatured: service.isFeatured,
  icon: service.icon,
  ratingText: service.ratingText,
  reviewText: service.reviewText,
  usageText: service.usageText,
  durationText: service.durationText,
  promo: service.promo,
  includedItems: service.includedItems || [],
  benefits: service.benefits || [],
  noticeText: service.noticeText,
  sortOrder: service.sortOrder,
  createdAt: service.createdAt,
  updatedAt: service.updatedAt,
});

const ensureSeedServices = async () => {
  const count = await Service.estimatedDocumentCount();
  if (count === 0) {
    await Service.insertMany(sampleServices);
    return;
  }

  await Promise.all(
    sampleServices.map(async (service) => {
      const existing = await Service.exists({
        $or: [
          ...(service.slug ? [{ slug: service.slug }] : []),
          { title: service.title },
        ],
      });

      if (!existing) {
        await Service.create(service);
      }
    })
  );
};

const buildListQuery = (query = {}, options = {}) => {
  const filter = {};

  if (query.category && ["all", "dog", "cat"].includes(query.category)) {
    filter.category = query.category;
  }

  if (!options.includeInactive) {
    filter.isActive = true;
  } else if (typeof query.isActive !== "undefined") {
    filter.isActive = query.isActive === true || query.isActive === "true";
  }

  return filter;
};

const listServices = async (query = {}, options = {}) => {
  await ensureSeedServices();

  const services = await Service.find(buildListQuery(query, options))
    .sort({ sortOrder: 1, createdAt: 1 })
    .lean();

  return services.map(mapService);
};

const listFeaturedServices = async () => {
  await ensureSeedServices();

  const services = await Service.find({
    isActive: true,
    isFeatured: true,
  })
    .sort({ sortOrder: 1, createdAt: 1 })
    .lean();

  return services.map(mapService);
};

const getServiceByIdOrSlug = async (serviceId) => {
  await ensureSeedServices();

  const query = /^[a-f\d]{24}$/i.test(serviceId)
    ? { _id: serviceId }
    : { slug: serviceId };
  const service = await Service.findOne({
    ...query,
    isActive: true,
  }).lean();

  if (!service) {
    throw new ApiError(404, "Service not found.");
  }

  return mapService(service);
};

const createService = async (payload) => {
  const service = await Service.create(payload);
  return mapService(service);
};

const updateService = async (serviceId, payload) => {
  const service = await Service.findByIdAndUpdate(serviceId, payload, {
    new: true,
    runValidators: true,
  });

  if (!service) {
    throw new ApiError(404, "Service not found.");
  }

  return mapService(service);
};

const deleteService = async (serviceId) => {
  const service = await Service.findByIdAndDelete(serviceId);

  if (!service) {
    throw new ApiError(404, "Service not found.");
  }
};

module.exports = {
  listServices,
  listFeaturedServices,
  getServiceByIdOrSlug,
  createService,
  updateService,
  deleteService,
};
