const express = require("express");

const { authenticate } = require("../../middlewares/auth.middleware");
const validate = require("../../middlewares/validate");
const { createPet, getPet, listPets } = require("./pet.controller");
const { createPetSchema } = require("./pet.schemas");

const router = express.Router();

router.use(authenticate);

router.get("/", listPets);
router.post("/", validate(createPetSchema), createPet);
router.get("/:petId", getPet);

module.exports = router;
