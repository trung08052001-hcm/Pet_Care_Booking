import 'package:app/features/chat/domain/entities/chat_message.dart';
import 'package:app/features/chat/domain/entities/chat_message_sender.dart';

class ChatMessageMapper {
  const ChatMessageMapper._();

  static ChatMessage fromJson(Map<String, dynamic> json) {
    final senderRole = json['senderRole'] as String?;
    return ChatMessage(
      id: (json['id'] ?? json['_id'] ?? '').toString(),
      sender: senderRole == 'admin'
          ? ChatMessageSender.agent
          : ChatMessageSender.user,
      text: (json['text'] ?? '').toString(),
      sentAt: DateTime.tryParse((json['createdAt'] ?? '').toString()) ??
          DateTime.now(),
      isRead: true,
    );
  }
}
