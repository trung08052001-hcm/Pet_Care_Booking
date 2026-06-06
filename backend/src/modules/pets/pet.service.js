const Pet = require("../../models/pet.model");
const ApiError = require("../../utils/apiError");

const pickPet = (pet) => ({
  id: pet._id,
  ownerId: pet.owner,
  name: pet.name,
  ageYears: pet.ageYears,
  weightKg: pet.weightKg,
  petType: pet.petType || "dog",
  vaccinationStatus: pet.vaccinationStatus,
  imageDataUrl: pet.imageDataUrl || null,
  createdAt: pet.createdAt,
  updatedAt: pet.updatedAt,
});

const listPets = async (userId) => {
  const pets = await Pet.find({ owner: userId }).sort({ createdAt: -1 });
  return pets.map(pickPet);
};

const createPet = async (userId, payload) => {
  const pet = await Pet.create({
    owner: userId,
    name: payload.name,
    ageYears: payload.ageYears,
    weightKg: payload.weightKg,
    petType: payload.petType,
    vaccinationStatus: payload.vaccinationStatus,
    imageDataUrl: payload.imageDataUrl || null,
  });

  return pickPet(pet);
};

const getPetById = async (userId, petId) => {
  const pet = await Pet.findOne({ _id: petId, owner: userId });

  if (!pet) {
    throw new ApiError(404, "Pet not found.");
  }

  return pickPet(pet);
};

module.exports = {
  listPets,
  createPet,
  getPetById,
};
