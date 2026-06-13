const DeviceToken = require("../../models/deviceToken.model");
const { getFirebaseMessaging } = require("../../config/firebase");

const registerDeviceToken = async (userId, payload) => {
  const token = await DeviceToken.findOneAndUpdate(
    { token: payload.token },
    {
      user: userId,
      token: payload.token,
      platform: payload.platform || "unknown",
      deviceId: payload.deviceId || null,
      isActive: true,
      lastSeenAt: new Date(),
    },
    {
      upsert: true,
      new: true,
      setDefaultsOnInsert: true,
    }
  );

  return token;
};

const sendToUser = async (userId, message) => {
  const tokens = await DeviceToken.find({
    user: userId,
    isActive: true,
  }).select("token");

  if (tokens.length === 0) {
    return { successCount: 0, failureCount: 0 };
  }

  const messaging = getFirebaseMessaging();
  const response = await messaging.sendEachForMulticast({
    tokens: tokens.map((item) => item.token),
    notification: {
      title: message.title,
      body: message.body,
    },
    data: Object.entries(message.data || {}).reduce((acc, [key, value]) => {
      acc[key] = String(value);
      return acc;
    }, {}),
  });

  const failures = [];
  response.responses.forEach((item, index) => {
    if (!item.success) {
      failures.push({
        token: tokens[index].token,
        code: item.error?.code || "unknown",
        message: item.error?.message || "Unknown Firebase error.",
      });
    }
  });

  const failedTokens = failures.map((item) => item.token);

  if (failedTokens.length > 0) {
    await DeviceToken.updateMany(
      { token: { $in: failedTokens } },
      { isActive: false }
    );
  }

  return {
    successCount: response.successCount,
    failureCount: response.failureCount,
    failures: failures.map((item) => ({
      tokenPrefix: item.token.slice(0, 12),
      code: item.code,
      message: item.message,
    })),
  };
};

module.exports = {
  registerDeviceToken,
  sendToUser,
};
