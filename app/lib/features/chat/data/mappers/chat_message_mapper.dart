import 'package:app/features/chat/domain/entities/chat_attachment.dart';
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
      attachments: _attachmentsFromJson(json['attachments']),
      isRead: true,
    );
  }

  static List<ChatAttachment> _attachmentsFromJson(Object? value) {
    if (value is! List) {
      return const [];
    }

    return value.whereType<Map<String, dynamic>>().map((item) {
      final typeName = item['type']?.toString();
      return ChatAttachment(
        type: typeName == 'file'
            ? ChatAttachmentType.file
            : ChatAttachmentType.image,
        name: (item['name'] ?? 'attachment').toString(),
        dataUrl: (item['dataUrl'] ?? item['url'] ?? '').toString(),
        mimeType: item['mimeType']?.toString(),
        sizeBytes: item['sizeBytes'] is num
            ? (item['sizeBytes'] as num).toInt()
            : null,
      );
    }).where((attachment) => attachment.dataUrl.isNotEmpty).toList();
  }
}
