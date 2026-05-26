import 'package:app/app/app.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';

void main() {
  testWidgets('App renders MaterialApp.router', (tester) async {
    final router = GoRouter(
      routes: [
        GoRoute(
          path: '/',
          builder: (context, state) => const Scaffold(
            body: Text('Smoke'),
          ),
        ),
      ],
    );

    await tester.pumpWidget(
      App(
        routerConfig: router,
        appName: 'Test App',
      ),
    );
    await tester.pumpAndSettle();

    expect(find.byType(MaterialApp), findsOneWidget);
    expect(find.text('Smoke'), findsOneWidget);

    router.dispose();
  });
}
