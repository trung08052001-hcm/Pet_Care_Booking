import 'package:app/core/common/typedefs.dart';
import 'package:app/core/error/app_error.dart';
import 'package:app/core/network/network_info.dart';
import 'package:app/features/chat/data/datasources/chat_local_data_source.dart';
import 'package:app/features/chat/data/datasources/chat_mock_data_source.dart';
import 'package:app/features/chat/data/datasources/chat_remote_data_source.dart';
import 'package:app/features/chat/data/datasources/chat_socket_service.dart';
import 'package:app/features/chat/data/mappers/chat_message_mapper.dart';
import 'package:app/features/chat/domain/entities/chat_attachment.dart';
import 'package:app/features/chat/domain/entities/chat_message.dart';
import 'package:app/features/chat/domain/entities/chat_message_sender.dart';
import 'package:app/features/chat/domain/entities/chat_message_sync_result.dart';
import 'package:app/features/chat/domain/entities/chat_page_content.dart';
import 'package:app/features/chat/domain/repositories/chat_repository.dart';
import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';

@LazySingleton(as: ChatRepository)
class ChatRepositoryImpl implements ChatRepository {
  ChatRepositoryImpl(
    this._mockDataSource,
    this._remoteDataSource,
    this._socketService,
    [
    NetworkInfo? networkInfo,
    ChatLocalDataSource? localDataSource,
  ])  : _networkInfo = networkInfo,
        _localDataSource = localDataSource;

  final ChatMockDataSource _mockDataSource;
  final ChatRemoteDataSource _remoteDataSource;
  final ChatSocketService _socketService;
  final NetworkInfo? _networkInfo;
  final ChatLocalDataSource? _localDataSource;
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
      final mappedMessages = messages.map(ChatMessageMapper.fromJson).toList();
      final pendingMessages =
          _localDataSource?.getPendingMessages() ?? const <ChatMessage>[];
      await _localDataSource?.saveConversationId(conversationId);
      await _localDataSource?.saveMessages([
        ...mappedMessages,
        ...pendingMessages,
      ]);

      return Right(
        ChatPageContent(
          faqSectionTitle: mockContent.faqSectionTitle,
          todayDividerLabel: mockContent.todayDividerLabel,
          agent: mockContent.agent,
          faqs: mockContent.faqs,
          messages: _mergeMessages(
            mappedMessages,
            pendingMessages,
          ),
        ),
      );
    } on Exception catch (exception, stackTrace) {
      final cachedMessages = _localDataSource?.getCachedMessages();
      if (cachedMessages != null && cachedMessages.isNotEmpty) {
        final mockContent = _mockDataSource.getPageContent();
        return Right(
          ChatPageContent(
            faqSectionTitle: mockContent.faqSectionTitle,
            todayDividerLabel: mockContent.todayDividerLabel,
            agent: mockContent.agent,
            faqs: mockContent.faqs,
            messages: cachedMessages,
          ),
        );
      }

      final hasNetwork = await _networkInfo?.isConnected ?? true;
      if (!hasNetwork) {
        final mockContent = _mockDataSource.getPageContent();
        return Right(
          ChatPageContent(
            faqSectionTitle: mockContent.faqSectionTitle,
            todayDividerLabel: mockContent.todayDividerLabel,
            agent: mockContent.agent,
            faqs: mockContent.faqs,
            messages: _localDataSource?.getPendingMessages() ?? const [],
          ),
        );
      }

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
      if (!await _hasNetwork()) {
        return Right(await _queuePendingMessage(text, attachments));
      }

      var conversationId = _conversationId;
      if (conversationId == null || conversationId.isEmpty) {
        final conversation = await _remoteDataSource.getOrCreateConversation();
        conversationId = conversation['id']?.toString();
        if (conversationId == null || conversationId.isEmpty) {
          throw StateError('Conversation id is missing.');
        }
        _conversationId = conversationId;
        await _localDataSource?.saveConversationId(conversationId);
        await _socketService.connect(conversationId);
      }

      final message = await _remoteDataSource.sendMessage(
        conversationId: conversationId,
        text: text,
        attachments: attachments,
      );
      final mappedMessage = ChatMessageMapper.fromJson(message);
      await _localDataSource?.upsertCachedMessage(mappedMessage);
      return Right(mappedMessage);
    } on Exception catch (exception, stackTrace) {
      if (exception is DioException && exception.type != DioExceptionType.badResponse) {
        return Right(await _queuePendingMessage(text, attachments));
      }

      return Left(
        FailureMapper.fromException(
          exception,
          stackTrace: stackTrace,
        ),
      );
    }
  }

  @override
  ResultFuture<List<ChatMessageSyncResult>> syncPendingMessages() async {
    try {
      final localDataSource = _localDataSource;
      if (localDataSource == null || !await _hasNetwork()) {
        return const Right([]);
      }

      var conversationId = _conversationId ?? localDataSource.getCachedConversationId();
      if (conversationId == null || conversationId.isEmpty) {
        final conversation = await _remoteDataSource.getOrCreateConversation();
        conversationId = conversation['id']?.toString();
        if (conversationId == null || conversationId.isEmpty) {
          throw StateError('Conversation id is missing.');
        }
        _conversationId = conversationId;
        await localDataSource.saveConversationId(conversationId);
      }

      await _socketService.connect(conversationId);

      final syncedMessages = <ChatMessageSyncResult>[];
      for (final pendingMessage in localDataSource.getPendingMessages()) {
        final response = await _remoteDataSource.sendMessage(
          conversationId: conversationId,
          text: pendingMessage.text,
          attachments: pendingMessage.attachments,
        );
        final remoteMessage = ChatMessageMapper.fromJson(response);
        await localDataSource.deletePendingMessage(pendingMessage.id);
        await localDataSource.replaceCachedMessage(
          localId: pendingMessage.id,
          remoteMessage: remoteMessage,
        );
        syncedMessages.add(
          ChatMessageSyncResult(
            localId: pendingMessage.id,
            message: remoteMessage,
          ),
        );
      }

      return Right(syncedMessages);
    } on Exception catch (exception, stackTrace) {
      return Left(
        FailureMapper.fromException(
          exception,
          stackTrace: stackTrace,
        ),
      );
    }
  }

  Future<bool> _hasNetwork() async {
    return _networkInfo?.isConnected ?? true;
  }

  Future<ChatMessage> _queuePendingMessage(
    String text,
    List<ChatAttachment> attachments,
  ) async {
    final message = ChatMessage(
      id: 'local-chat-${DateTime.now().microsecondsSinceEpoch}',
      sender: ChatMessageSender.user,
      text: text,
      sentAt: DateTime.now(),
      attachments: attachments,
      deliveryStatus: ChatMessageDeliveryStatus.sending,
    );

    await _localDataSource?.savePendingMessage(message);
    return message;
  }

  List<ChatMessage> _mergeMessages(
    List<ChatMessage> remoteMessages,
    List<ChatMessage> pendingMessages,
  ) {
    return [
      ...remoteMessages.where(
        (remote) => pendingMessages.every((pending) => pending.id != remote.id),
      ),
      ...pendingMessages,
    ]..sort((a, b) => a.sentAt.compareTo(b.sentAt));
  }
}
