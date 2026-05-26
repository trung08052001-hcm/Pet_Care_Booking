const express = require("express");

const { createPet, listPets } = require("./pet.controller");

const router = express.Router();

router.get("/", listPets);
router.post("/", createPet);

module.exports = router;
