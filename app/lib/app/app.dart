import 'package:app/app/router/app_router.dart';
import 'package:app/app/theme/app_theme.dart';
import 'package:app/core/config/app_config.dart';
import 'package:app/core/di/injection.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class App extends StatelessWidget {
  const App({
    super.key,
    this.routerConfig,
    this.appName,
  });

  final GoRouter? routerConfig;
  final String? appName;

  @override
  Widget build(BuildContext context) {
    final resolvedRouter = routerConfig ?? getIt<AppRouter>().router;
    final resolvedAppName = appName ?? getIt<AppConfig>().appName;

    return MaterialApp.router(
      title: resolvedAppName,
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light(),
      routerConfig: resolvedRouter,
    );
  }
}
