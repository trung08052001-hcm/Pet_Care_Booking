import 'package:app/core/common/typedefs.dart';
import 'package:app/core/usecase/usecase.dart';
import 'package:app/features/chat/domain/entities/chat_page_content.dart';
import 'package:app/features/chat/domain/repositories/chat_repository.dart';
import 'package:injectable/injectable.dart';

@injectable
class GetChatPageContentUseCase implements UseCase<ChatPageContent, NoParams> {
  GetChatPageContentUseCase(this._repository);

  final ChatRepository _repository;

  @override
  ResultFuture<ChatPageContent> call(NoParams params) {
    return _repository.getChatPageContent();
  }
}
