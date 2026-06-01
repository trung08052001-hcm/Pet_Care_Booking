import 'package:app/core/common/typedefs.dart';
import 'package:app/core/error/app_error.dart';
import 'package:app/features/chat/data/datasources/chat_mock_data_source.dart';
import 'package:app/features/chat/domain/entities/chat_message.dart';
import 'package:app/features/chat/domain/entities/chat_page_content.dart';
import 'package:app/features/chat/domain/repositories/chat_repository.dart';
import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';

@LazySingleton(as: ChatRepository)
class ChatRepositoryImpl implements ChatRepository {
  ChatRepositoryImpl(this._mockDataSource);

  final ChatMockDataSource _mockDataSource;

  @override
  ResultFuture<ChatPageContent> getChatPageContent() async {
    try {
      await Future<void>.delayed(const Duration(milliseconds: 250));
      return Right(_mockDataSource.getPageContent());
    } on Exception catch (exception, stackTrace) {
      return Left(
        FailureMapper.fromException(
          exception,
          stackTrace: stackTrace,
        ),
      );
    }
  }

  @override
  ChatMessage createUserMessage(String text) {
    return _mockDataSource.createUserMessage(text);
  }

  @override
  ResultFuture<ChatMessage> getAgentReply(String userMessage) async {
    try {
      await Future<void>.delayed(const Duration(milliseconds: 1200));
      return Right(_mockDataSource.createAgentReply(userMessage));
    } on Exception catch (exception, stackTrace) {
      return Left(
        FailureMapper.fromException(
          exception,
          stackTrace: stackTrace,
        ),
      );
    }
  }
}
