import 'package:app/core/network/api_config.dart';
import 'package:app/features/chat/domain/entities/chat_attachment.dart';
import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';

@lazySingleton
class ChatRemoteDataSource {
  ChatRemoteDataSource(this._dio);

  final Dio _dio;

  Future<Map<String, dynamic>> getOrCreateConversation() async {
    final response = await _dio.post<Map<String, dynamic>>(
      ApiEndpoints.chatConversations,
    );

    final data = response.data?['data'];
    if (data is Map<String, dynamic>) {
      final conversation = data['conversation'];
      if (conversation is Map<String, dynamic>) {
        return conversation;
      }
    }

    throw StateError('Invalid chat conversation response.');
  }

  Future<List<Map<String, dynamic>>> getMessages(String conversationId) async {
    final response = await _dio.get<Map<String, dynamic>>(
      ApiEndpoints.chatMessages.replaceAll('{conversationId}', conversationId),
    );

    final data = response.data?['data'];
    if (data is Map<String, dynamic>) {
      final messages = data['messages'];
      if (messages is List) {
        return messages
            .whereType<Map<String, dynamic>>()
            .toList()
            .map(Map<String, dynamic>.from)
            .toList();
      }
    }

    throw StateError('Invalid chat messages response.');
  }

  Future<Map<String, dynamic>> sendMessage({
    required String conversationId,
    required String text,
    List<ChatAttachment> attachments = const [],
  }) async {
    final response = await _dio.post<Map<String, dynamic>>(
      ApiEndpoints.chatMessages.replaceAll('{conversationId}', conversationId),
      data: {
        'text': text,
        if (attachments.isNotEmpty)
          'attachments':
              attachments.map((attachment) => attachment.toJson()).toList(),
      },
    );

    final data = response.data?['data'];
    if (data is Map<String, dynamic>) {
      final message = data['message'];
      if (message is Map<String, dynamic>) {
        return message;
      }
    }

    throw StateError('Invalid chat send message response.');
  }
}
