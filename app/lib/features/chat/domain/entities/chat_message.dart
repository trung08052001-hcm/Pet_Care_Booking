import 'package:app/features/chat/domain/entities/chat_attachment.dart';
import 'package:app/features/chat/domain/entities/chat_message_sender.dart';
import 'package:equatable/equatable.dart';

enum ChatMessageDeliveryStatus {
  sending,
  sent,
  failed,
}

class ChatMessage extends Equatable {
  const ChatMessage({
    required this.id,
    required this.sender,
    required this.text,
    required this.sentAt,
    this.attachments = const [],
    this.imageAttachmentTitle,
    this.isRead = false,
    this.deliveryStatus = ChatMessageDeliveryStatus.sent,
  });

  final String id;
  final ChatMessageSender sender;
  final String text;
  final DateTime sentAt;
  final List<ChatAttachment> attachments;
  final String? imageAttachmentTitle;
  final bool isRead;
  final ChatMessageDeliveryStatus deliveryStatus;

  bool get hasImageAttachment =>
      attachments.any((attachment) => attachment.isImage) ||
      (imageAttachmentTitle != null && imageAttachmentTitle!.isNotEmpty);

  bool get hasFileAttachment =>
      attachments.any((attachment) => !attachment.isImage);

  @override
  List<Object?> get props => [
        id,
        sender,
        text,
        sentAt,
        attachments,
        imageAttachmentTitle,
        isRead,
        deliveryStatus,
      ];
}
