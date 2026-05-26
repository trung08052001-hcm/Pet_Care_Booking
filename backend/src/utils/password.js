const crypto = require("crypto");
const { promisify } = require("util");

const scrypt = promisify(crypto.scrypt);

const hashPassword = async (password) => {
  const salt = crypto.randomBytes(16).toString("hex");
  const derivedKey = await scrypt(password, salt, 64);

  return `${salt}:${derivedKey.toString("hex")}`;
};

const comparePassword = async (candidatePassword, storedPassword) => {
  const [salt, storedHash] = String(storedPassword || "").split(":");

  if (!salt || !storedHash) {
    return false;
  }

  const derivedKey = await scrypt(candidatePassword, salt, 64);
  const storedHashBuffer = Buffer.from(storedHash, "hex");

  if (storedHashBuffer.length !== derivedKey.length) {
    return false;
  }

  return crypto.timingSafeEqual(storedHashBuffer, derivedKey);
};

module.exports = {
  hashPassword,
  comparePassword,
};
