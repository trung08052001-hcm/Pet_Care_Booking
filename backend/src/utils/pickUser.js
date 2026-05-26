const pickUser = (user) => ({
  id: user._id,
  fullName: user.fullName,
  email: user.email,
  phone: user.phone || null,
  role: user.role,
  authProvider: user.authProvider,
  isActive: user.isActive,
  acceptedTermsAt: user.acceptedTermsAt || null,
  lastLoginAt: user.lastLoginAt || null,
  createdAt: user.createdAt,
  updatedAt: user.updatedAt,
});

module.exports = pickUser;
