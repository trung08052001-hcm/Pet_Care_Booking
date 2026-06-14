import 'package:app/features/chat/domain/entities/chat_attachment.dart';
import 'package:app/features/chat/domain/entities/chat_message.dart';
import 'package:equatable/equatable.dart';

sealed class ChatEvent extends Equatable {
  const ChatEvent();

  @override
  List<Object?> get props => const [];
}

final class ChatStarted extends ChatEvent {
  const ChatStarted();
}

final class ChatRefreshRequested extends ChatEvent {
  const ChatRefreshRequested();
}

final class ChatMessageSendRequested extends ChatEvent {
  const ChatMessageSendRequested(
    this.text, {
    this.attachments = const [],
  });

  final String text;
  final List<ChatAttachment> attachments;

  @override
  List<Object?> get props => [text, attachments];
}

final class ChatIncomingMessageReceived extends ChatEvent {
  const ChatIncomingMessageReceived(this.message);

  final ChatMessage message;

  @override
  List<Object?> get props => [message];
}

final class ChatFaqPressed extends ChatEvent {
  const ChatFaqPressed(this.faqId);

  final String faqId;

  @override
  List<Object?> get props => [faqId];
}

final class ChatSeeAllFaqsPressed extends ChatEvent {
  const ChatSeeAllFaqsPressed();
}

final class ChatNotificationsPressed extends ChatEvent {
  const ChatNotificationsPressed();
}

final class ChatAttachmentPressed extends ChatEvent {
  const ChatAttachmentPressed();
}

final class ChatPickImagePressed extends ChatEvent {
  const ChatPickImagePressed();
}

final class ChatPickEmojiPressed extends ChatEvent {
  const ChatPickEmojiPressed();
}
