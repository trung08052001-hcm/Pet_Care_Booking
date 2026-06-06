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

  const failedTokens = [];
  response.responses.forEach((item, index) => {
    if (!item.success) {
      failedTokens.push(tokens[index].token);
    }
  });

  if (failedTokens.length > 0) {
    await DeviceToken.updateMany(
      { token: { $in: failedTokens } },
      { isActive: false }
    );
  }

  return {
    successCount: response.successCount,
    failureCount: response.failureCount,
  };
};

module.exports = {
  registerDeviceToken,
  sendToUser,
};
