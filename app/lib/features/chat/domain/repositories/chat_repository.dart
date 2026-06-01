import 'package:app/core/common/typedefs.dart';
import 'package:app/features/chat/domain/entities/chat_message.dart';
import 'package:app/features/chat/domain/entities/chat_page_content.dart';

abstract interface class ChatRepository {
  ResultFuture<ChatPageContent> getChatPageContent();

  ResultFuture<ChatMessage> getAgentReply(String userMessage);

  ChatMessage createUserMessage(String text);
}
