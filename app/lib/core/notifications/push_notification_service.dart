import 'dart:async';
import 'dart:convert';

import 'package:app/app/router/app_router.dart';
import 'package:app/app/shell/main_shell_page.dart';
import 'package:app/core/local/hive_box_names.dart';
import 'package:app/core/local/hive_local_store.dart';
import 'package:app/core/network/api_service.dart';
import 'package:app/core/network/network_info.dart';
import 'package:app/core/storage/storage_service.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class PushNotificationService {
  PushNotificationService(
    this._messaging,
    this._localNotifications,
    this._apiService,
    this._store,
    this._networkInfo,
    this._connectivity,
    this._secureStorageService,
    this._appRouter,
  );

  final FirebaseMessaging _messaging;
  final FlutterLocalNotificationsPlugin _localNotifications;
  final AppApiService _apiService;
  final HiveLocalStore _store;
  final NetworkInfo _networkInfo;
  final Connectivity _connectivity;
  final SecureStorageService _secureStorageService;
  final AppRouter _appRouter;

  StreamSubscription<RemoteMessage>? _foregroundSubscription;
  StreamSubscription<RemoteMessage>? _messageOpenedSubscription;
  StreamSubscription<String>? _tokenSubscription;
  StreamSubscription<List<ConnectivityResult>>? _connectivitySubscription;

  static const AndroidNotificationChannel _androidChannel =
      AndroidNotificationChannel(
        'booking_updates',
        'Booking updates',
        description: 'Notifications for booking updates and reminders.',
        importance: Importance.high,
      );

  Future<void> init() async {
    await _messaging.requestPermission();
    await _initLocalNotifications();
    await _messaging.setForegroundNotificationPresentationOptions(
      alert: true,
      badge: true,
      sound: true,
    );
    await _registerCurrentToken();

    _tokenSubscription ??= _messaging.onTokenRefresh.listen(_registerToken);
    _connectivitySubscription ??= _connectivity.onConnectivityChanged.listen(
      (_) => syncPendingToken(),
    );
    _foregroundSubscription ??= FirebaseMessaging.onMessage.listen((message) {
      _saveForegroundMessage(message);
      if (!_isChatMessage(message)) {
        _showForegroundNotification(message);
      }
    });
    _messageOpenedSubscription ??=
        FirebaseMessaging.onMessageOpenedApp.listen(_openFromMessage);
    await syncPendingToken();
    await _openInitialMessage();
  }

  Future<void> _initLocalNotifications() async {
    const androidInit = AndroidInitializationSettings('@mipmap/ic_launcher');
    const darwinInit = DarwinInitializationSettings();
    const settings = InitializationSettings(
      android: androidInit,
      iOS: darwinInit,
      macOS: darwinInit,
    );
    await _localNotifications.initialize(
      settings,
      onDidReceiveNotificationResponse: (response) {
        _openFromPayload(response.payload);
      },
    );
    await _localNotifications
        .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin
        >()
        ?.createNotificationChannel(_androidChannel);
    await _localNotifications
        .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin
        >()
        ?.requestNotificationsPermission();
  }

  Future<void> dispose() async {
    await _foregroundSubscription?.cancel();
    await _messageOpenedSubscription?.cancel();
    await _tokenSubscription?.cancel();
    await _connectivitySubscription?.cancel();
    _foregroundSubscription = null;
    _messageOpenedSubscription = null;
    _tokenSubscription = null;
    _connectivitySubscription = null;
  }

  Future<void> _registerCurrentToken() async {
    final token = await _messaging.getToken();
    if (token != null && token.isNotEmpty) {
      await _registerToken(token);
    }
  }

  Future<void> _registerToken(String token) async {
    try {
      if (!await _networkInfo.isConnected || !await _hasAuthToken()) {
        throw StateError('Offline');
      }
      await _apiService.registerDeviceToken({
        'token': token,
        'platform': 'flutter',
      });
    } on Exception {
      await _store.putMap(
        boxName: HiveBoxNames.appCache,
        key: 'pending_fcm_token',
        value: {
          'token': token,
          'platform': 'flutter',
          'updatedAt': DateTime.now().toIso8601String(),
        },
      );
    }
  }

  Future<void> syncPendingToken() async {
    final pending = _store.getMap(
      boxName: HiveBoxNames.appCache,
      key: 'pending_fcm_token',
    );
    final token = pending?['token'] as String?;
    if (token == null ||
        token.isEmpty ||
        !await _networkInfo.isConnected ||
        !await _hasAuthToken()) {
      return;
    }

    try {
      await _apiService.registerDeviceToken({
        'token': token,
        'platform': pending?['platform'] as String? ?? 'flutter',
      });
      await _store.delete(
        boxName: HiveBoxNames.appCache,
        key: 'pending_fcm_token',
      );
    } on Exception {
      return;
    }
  }

  Future<void> registerCurrentTokenForAuthenticatedUser() async {
    await _registerCurrentToken();
    await syncPendingToken();
  }

  Future<void> _saveForegroundMessage(RemoteMessage message) {
    final key =
        message.messageId ?? DateTime.now().microsecondsSinceEpoch.toString();
    return _store.putMap(
      boxName: HiveBoxNames.notifications,
      key: key,
      value: {
        'id': key,
        'title': message.notification?.title ?? message.data['title'],
        'body': message.notification?.body ?? message.data['body'],
        'data': message.data,
        'receivedAt': DateTime.now().toIso8601String(),
        'read': false,
      },
    );
  }

  Future<bool> _hasAuthToken() async {
    final token = await _secureStorageService.read(StorageKeys.authToken);
    if (token == null || token.isEmpty) {
      return false;
    }

    return !_isJwtExpired(token);
  }

  bool _isJwtExpired(String token) {
    final parts = token.split('.');
    if (parts.length != 3) {
      return true;
    }

    try {
      final payload = jsonDecode(
        utf8.decode(base64Url.decode(base64Url.normalize(parts[1]))),
      );
      if (payload is! Map<String, dynamic>) {
        return true;
      }

      final exp = payload['exp'];
      if (exp is! num) {
        return true;
      }

      final expiresAt = DateTime.fromMillisecondsSinceEpoch(
        exp.toInt() * 1000,
      );
      return expiresAt.isBefore(
        DateTime.now().add(const Duration(seconds: 10)),
      );
    } on Exception {
      return true;
    }
  }

  Future<void> _showForegroundNotification(RemoteMessage message) async {
    final title =
        message.notification?.title ?? message.data['title'] as String?;
    final body = message.notification?.body ?? message.data['body'] as String?;
    if ((title == null || title.isEmpty) && (body == null || body.isEmpty)) {
      return;
    }

    await _localNotifications.show(
      message.hashCode,
      title ?? 'Pet Care Booking',
      body ?? '',
      NotificationDetails(
        android: AndroidNotificationDetails(
          _androidChannel.id,
          _androidChannel.name,
          channelDescription: _androidChannel.description,
          importance: Importance.high,
          priority: Priority.high,
          icon: '@mipmap/ic_launcher',
        ),
        iOS: const DarwinNotificationDetails(),
      ),
      payload: jsonEncode(message.data),
    );
  }

  bool _isChatMessage(RemoteMessage message) {
    return message.data['type'] == 'chat_message';
  }

  Future<void> _openInitialMessage() async {
    final initialMessage = await _messaging.getInitialMessage();
    if (initialMessage != null) {
      await Future<void>.delayed(const Duration(milliseconds: 300));
      _openFromMessage(initialMessage);
    }
  }

  void _openFromMessage(RemoteMessage message) {
    if (_isChatMessage(message)) {
      _openChat();
    }
  }

  void _openFromPayload(String? payload) {
    if (payload == null || payload.isEmpty) {
      return;
    }

    try {
      final data = jsonDecode(payload);
      if (data is Map<String, dynamic> && data['type'] == 'chat_message') {
        _openChat();
      }
    } on Exception {
      return;
    }
  }

  void _openChat() {
    _appRouter.router.go('${MainShellPage.routePath}?tab=chat');
  }
}
