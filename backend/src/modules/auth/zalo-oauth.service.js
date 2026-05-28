const ApiError = require("../../utils/apiError");
const env = require("../../config/env");

const ZALO_TOKEN_ENDPOINT = "https://oauth.zaloapp.com/v4/access_token";
const ZALO_PROFILE_ENDPOINT = "https://graph.zalo.me/v2.0/me";

const ensureZaloExchangeConfig = () => {
  if (!env.zaloAppId || !env.zaloAppSecret || !env.zaloCallbackUrl) {
    throw new ApiError(
      500,
      "Missing Zalo OAuth configuration. Please set ZALO_APP_ID, ZALO_APP_SECRET, and ZALO_CALLBACK_URL."
    );
  }
};

const parseJsonResponse = async (response) => {
  const payload = await response.text();

  try {
    return payload ? JSON.parse(payload) : {};
  } catch (error) {
    throw new ApiError(502, "Invalid JSON response from Zalo.");
  }
};

const exchangeAuthorizationCode = async ({ oauthCode, codeVerifier }) => {
  ensureZaloExchangeConfig();

  try {
    const body = new URLSearchParams({
      app_id: env.zaloAppId,
      grant_type: "authorization_code",
      code: oauthCode,
      redirect_uri: env.zaloCallbackUrl,
    });

    if (codeVerifier) {
      body.append("code_verifier", codeVerifier);
    }

    const response = await fetch(ZALO_TOKEN_ENDPOINT, {
      method: "POST",
      headers: {
        "Content-Type": "application/x-www-form-urlencoded",
        secret_key: env.zaloAppSecret,
      },
      body: body.toString(),
    });

    const parsed = await parseJsonResponse(response);

    if (!response.ok || parsed.error || !parsed.access_token) {
      throw new ApiError(
        401,
        parsed.error_name ||
          parsed.error ||
          parsed.message ||
          "Failed to exchange Zalo authorization code."
      );
    }

    return {
      accessToken: parsed.access_token,
      refreshToken: parsed.refresh_token || null,
      expiresIn: parsed.expires_in || null,
    };
  } catch (error) {
    if (error instanceof ApiError) {
      throw error;
    }
    throw new ApiError(502, "Failed to communicate with Zalo token endpoint.");
  }
};

const fetchZaloUserProfile = async (accessToken) => {
  try {
    const query = new URLSearchParams({
      fields: "id,name,picture,phone",
    });
    const requestUrl = `${ZALO_PROFILE_ENDPOINT}?${query.toString()}`;

    const response = await fetch(requestUrl, {
      method: "GET",
      headers: {
        access_token: accessToken,
        "Content-Type": "application/json",
      },
    });

    const parsed = await parseJsonResponse(response);

    if (!response.ok || parsed.error || !parsed.id) {
      throw new ApiError(
        401,
        parsed.error_name ||
          parsed.error ||
          parsed.message ||
          "Failed to fetch Zalo user profile."
      );
    }

    const avatar =
      parsed.picture?.data?.url || parsed.picture?.url || parsed.avatar || null;

    return {
      id: String(parsed.id),
      fullName: parsed.name ? String(parsed.name).trim() : "Zalo User",
      phone: parsed.phone ? String(parsed.phone).trim() : null,
      avatar,
    };
  } catch (error) {
    if (error instanceof ApiError) {
      throw error;
    }
    throw new ApiError(502, "Failed to communicate with Zalo Graph API.");
  }
};

module.exports = {
  exchangeAuthorizationCode,
  fetchZaloUserProfile,
};
