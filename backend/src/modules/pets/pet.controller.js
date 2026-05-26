const listPets = (req, res) => {
  res.status(501).json({
    success: false,
    message: "Pet module is not implemented yet.",
  });
};

const createPet = (req, res) => {
  res.status(501).json({
    success: false,
    message: "Create pet endpoint is not implemented yet.",
  });
};

module.exports = {
  listPets,
  createPet,
};
