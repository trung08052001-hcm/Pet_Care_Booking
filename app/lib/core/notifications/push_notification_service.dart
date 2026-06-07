import 'dart:async';

import 'package:app/core/local/hive_box_names.dart';
import 'package:app/core/local/hive_local_store.dart';
import 'package:app/core/network/api_service.dart';
import 'package:app/core/network/network_info.dart';
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
  );

  final FirebaseMessaging _messaging;
  final FlutterLocalNotificationsPlugin _localNotifications;
  final AppApiService _apiService;
  final HiveLocalStore _store;
  final NetworkInfo _networkInfo;
  final Connectivity _connectivity;

  StreamSubscription<RemoteMessage>? _foregroundSubscription;
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
      _showForegroundNotification(message);
    });
    await syncPendingToken();
  }

  Future<void> _initLocalNotifications() async {
    const androidInit = AndroidInitializationSettings('@mipmap/ic_launcher');
    const darwinInit = DarwinInitializationSettings();
    const settings = InitializationSettings(
      android: androidInit,
      iOS: darwinInit,
      macOS: darwinInit,
    );
    await _localNotifications.initialize(settings);
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
    await _tokenSubscription?.cancel();
    await _connectivitySubscription?.cancel();
    _foregroundSubscription = null;
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
      if (!await _networkInfo.isConnected) {
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
    if (token == null || token.isEmpty || !await _networkInfo.isConnected) {
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
      payload: message.data['bookingId'] as String?,
    );
  }
}
