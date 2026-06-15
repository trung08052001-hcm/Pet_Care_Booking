import 'dart:async';

import 'package:app/app/router/app_router.dart';
import 'package:app/app/theme/app_theme.dart';
import 'package:app/core/app_localizations.dart';
import 'package:app/core/common/app_bloc_observer.dart';
import 'package:app/core/config/app_config.dart';
import 'package:app/core/config/app_flavor.dart';
import 'package:app/core/di/injection.dart';
import 'package:app/core/local/hive_local_store.dart';
import 'package:app/core/locale_cubit.dart';
import 'package:app/core/network/offline_banner.dart';
import 'package:app/core/notifications/push_notification_service.dart';
import 'package:app/core/presence/presence_socket_service.dart';
import 'package:app/core/storage/storage_service.dart';
import 'package:app/features/authentication/data/services/zalo_auth_service.dart';
import 'package:app/features/authentication/presentation/bloc/auth_bloc.dart';
import 'package:app/features/authentication/presentation/bloc/auth_event.dart';
import 'package:app/features/pets/data/services/pet_sync_service.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

@pragma('vm:entry-point')
Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
}

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const BootstrapApp());

  await Firebase.initializeApp();
  FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);
  await HiveLocalStore.init();

  final appConfig = AppConfig.fromFlavor(AppFlavor.dev);
  await configureDependencies(appConfig);

  await ZaloAuthService.init(appId: '2334159220396951537');
  Bloc.observer = getIt<AppBlocObserver>();

  runApp(const MyApp());
  unawaited(_startBackgroundServices());
}

Future<void> _startBackgroundServices() async {
  try {
    getIt<PetSyncService>().start();
    await getIt<PushNotificationService>().init();
    await getIt<PresenceSocketService>().start();
  } on Exception catch (error, stackTrace) {
    debugPrint('Background service init failed: $error');
    debugPrintStack(stackTrace: stackTrace);
  }
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final appRouter = getIt<AppRouter>().router;

    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => LocaleCubit(getIt<AppPreferences>())),
        BlocProvider(
          create: (_) =>
              getIt<AuthBloc>()..add(const AuthSessionRestoreRequested()),
        ),
      ],
      child: BlocBuilder<LocaleCubit, Locale>(
        builder: (context, locale) {
          return MaterialApp.router(
            onGenerateTitle: (context) => AppLocalizations.of(context).appTitle,
            theme: AppTheme.light(),
            routerConfig: appRouter,
            builder: (context, child) => OfflineBanner(
              child: child ?? const SizedBox.shrink(),
            ),
            debugShowCheckedModeBanner: false,
            locale: locale,
            localizationsDelegates: const [
              AppLocalizations.delegate,
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
            ],
            supportedLocales: AppLocalizations.supportedLocales,
          );
        },
      ),
    );
  }
}

class BootstrapApp extends StatelessWidget {
  const BootstrapApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light(),
      home: const Scaffold(
        backgroundColor: Color(0xFFF3FAFC),
        body: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.pets_rounded, size: 46, color: Color(0xFFB46A00)),
              SizedBox(height: 16),
              CircularProgressIndicator(color: Color(0xFFB46A00)),
              SizedBox(height: 14),
              Text(
                'Đang khởi động...',
                style: TextStyle(
                  color: Color(0xFF5A3921),
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
