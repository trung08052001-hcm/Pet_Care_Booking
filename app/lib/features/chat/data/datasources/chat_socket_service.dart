import 'dart:async';

import 'package:app/core/config/app_config.dart';
import 'package:app/core/storage/storage_service.dart';
import 'package:injectable/injectable.dart';
import 'package:socket_io_client/socket_io_client.dart' as io;

@lazySingleton
class ChatSocketService {
  ChatSocketService(
    this._appConfig,
    this._secureStorageService,
  );

  final AppConfig _appConfig;
  final SecureStorageService _secureStorageService;
  final _messageController = StreamController<Map<String, dynamic>>.broadcast();
  io.Socket? _socket;
  String? _joinedConversationId;

  Stream<Map<String, dynamic>> get messages => _messageController.stream;

  Future<void> connect(String conversationId) async {
    _joinedConversationId = conversationId;
    final token = await _secureStorageService.read(StorageKeys.authToken);
    if (token == null || token.isEmpty) {
      return;
    }

    final socket = _socket;
    if (socket != null && socket.connected) {
      _joinConversation(socket, conversationId);
      return;
    }

    final nextSocket = io.io(
      _socketBaseUrl,
      io.OptionBuilder()
          .setTransports(['websocket'])
          .disableAutoConnect()
          .setAuth({'token': token})
          .build(),
    );

    nextSocket.onConnect((_) {
      final joinedConversationId = _joinedConversationId;
      if (joinedConversationId != null) {
        _joinConversation(nextSocket, joinedConversationId);
      }
    });
    nextSocket.on('chat:message', (payload) {
      if (payload is Map) {
        final message = payload['message'];
        if (message is Map) {
          _messageController.add(Map<String, dynamic>.from(message));
        }
      }
    });
    nextSocket.connect();
    _socket = nextSocket;
  }

  void _joinConversation(io.Socket socket, String conversationId) {
    socket.emit('chat:join', {'conversationId': conversationId});
  }

  String get _socketBaseUrl {
    final baseUrl = _appConfig.baseUrl;
    if (baseUrl.endsWith('/api/v1')) {
      return baseUrl.substring(0, baseUrl.length - '/api/v1'.length);
    }
    return baseUrl;
  }

  Future<void> dispose() async {
    _socket?.dispose();
    _socket = null;
    await _messageController.close();
  }
}
