const asyncHandler = require("../../middlewares/asyncHandler");
const petService = require("./pet.service");

const listPets = asyncHandler(async (req, res) => {
  const pets = await petService.listPets(req.user._id);

  res.status(200).json({
    success: true,
    message: "Pets fetched successfully.",
    data: {
      pets,
    },
  });
});

const createPet = asyncHandler(async (req, res) => {
  const pet = await petService.createPet(req.user._id, req.body);

  res.status(201).json({
    success: true,
    message: "Pet created successfully.",
    data: {
      pet,
    },
  });
});

const getPet = asyncHandler(async (req, res) => {
  const pet = await petService.getPetById(req.user._id, req.params.petId);

  res.status(200).json({
    success: true,
    message: "Pet fetched successfully.",
    data: {
      pet,
    },
  });
});

module.exports = {
  listPets,
  createPet,
  getPet,
};
