import { apiConfig, buildApiUrl } from "./apiConfig";
import type { AdminSession } from "./authApi";

export type InformationCategory = "Dinh dưỡng" | "Sức khỏe" | "Huấn luyện";

export type InformationSection = {
  heading: string;
  body: string;
  image: string;
};

export type InformationArticle = {
  id: string;
  sourceId: string;
  slug: string;
  title: string;
  mainCategory: InformationCategory;
  category: string;
  tag: string;
  image: string;
  author: string;
  publishedDate: string;
  readTime: string;
  shortDescription: string;
  content: {
    intro: string;
    sections: InformationSection[];
    tip?: string;
    conclusion?: string;
  };
  sortOrder: number;
  isActive: boolean;
  createdAt?: string;
  updatedAt?: string;
};

export type InformationPayload = Omit<
  InformationArticle,
  "id" | "sourceId" | "createdAt" | "updatedAt"
> & {
  sourceId?: string;
};

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
    throw new Error(result.message || "Information request failed.");
  }

  if (!("data" in result)) {
    throw new Error("Invalid information API response.");
  }

  return result.data;
};

export const informationApi = {
  async list(limit = 40) {
    const data = await request<{ articles: InformationArticle[] }>(
      `${apiConfig.endpoints.blogPosts}?limit=${limit}`,
    );
    return data.articles;
  },

  async create(payload: InformationPayload) {
    const data = await request<{ article: InformationArticle }>(
      apiConfig.endpoints.blogPosts,
      {
        method: "POST",
        body: JSON.stringify(payload),
      },
    );
    return data.article;
  },

  async update(articleId: string, payload: Partial<InformationPayload>) {
    const data = await request<{ article: InformationArticle }>(
      apiConfig.endpoints.blogPostDetail(articleId),
      {
        method: "PATCH",
        body: JSON.stringify(payload),
      },
    );
    return data.article;
  },

  async remove(articleId: string) {
    await request<null>(apiConfig.endpoints.blogPostDetail(articleId), {
      method: "DELETE",
    });
  },
};
