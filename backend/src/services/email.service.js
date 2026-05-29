const nodemailer = require("nodemailer");

const env = require("../config/env");
const ApiError = require("../utils/apiError");

let transporter;

const isSmtpConfigured = () =>
  Boolean(env.smtpHost && env.smtpUser && env.smtpPass && env.mailFrom);

const getTransporter = () => {
  if (!isSmtpConfigured()) {
    return null;
  }

  if (!transporter) {
    transporter = nodemailer.createTransport({
      host: env.smtpHost,
      port: env.smtpPort,
      secure: env.smtpSecure,
      auth: {
        user: env.smtpUser,
        pass: env.smtpPass,
      },
    });
  }

  return transporter;
};

const sendPasswordResetOtpEmail = async ({ to, otp, expiresMinutes }) => {
  const subject = "Your password reset code";
  const text = [
    `Your verification code is: ${otp}`,
    "",
    `This code expires in ${expiresMinutes} minutes.`,
    "If you did not request this, you can ignore this email.",
  ].join("\n");
  const html = `
    <p>Your verification code is:</p>
    <p style="font-size:28px;font-weight:700;letter-spacing:6px;">${otp}</p>
    <p>This code expires in ${expiresMinutes} minutes.</p>
    <p>If you did not request this, you can ignore this email.</p>
  `;

  const logDevOtp = () => {
    // eslint-disable-next-line no-console
    console.log(`[email:dev] Password reset OTP for ${to}: ${otp}`);
  };

  const transport = getTransporter();

  if (!transport) {
    if (env.nodeEnv === "development") {
      logDevOtp();
      return;
    }

    throw new ApiError(500, "Email service is not configured.");
  }

  try {
    await transport.sendMail({
      from: env.mailFrom,
      to,
      subject,
      text,
      html,
    });
  } catch (error) {
    // eslint-disable-next-line no-console
    console.error("[email] SMTP send failed:", error.message);

    if (env.nodeEnv === "development") {
      logDevOtp();
      return;
    }

    throw new ApiError(
      502,
      "Failed to send verification email. Please try again later."
    );
  }
};

module.exports = {
  sendPasswordResetOtpEmail,
};
