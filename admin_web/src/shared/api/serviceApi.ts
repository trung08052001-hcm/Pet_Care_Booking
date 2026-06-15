import { apiConfig, buildApiUrl } from "./apiConfig";
import type { AdminSession } from "./authApi";

export type ServiceCategory = "all" | "dog" | "cat";

export type PetCareService = {
  id: string;
  title: string;
  description: string;
  detail: string;
  priceText: string;
  image: string;
  category: ServiceCategory;
  badge: string;
  isActive: boolean;
  isFeatured?: boolean;
  sortOrder: number;
  createdAt?: string;
  updatedAt?: string;
};

export type ServicePayload = Omit<PetCareService, "id" | "createdAt" | "updatedAt">;

type ApiResponse<T> = {
  success: boolean;
  message: string;
  data: T;
};

const getToken = () => {
  const rawSession = window.localStorage.getItem("admin_session");
  if (!rawSession) {
    return "";
  }

  try {
    return (JSON.parse(rawSession) as AdminSession).tokens.accessToken;
  } catch {
    return "";
  }
};

const request = async <T>(path: string, init: RequestInit = {}) => {
  const token = getToken();
  const response = await fetch(buildApiUrl(path), {
    ...init,
    headers: {
      "Content-Type": "application/json",
      ...(token ? { Authorization: `Bearer ${token}` } : {}),
      ...init.headers,
    },
  });
  const result = (await response.json()) as ApiResponse<T> | { message?: string };

  if (!response.ok) {
    throw new Error(result.message || "Service request failed.");
  }

  if (!("data" in result)) {
    throw new Error("Invalid service API response.");
  }

  return result.data;
};

export const serviceApi = {
  async list() {
    const data = await request<{ services: PetCareService[] }>(apiConfig.endpoints.services);
    return data.services;
  },

  async create(payload: ServicePayload) {
    const data = await request<{ service: PetCareService }>(apiConfig.endpoints.services, {
      method: "POST",
      body: JSON.stringify(payload),
    });
    return data.service;
  },

  async update(serviceId: string, payload: Partial<ServicePayload>) {
    const data = await request<{ service: PetCareService }>(
      apiConfig.endpoints.serviceDetail(serviceId),
      {
        method: "PATCH",
        body: JSON.stringify(payload),
      },
    );
    return data.service;
  },

  async remove(serviceId: string) {
    await request<null>(apiConfig.endpoints.serviceDetail(serviceId), {
      method: "DELETE",
    });
  },
};
