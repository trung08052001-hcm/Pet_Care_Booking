import 'package:app/core/common/typedefs.dart';
import 'package:app/core/error/app_error.dart';
import 'package:app/features/chat/data/datasources/chat_mock_data_source.dart';
import 'package:app/features/chat/data/datasources/chat_remote_data_source.dart';
import 'package:app/features/chat/data/datasources/chat_socket_service.dart';
import 'package:app/features/chat/data/mappers/chat_message_mapper.dart';
import 'package:app/features/chat/domain/entities/chat_attachment.dart';
import 'package:app/features/chat/domain/entities/chat_message.dart';
import 'package:app/features/chat/domain/entities/chat_page_content.dart';
import 'package:app/features/chat/domain/repositories/chat_repository.dart';
import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';

@LazySingleton(as: ChatRepository)
class ChatRepositoryImpl implements ChatRepository {
  ChatRepositoryImpl(
    this._mockDataSource,
    this._remoteDataSource,
    this._socketService,
  );

  final ChatMockDataSource _mockDataSource;
  final ChatRemoteDataSource _remoteDataSource;
  final ChatSocketService _socketService;
  String? _conversationId;

  @override
  Stream<ChatMessage> get incomingMessages =>
      _socketService.messages.map(ChatMessageMapper.fromJson);

  @override
  ResultFuture<ChatPageContent> getChatPageContent() async {
    try {
      final conversation = await _remoteDataSource.getOrCreateConversation();
      final conversationId = conversation['id']?.toString();
      if (conversationId == null || conversationId.isEmpty) {
        throw StateError('Conversation id is missing.');
      }

      _conversationId = conversationId;
      final messages = await _remoteDataSource.getMessages(conversationId);
      await _socketService.connect(conversationId);

      final mockContent = _mockDataSource.getPageContent();
      return Right(
        ChatPageContent(
          faqSectionTitle: mockContent.faqSectionTitle,
          todayDividerLabel: mockContent.todayDividerLabel,
          agent: mockContent.agent,
          faqs: mockContent.faqs,
          messages: messages.map(ChatMessageMapper.fromJson).toList(),
        ),
      );
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
  ResultFuture<ChatMessage> sendMessage(
    String text, {
    List<ChatAttachment> attachments = const [],
  }) async {
    try {
      var conversationId = _conversationId;
      if (conversationId == null || conversationId.isEmpty) {
        final conversation = await _remoteDataSource.getOrCreateConversation();
        conversationId = conversation['id']?.toString();
        if (conversationId == null || conversationId.isEmpty) {
          throw StateError('Conversation id is missing.');
        }
        _conversationId = conversationId;
        await _socketService.connect(conversationId);
      }

      final message = await _remoteDataSource.sendMessage(
        conversationId: conversationId,
        text: text,
        attachments: attachments,
      );
      return Right(ChatMessageMapper.fromJson(message));
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
