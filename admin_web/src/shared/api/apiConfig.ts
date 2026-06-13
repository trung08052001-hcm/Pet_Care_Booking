export const apiConfig = {
  baseUrl: import.meta.env.VITE_API_BASE_URL ?? "http://localhost:5000/api/v1",
  endpoints: {
    adminLogin: "/auth/admin/login",
    authRefreshToken: "/auth/refresh-token",
    chatConversations: "/chat/conversations",
    chatMessages: (conversationId: string) => `/chat/conversations/${conversationId}/messages`,
  },
};

export const buildApiUrl = (path: string) => `${apiConfig.baseUrl}${path}`;

export const socketBaseUrl = apiConfig.baseUrl.endsWith("/api/v1")
  ? apiConfig.baseUrl.slice(0, -"/api/v1".length)
  : apiConfig.baseUrl;
