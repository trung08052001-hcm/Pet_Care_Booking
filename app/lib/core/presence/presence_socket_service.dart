import 'package:app/core/config/app_config.dart';
import 'package:app/core/storage/storage_service.dart';
import 'package:flutter/widgets.dart';
import 'package:socket_io_client/socket_io_client.dart' as io;

class PresenceSocketService with WidgetsBindingObserver {
  PresenceSocketService(
    this._appConfig,
    this._secureStorageService,
  );

  final AppConfig _appConfig;
  final SecureStorageService _secureStorageService;
  io.Socket? _socket;
  bool _isStarted = false;

  Future<void> start() async {
    if (!_isStarted) {
      WidgetsBinding.instance.addObserver(this);
      _isStarted = true;
    }
    await _connect();
  }

  Future<void> stop() async {
    _socket?.disconnect();
    _socket?.dispose();
    _socket = null;
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      _connect();
      return;
    }

    if (state == AppLifecycleState.paused ||
        state == AppLifecycleState.detached) {
      stop();
    }
  }

  Future<void> _connect() async {
    final token = await _secureStorageService.read(StorageKeys.authToken);
    if (token == null || token.isEmpty) {
      return;
    }

    final socket = _socket;
    if (socket != null && socket.connected) {
      socket.emit('presence:online');
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
      nextSocket.emit('presence:online');
    });
    nextSocket.connect();
    _socket = nextSocket;
  }

  String get _socketBaseUrl {
    final baseUrl = _appConfig.baseUrl;
    if (baseUrl.endsWith('/api/v1')) {
      return baseUrl.substring(0, baseUrl.length - '/api/v1'.length);
    }
    return baseUrl;
  }
}
