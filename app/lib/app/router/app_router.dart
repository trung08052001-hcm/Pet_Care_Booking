import 'package:app/core/di/injection.dart';
import 'package:app/core/storage/storage_service.dart';
import 'package:app/features/authentication/presentation/pages/forgot_password_otp_page.dart';
import 'package:app/features/authentication/presentation/pages/forgot_password_page.dart';
import 'package:app/features/authentication/presentation/pages/reset_password_page.dart';
import 'package:app/features/authentication/presentation/pages/sign_in_page.dart';
import 'package:app/features/authentication/presentation/pages/sign_up_page.dart';
import 'package:app/features/onboarding/presentation/bloc/onboarding_bloc.dart';
import 'package:app/features/onboarding/presentation/pages/onboarding_page.dart';
import 'package:app/features/sample_posts/presentation/bloc/sample_posts_bloc.dart';
import 'package:app/features/sample_posts/presentation/pages/sample_posts_page.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:injectable/injectable.dart';

@lazySingleton
class AppRouter {
  AppRouter();

  String get _initialLocation {
    final hasCompletedOnboarding =
        getIt<AppPreferences>().readBool(StorageKeys.hasCompletedOnboarding) ??
            false;
    final isAuthenticated =
        getIt<AppPreferences>().readBool(StorageKeys.isAuthenticated) ?? false;

    if (!hasCompletedOnboarding) {
      return OnboardingPage.routePath;
    }

    return isAuthenticated
        ? SamplePostsPage.routePath
        : SignInPage.routePath;
  }

  late final GoRouter router = GoRouter(
    initialLocation: _initialLocation,
    routes: [
      GoRoute(
        path: OnboardingPage.routePath,
        name: OnboardingPage.routeName,
        builder: (context, state) {
          return BlocProvider(
            create: (_) => OnboardingBloc(getIt<AppPreferences>()),
            child: const OnboardingPage(),
          );
        },
      ),
      GoRoute(
        path: SamplePostsPage.routePath,
        name: SamplePostsPage.routeName,
        builder: (context, state) {
          return BlocProvider(
            create: (_) =>
                getIt<SamplePostsBloc>()..add(const SamplePostsRequested()),
            child: const SamplePostsPage(),
          );
        },
      ),
      GoRoute(
        path: SignInPage.routePath,
        name: SignInPage.routeName,
        builder: (context, state) {
          return const SignInPage();
        },
      ),
      GoRoute(
        path: SignUpPage.routePath,
        name: SignUpPage.routeName,
        builder: (context, state) {
          return const SignUpPage();
        },
      ),
      GoRoute(
        path: ForgotPasswordPage.routePath,
        name: ForgotPasswordPage.routeName,
        builder: (context, state) {
          return const ForgotPasswordPage();
        },
      ),
      GoRoute(
        path: ForgotPasswordOtpPage.routePath,
        name: ForgotPasswordOtpPage.routeName,
        builder: (context, state) {
          return ForgotPasswordOtpPage(
            phoneNumber: state.extra as String? ?? '',
          );
        },
      ),
      GoRoute(
        path: ResetPasswordPage.routePath,
        name: ResetPasswordPage.routeName,
        builder: (context, state) {
          return ResetPasswordPage(
            phoneNumber: state.extra as String? ?? '',
          );
        },
      ),
    ],
  );
}
