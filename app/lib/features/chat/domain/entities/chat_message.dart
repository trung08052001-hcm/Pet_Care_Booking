import 'package:app/features/chat/domain/entities/chat_message_sender.dart';
import 'package:equatable/equatable.dart';

class ChatMessage extends Equatable {
  const ChatMessage({
    required this.id,
    required this.sender,
    required this.text,
    required this.sentAt,
    this.imageAttachmentTitle,
    this.isRead = false,
  });

  final String id;
  final ChatMessageSender sender;
  final String text;
  final DateTime sentAt;
  final String? imageAttachmentTitle;
  final bool isRead;

  bool get hasImageAttachment =>
      imageAttachmentTitle != null && imageAttachmentTitle!.isNotEmpty;

  @override
  List<Object?> get props => [
        id,
        sender,
        text,
        sentAt,
        imageAttachmentTitle,
        isRead,
      ];
}
