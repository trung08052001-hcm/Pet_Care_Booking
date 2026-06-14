import 'package:app/core/common/typedefs.dart';
import 'package:app/features/chat/domain/entities/chat_attachment.dart';
import 'package:app/features/chat/domain/entities/chat_message.dart';
import 'package:app/features/chat/domain/entities/chat_page_content.dart';

abstract interface class ChatRepository {
  ResultFuture<ChatPageContent> getChatPageContent();

  Stream<ChatMessage> get incomingMessages;

  ResultFuture<ChatMessage> sendMessage(
    String text, {
    List<ChatAttachment> attachments = const [],
  });

  ChatMessage createUserMessage(String text);
}
