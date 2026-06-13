import 'package:app/features/chat/domain/entities/chat_agent.dart';
import 'package:app/features/chat/domain/entities/chat_faq_item.dart';
import 'package:app/features/chat/domain/entities/chat_message.dart';
import 'package:equatable/equatable.dart';

enum ChatStatus {
  initial,
  loading,
  success,
  failure,
}

enum ChatInteraction {
  none,
  notifications,
  seeAllFaqs,
  attachment,
  pickImage,
  pickEmoji,
}

class ChatState extends Equatable {
  const ChatState({
    this.status = ChatStatus.initial,
    this.faqSectionTitle = 'Câu hỏi thường gặp',
    this.todayDividerLabel = 'HÔM NAY',
    this.agent,
    this.faqs = const [],
    this.messages = const [],
    this.isAgentTyping = false,
    this.isSending = false,
    this.isRealtimeConnected = false,
    this.message,
    this.interaction = ChatInteraction.none,
  });

  final ChatStatus status;
  final String faqSectionTitle;
  final String todayDividerLabel;
  final ChatAgent? agent;
  final List<ChatFaqItem> faqs;
  final List<ChatMessage> messages;
  final bool isAgentTyping;
  final bool isSending;
  final bool isRealtimeConnected;
  final String? message;
  final ChatInteraction interaction;

  bool get isLoading =>
      status == ChatStatus.loading || status == ChatStatus.initial;

  ChatState copyWith({
    ChatStatus? status,
    String? faqSectionTitle,
    String? todayDividerLabel,
    ChatAgent? agent,
    List<ChatFaqItem>? faqs,
    List<ChatMessage>? messages,
    bool? isAgentTyping,
    bool? isSending,
    bool? isRealtimeConnected,
    String? message,
    ChatInteraction? interaction,
    bool clearMessage = false,
  }) {
    return ChatState(
      status: status ?? this.status,
      faqSectionTitle: faqSectionTitle ?? this.faqSectionTitle,
      todayDividerLabel: todayDividerLabel ?? this.todayDividerLabel,
      agent: agent ?? this.agent,
      faqs: faqs ?? this.faqs,
      messages: messages ?? this.messages,
      isAgentTyping: isAgentTyping ?? this.isAgentTyping,
      isSending: isSending ?? this.isSending,
      isRealtimeConnected: isRealtimeConnected ?? this.isRealtimeConnected,
      message: clearMessage ? null : (message ?? this.message),
      interaction: interaction ?? this.interaction,
    );
  }

  @override
  List<Object?> get props => [
        status,
        faqSectionTitle,
        todayDividerLabel,
        agent,
        faqs,
        messages,
        isAgentTyping,
        isSending,
        isRealtimeConnected,
        message,
        interaction,
      ];
}
