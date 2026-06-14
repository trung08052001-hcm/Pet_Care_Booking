import 'package:app/core/common/typedefs.dart';
import 'package:app/core/usecase/usecase.dart';
import 'package:app/features/chat/domain/entities/chat_attachment.dart';
import 'package:app/features/chat/domain/entities/chat_message.dart';
import 'package:app/features/chat/domain/repositories/chat_repository.dart';
import 'package:equatable/equatable.dart';
import 'package:injectable/injectable.dart';

class SendChatMessageParams extends Equatable {
  const SendChatMessageParams(
    this.text, {
    this.attachments = const [],
  });

  final String text;
  final List<ChatAttachment> attachments;

  @override
  List<Object?> get props => [text, attachments];
}

@injectable
class SendChatMessageUseCase implements UseCase<ChatMessage, SendChatMessageParams> {
  SendChatMessageUseCase(this._repository);

  final ChatRepository _repository;

  @override
  ResultFuture<ChatMessage> call(SendChatMessageParams params) {
    return _repository.sendMessage(
      params.text,
      attachments: params.attachments,
    );
  }
}
