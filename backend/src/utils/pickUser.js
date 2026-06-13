const pickUser = (user) => ({
  id: user._id,
  fullName: user.fullName,
  email: user.email,
  phone: user.phone || null,
  address: user.address || null,
  role: user.role,
  authProvider: user.authProvider,
  avatar: user.avatar || null,
  isActive: user.isActive,
  isOnline: Boolean(user.isOnline),
  lastSeenAt: user.lastSeenAt || null,
  acceptedTermsAt: user.acceptedTermsAt || null,
  lastLoginAt: user.lastLoginAt || null,
  createdAt: user.createdAt,
  updatedAt: user.updatedAt,
});

module.exports = pickUser;
