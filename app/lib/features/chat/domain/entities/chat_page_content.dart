import 'package:app/features/chat/domain/entities/chat_agent.dart';
import 'package:app/features/chat/domain/entities/chat_faq_item.dart';
import 'package:app/features/chat/domain/entities/chat_message.dart';
import 'package:equatable/equatable.dart';

class ChatPageContent extends Equatable {
  const ChatPageContent({
    required this.faqSectionTitle,
    required this.todayDividerLabel,
    required this.agent,
    required this.faqs,
    required this.messages,
  });

  final String faqSectionTitle;
  final String todayDividerLabel;
  final ChatAgent agent;
  final List<ChatFaqItem> faqs;
  final List<ChatMessage> messages;

  @override
  List<Object?> get props => [
        faqSectionTitle,
        todayDividerLabel,
        agent,
        faqs,
        messages,
      ];
}
