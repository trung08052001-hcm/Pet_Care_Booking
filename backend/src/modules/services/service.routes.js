const express = require("express");

const { listServices } = require("./service.controller");

const router = express.Router();

router.get("/", listServices);

module.exports = router;
