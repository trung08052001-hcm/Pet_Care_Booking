import { useEffect, useRef, useState } from "react";
import { Image, Info, PlusCircle, Send, Smile } from "lucide-react";
import { io, type Socket } from "socket.io-client";
import { apiConfig, buildApiUrl, socketBaseUrl } from "../../shared/api/apiConfig";
import type { AdminSession } from "../../shared/api/authApi";

type ChatUser = {
  id: string;
  fullName: string;
  email: string;
  phone?: string | null;
  avatar?: string | null;
  isOnline?: boolean;
  lastSeenAt?: string | null;
};

type ChatConversation = {
  id: string;
  customer: ChatUser | null;
  assignedAdmin: ChatUser | null;
  status: "open" | "closed";
  lastMessage?: {
    text?: string;
    senderRole?: "customer" | "admin";
    createdAt?: string;
  };
  unreadForAdmin: number;
  updatedAt: string;
};

type ChatMessage = {
  id: string;
  conversationId: string;
  sender: ChatUser | null;
  senderRole: "customer" | "admin";
  text: string;
  createdAt: string;
};

type ApiResponse<T> = {
  success: boolean;
  message: string;
  data: T;
};

const getStoredSession = (): AdminSession | null => {
  const rawSession = window.localStorage.getItem("admin_session");
  if (!rawSession) {
    return null;
  }

  try {
    return JSON.parse(rawSession) as AdminSession;
  } catch {
    return null;
  }
};

const formatTime = (value: string) =>
  new Intl.DateTimeFormat("vi-VN", {
    hour: "2-digit",
    minute: "2-digit",
  }).format(new Date(value));

const formatPresence = (user?: ChatUser | null) => {
  if (!user) {
    return "No active conversation";
  }
  if (user.isOnline) {
    return "Đang hoạt động";
  }
  if (!user.lastSeenAt) {
    return "Không hoạt động";
  }

  const diffMs = Date.now() - new Date(user.lastSeenAt).getTime();
  const diffMinutes = Math.max(1, Math.floor(diffMs / 60000));
  if (diffMinutes < 60) {
    return `Hoạt động ${diffMinutes} phút trước`;
  }
  const diffHours = Math.floor(diffMinutes / 60);
  if (diffHours < 24) {
    return `Hoạt động ${diffHours} giờ trước`;
  }
  const diffDays = Math.floor(diffHours / 24);
  return `Hoạt động ${diffDays} ngày trước`;
};

const userInitial = (user?: ChatUser | null) =>
  user?.fullName?.trim().slice(0, 1).toLowerCase() || "u";

function UserAvatar({ user, size = "md" }: { user?: ChatUser | null; size?: "sm" | "md" }) {
  const avatar = user?.avatar?.trim();

  return (
    <i className={`chat-avatar ${size}`}>
      {avatar ? (
        <img src={avatar} alt={user?.fullName ? `${user.fullName} avatar` : "Customer avatar"} />
      ) : (
        userInitial(user)
      )}
    </i>
  );
}

export function ChatPage() {
  const [session, setSession] = useState<AdminSession | null>(() => getStoredSession());
  const token = session?.tokens.accessToken ?? "";
  const [conversations, setConversations] = useState<ChatConversation[]>([]);
  const [activeConversationId, setActiveConversationId] = useState<string>("");
  const [messages, setMessages] = useState<ChatMessage[]>([]);
  const [draft, setDraft] = useState("");
  const [isLoading, setIsLoading] = useState(true);
  const [error, setError] = useState<string | null>(null);
  const socketRef = useRef<Socket | null>(null);
  const threadRef = useRef<HTMLDivElement | null>(null);

  const activeConversation = conversations.find(
    (conversation) => conversation.id === activeConversationId,
  );

  useEffect(() => {
    if (!token) {
      setError("Admin session is missing. Please sign in again.");
      setIsLoading(false);
      return;
    }

    const socket = io(socketBaseUrl, {
      auth: { token },
      transports: ["websocket"],
    });
    socketRef.current = socket;

    socket.on("chat:message", (payload: { conversation?: ChatConversation; message?: ChatMessage }) => {
      if (payload.conversation) {
        setConversations((current) => upsertConversation(current, payload.conversation!));
        setActiveConversationId((current) => current || payload.conversation!.id);
      }
      if (payload.message) {
        setMessages((current) => {
          if (current.some((message) => message.id === payload.message!.id)) {
            return current;
          }
          return [...current, payload.message!];
        });
      }
    });

    socket.on("chat:conversation-updated", (payload: { conversation?: ChatConversation }) => {
      if (payload.conversation) {
        setConversations((current) => upsertConversation(current, payload.conversation!));
        setActiveConversationId((current) => current || payload.conversation!.id);
      }
    });

    socket.on("presence:user-updated", (payload: { user?: Partial<ChatUser> & { id?: string } }) => {
      const presenceUser = payload.user;
      if (!presenceUser?.id) {
        return;
      }
      setConversations((current) =>
        current.map((conversation) => {
          const customer = conversation.customer;
          if (!customer || customer.id !== presenceUser.id) {
            return conversation;
          }
          return {
            ...conversation,
            customer: {
              ...customer,
              isOnline: Boolean(presenceUser.isOnline),
              lastSeenAt: presenceUser.lastSeenAt ?? null,
            },
          };
        }),
      );
    });

    return () => {
      socket.disconnect();
      socketRef.current = null;
    };
  }, [token]);

  useEffect(() => {
    void loadConversations();
  }, [token]);

  useEffect(() => {
    if (!token) {
      return;
    }

    const refreshChat = () => {
      void loadConversations({ silent: true });
      if (activeConversationId) {
        void loadMessages(activeConversationId, { silent: true });
      }
    };

    const intervalId = window.setInterval(refreshChat, 4000);
    window.addEventListener("focus", refreshChat);

    return () => {
      window.clearInterval(intervalId);
      window.removeEventListener("focus", refreshChat);
    };
  }, [token, activeConversationId]);

  useEffect(() => {
    if (!activeConversationId) {
      return;
    }

    socketRef.current?.emit("chat:join", { conversationId: activeConversationId });
    void loadMessages(activeConversationId);
  }, [activeConversationId]);

  useEffect(() => {
    threadRef.current?.scrollTo({
      top: threadRef.current.scrollHeight,
      behavior: "smooth",
    });
  }, [messages.length]);

  async function refreshAdminSession() {
    const refreshToken = session?.tokens.refreshToken;
    if (!refreshToken) {
      throw new Error("Admin session has expired. Please sign in again.");
    }

    const response = await fetch(buildApiUrl(apiConfig.endpoints.authRefreshToken), {
      method: "POST",
      headers: {
        "Content-Type": "application/json",
      },
      body: JSON.stringify({ refreshToken }),
    });
    const result = (await response.json()) as ApiResponse<AdminSession> | { message?: string };

    if (!response.ok || !("data" in result)) {
      throw new Error(result.message || "Admin session has expired. Please sign in again.");
    }

    window.localStorage.setItem("admin_session", JSON.stringify(result.data));
    setSession(result.data);
    return result.data.tokens.accessToken;
  }

  function forceAdminSignIn(message: string) {
    window.localStorage.removeItem("admin_session");
    setError(message);
    window.setTimeout(() => window.location.reload(), 800);
  }

  async function request<T>(
    path: string,
    options: RequestInit = {},
    overrideToken = token,
    allowRefresh = true,
  ): Promise<T> {
    const response = await fetch(buildApiUrl(path), {
      ...options,
      cache: "no-store",
      headers: {
        "Content-Type": "application/json",
        "Cache-Control": "no-cache",
        Pragma: "no-cache",
        Authorization: `Bearer ${overrideToken}`,
        ...options.headers,
      },
    });
    const result = (await response.json()) as ApiResponse<T> | { message?: string };
    if (response.status === 401 && allowRefresh) {
      try {
        const nextToken = await refreshAdminSession();
        return request<T>(path, options, nextToken, false);
      } catch (refreshError) {
        const message =
          refreshError instanceof Error
            ? refreshError.message
            : "Admin session has expired. Please sign in again.";
        forceAdminSignIn(message);
        throw refreshError;
      }
    }

    if (!response.ok) {
      throw new Error(result.message || "Request failed.");
    }
    return (result as ApiResponse<T>).data;
  }

  async function loadConversations(options: { silent?: boolean } = {}) {
    try {
      if (!options.silent) {
        setIsLoading(true);
      }
      const data = await request<{ conversations: ChatConversation[] }>(
        apiConfig.endpoints.chatConversations,
      );
      setConversations(data.conversations);
      setActiveConversationId((current) => {
        const stillExists = data.conversations.some(
          (conversation) => conversation.id === current,
        );
        return stillExists ? current : data.conversations[0]?.id || "";
      });
      if (!options.silent) {
        setError(null);
      }
    } catch (loadError) {
      if (!options.silent) {
        setError(loadError instanceof Error ? loadError.message : "Unable to load chat.");
      }
    } finally {
      if (!options.silent) {
        setIsLoading(false);
      }
    }
  }

  async function loadMessages(
    conversationId: string,
    options: { silent?: boolean } = {},
  ) {
    try {
      const data = await request<{ messages: ChatMessage[] }>(
        apiConfig.endpoints.chatMessages(conversationId),
      );
      setMessages(data.messages);
      if (!options.silent) {
        setError(null);
      }
    } catch (loadError) {
      if (!options.silent) {
        setError(loadError instanceof Error ? loadError.message : "Unable to load messages.");
      }
    }
  }

  async function sendMessage() {
    const text = draft.trim();
    if (!text || !activeConversationId) {
      return;
    }

    setDraft("");
    try {
      const data = await request<{ message: ChatMessage; conversation: ChatConversation }>(
        apiConfig.endpoints.chatMessages(activeConversationId),
        {
          method: "POST",
          body: JSON.stringify({ text }),
        },
      );
      setMessages((current) => {
        if (current.some((message) => message.id === data.message.id)) {
          return current;
        }
        return [...current, data.message];
      });
      setConversations((current) => upsertConversation(current, data.conversation));
    } catch (sendError) {
      setError(sendError instanceof Error ? sendError.message : "Unable to send message.");
      setDraft(text);
    }
  }

  return (
    <section className="chat-layout">
      <aside className="conversation-panel">
        <div className="chat-heading">
          <h1>Messages</h1>
          <button className="ghost-icon" title="Refresh" onClick={() => void loadConversations()}>
            <PlusCircle size={17} />
          </button>
        </div>
        <div className="chat-search">Live customer conversations</div>
        {isLoading ? <p className="empty-state">Loading conversations...</p> : null}
        {!isLoading && conversations.length === 0 ? (
          <p className="empty-state">No customer messages yet.</p>
        ) : null}
        {conversations.map((conversation) => (
          <button
            className={conversation.id === activeConversationId ? "conversation active" : "conversation"}
            key={conversation.id}
            onClick={() => setActiveConversationId(conversation.id)}
          >
            <UserAvatar user={conversation.customer} size="sm" />
            <span>
              <strong>{conversation.customer?.fullName ?? "Customer"}</strong>
              <small>{conversation.customer?.email ?? "No email"}</small>
              <small className={conversation.customer?.isOnline ? "presence online" : "presence"}>
                {formatPresence(conversation.customer)}
              </small>
              <em>{conversation.lastMessage?.text || "Conversation started"}</em>
            </span>
          </button>
        ))}
      </aside>

      <article className="message-panel">
        <header className="message-header">
          <div className="avatar-name">
            <UserAvatar user={activeConversation?.customer} />
            <span>
              <strong>{activeConversation?.customer?.fullName ?? "Select a customer"}</strong>
              <small className={activeConversation?.customer?.isOnline ? "presence online" : "presence"}>
                {activeConversation ? formatPresence(activeConversation.customer) : "No active conversation"}
              </small>
            </span>
          </div>
          <div className="message-actions">
            <Info size={17} />
          </div>
        </header>
        <div className="message-thread" ref={threadRef}>
          <span className="date-divider">Today</span>
          {error ? <div className="chat-error">{error}</div> : null}
          {messages.map((message) => (
            <div
              className={
                message.senderRole === "admin"
                  ? "message-row outgoing-row"
                  : "message-row incoming-row"
              }
              key={message.id}
            >
              <div className={message.senderRole === "admin" ? "bubble outgoing" : "bubble incoming"}>
                {message.text}
              </div>
              <small className={message.senderRole === "admin" ? "message-time right" : "message-time left"}>
                {formatTime(message.createdAt)}
              </small>
            </div>
          ))}
          {messages.length === 0 && !error ? (
            <div className="image-message">
              <Image size={40} />
              <p>Select a customer conversation to start replying in real time.</p>
            </div>
          ) : null}
        </div>
        <footer className="composer">
          <PlusCircle size={18} />
          <Image size={18} />
          <input
            placeholder="Type a message for customer..."
            value={draft}
            disabled={!activeConversationId}
            onChange={(event) => setDraft(event.target.value)}
            onKeyDown={(event) => {
              if (event.key === "Enter") {
                void sendMessage();
              }
            }}
          />
          <Smile size={18} />
          <button className="send-button" title="Send" onClick={() => void sendMessage()}>
            <Send size={18} />
          </button>
        </footer>
      </article>
    </section>
  );
}

function upsertConversation(
  conversations: ChatConversation[],
  nextConversation: ChatConversation,
) {
  const rest = conversations.filter(
    (conversation) => conversation.id !== nextConversation.id,
  );
  return [nextConversation, ...rest].sort(
    (left, right) =>
      new Date(right.updatedAt).getTime() - new Date(left.updatedAt).getTime(),
  );
}
