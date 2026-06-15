import 'package:app/features/chat/domain/entities/chat_message.dart';
import 'package:equatable/equatable.dart';

class ChatMessageSyncResult extends Equatable {
  const ChatMessageSyncResult({
    required this.localId,
    required this.message,
  });

  final String localId;
  final ChatMessage message;

  @override
  List<Object?> get props => [localId, message];
}
