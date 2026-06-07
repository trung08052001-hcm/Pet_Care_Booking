export const apiConfig = {
  baseUrl: import.meta.env.VITE_API_BASE_URL ?? "http://localhost:5000/api/v1",
  endpoints: {
    adminLogin: "/auth/admin/login",
  },
};

export const buildApiUrl = (path: string) => `${apiConfig.baseUrl}${path}`;
