const listServices = (req, res) => {
  res.status(501).json({
    success: false,
    message: "Service module is not implemented yet.",
  });
};

module.exports = {
  listServices,
};
