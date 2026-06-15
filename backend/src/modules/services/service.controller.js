const asyncHandler = require("../../middlewares/asyncHandler");
const serviceService = require("./service.service");

const listServices = asyncHandler(async (req, res) => {
  const services = await serviceService.listServices(req.query, {
    includeInactive: req.user?.role === "admin",
  });

  res.status(200).json({
    success: true,
    message: "Services fetched successfully.",
    data: {
      services,
    },
  });
});

const listFeaturedServices = asyncHandler(async (req, res) => {
  const services = await serviceService.listFeaturedServices();

  res.status(200).json({
    success: true,
    message: "Featured services fetched successfully.",
    data: {
      services,
    },
  });
});

const getServiceDetail = asyncHandler(async (req, res) => {
  const service = await serviceService.getServiceByIdOrSlug(req.params.serviceId);

  res.status(200).json({
    success: true,
    message: "Service fetched successfully.",
    data: {
      service,
    },
  });
});

const createService = asyncHandler(async (req, res) => {
  const service = await serviceService.createService(req.body);

  res.status(201).json({
    success: true,
    message: "Service created successfully.",
    data: {
      service,
    },
  });
});

const updateService = asyncHandler(async (req, res) => {
  const service = await serviceService.updateService(
    req.params.serviceId,
    req.body
  );

  res.status(200).json({
    success: true,
    message: "Service updated successfully.",
    data: {
      service,
    },
  });
});

const deleteService = asyncHandler(async (req, res) => {
  await serviceService.deleteService(req.params.serviceId);

  res.status(200).json({
    success: true,
    message: "Service deleted successfully.",
    data: null,
  });
});

module.exports = {
  listServices,
  listFeaturedServices,
  getServiceDetail,
  createService,
  updateService,
  deleteService,
};
