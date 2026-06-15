const express = require("express");

const { authenticate, authorize } = require("../../middlewares/auth.middleware");
const validate = require("../../middlewares/validate");
const {
  createService,
  deleteService,
  getServiceDetail,
  listFeaturedServices,
  listServices,
  updateService,
} = require("./service.controller");
const {
  createServiceSchema,
  updateServiceSchema,
} = require("./service.schemas");

const router = express.Router();

const optionalAuthenticate = (req, res, next) => {
  if (!req.headers.authorization) {
    return next();
  }
  return authenticate(req, res, next);
};

router.get("/", optionalAuthenticate, listServices);
router.get("/featured", listFeaturedServices);
router.get("/:serviceId", getServiceDetail);
router.post("/", authenticate, authorize("admin"), validate(createServiceSchema), createService);
router.patch(
  "/:serviceId",
  authenticate,
  authorize("admin"),
  validate(updateServiceSchema),
  updateService
);
router.delete("/:serviceId", authenticate, authorize("admin"), deleteService);

module.exports = router;
