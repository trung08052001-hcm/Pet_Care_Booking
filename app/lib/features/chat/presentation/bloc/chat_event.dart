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
  const ChatMessageSendRequested(this.text);

  final String text;

  @override
  List<Object?> get props => [text];
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
