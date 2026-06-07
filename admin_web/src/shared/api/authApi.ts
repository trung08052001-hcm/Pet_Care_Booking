import { apiConfig, buildApiUrl } from "./apiConfig";

type AdminLoginPayload = {
  identifier: string;
  password: string;
};

export type AdminSession = {
  user: {
    id: string;
    fullName: string;
    email: string;
    phone: string | null;
    role: string;
    authProvider: string;
    avatar?: string | null;
    isActive: boolean;
  };
  tokens: {
    tokenType: string;
    accessToken: string;
    refreshToken: string;
  };
};

type ApiResponse<T> = {
  success: boolean;
  message: string;
  data: T;
};

export async function loginAdmin(payload: AdminLoginPayload): Promise<AdminSession> {
  const response = await fetch(buildApiUrl(apiConfig.endpoints.adminLogin), {
    method: "POST",
    headers: {
      "Content-Type": "application/json",
    },
    body: JSON.stringify(payload),
  });

  const result = (await response.json()) as ApiResponse<AdminSession> | { message?: string };

  if (!response.ok) {
    throw new Error(result.message || "Admin login failed.");
  }

  if (!("data" in result) || result.data.user.role !== "admin") {
    throw new Error("Only admin accounts can access the admin portal.");
  }

  return result.data;
}
