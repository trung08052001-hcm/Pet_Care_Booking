import 'package:app/app/shell/main_shell_page.dart';
import 'package:app/app/shell/presentation/bloc/main_shell_bloc.dart';
import 'package:app/core/di/injection.dart';
import 'package:app/core/storage/storage_service.dart';
import 'package:app/features/authentication/presentation/pages/forgot_password_otp_page.dart';
import 'package:app/features/authentication/presentation/pages/forgot_password_page.dart';
import 'package:app/features/authentication/presentation/pages/reset_password_page.dart';
import 'package:app/features/authentication/presentation/pages/sign_in_page.dart';
import 'package:app/features/authentication/presentation/pages/sign_up_page.dart';
import 'package:app/features/blog/presentation/bloc/blog_bloc.dart';
import 'package:app/features/blog/presentation/bloc/blog_event.dart';
import 'package:app/features/booking/presentation/bloc/booking_bloc.dart';
import 'package:app/features/booking/presentation/bloc/booking_detail_bloc.dart';
import 'package:app/features/booking/presentation/bloc/booking_detail_event.dart';
import 'package:app/features/booking/presentation/bloc/booking_event.dart';
import 'package:app/features/booking/presentation/pages/booking_detail_page.dart';
import 'package:app/features/booking/presentation/pages/booking_history_page.dart';
import 'package:app/features/chat/presentation/bloc/chat_bloc.dart';
import 'package:app/features/chat/presentation/bloc/chat_event.dart';
import 'package:app/features/home/presentation/bloc/home_bloc.dart';
import 'package:app/features/home/presentation/bloc/home_event.dart';
import 'package:app/features/onboarding/presentation/bloc/onboarding_bloc.dart';
import 'package:app/features/onboarding/presentation/pages/onboarding_page.dart';
import 'package:app/features/pets/domain/entities/pet.dart';
import 'package:app/features/pets/presentation/bloc/pets_bloc.dart';
import 'package:app/features/pets/presentation/bloc/pets_event.dart';
import 'package:app/features/pets/presentation/pages/my_pets_page.dart';
import 'package:app/features/pets/presentation/pages/pet_profile_detail_page.dart';
import 'package:app/features/pets/presentation/pages/profile_my_pets_page.dart';
import 'package:app/features/profile/domain/entities/help_center_category.dart';
import 'package:app/features/profile/domain/entities/help_center_content.dart';
import 'package:app/features/profile/presentation/bloc/app_review_bloc.dart';
import 'package:app/features/profile/presentation/bloc/help_center_bloc.dart';
import 'package:app/features/profile/presentation/bloc/help_center_event.dart';
import 'package:app/features/profile/presentation/bloc/profile_address_bloc.dart';
import 'package:app/features/profile/presentation/bloc/profile_address_event.dart';
import 'package:app/features/profile/presentation/bloc/profile_bloc.dart';
import 'package:app/features/profile/presentation/bloc/profile_edit_bloc.dart';
import 'package:app/features/profile/presentation/bloc/profile_edit_event.dart';
import 'package:app/features/profile/presentation/bloc/profile_event.dart';
import 'package:app/features/profile/presentation/pages/app_review_page.dart';
import 'package:app/features/profile/presentation/pages/help_center_detail_page.dart';
import 'package:app/features/profile/presentation/pages/help_center_faq_detail_page.dart';
import 'package:app/features/profile/presentation/pages/help_center_page.dart';
import 'package:app/features/profile/presentation/pages/language_settings_page.dart';
import 'package:app/features/profile/presentation/pages/profile_address_page.dart';
import 'package:app/features/profile/presentation/pages/profile_edit_page.dart';
import 'package:app/features/sample_posts/presentation/bloc/sample_posts_bloc.dart';
import 'package:app/features/sample_posts/presentation/pages/sample_posts_page.dart';
import 'package:app/features/services/presentation/bloc/services_bloc.dart';
import 'package:app/features/services/presentation/bloc/services_event.dart';
import 'package:flutter/material.dart';
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
        ? MainShellPage.routePath
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
        path: MainShellPage.routePath,
        name: MainShellPage.routeName,
        builder: (context, state) {
          return MultiBlocProvider(
            providers: [
              BlocProvider(
                create: (_) =>
                    getIt<HomeBloc>()..add(const HomeStarted()),
              ),
              BlocProvider(
                create: (_) =>
                    getIt<ServicesBloc>()..add(const ServicesStarted()),
              ),
              BlocProvider(
                create: (_) => getIt<BlogBloc>()..add(const BlogStarted()),
              ),
              BlocProvider(
                create: (_) => getIt<ChatBloc>()..add(const ChatStarted()),
              ),
              BlocProvider(
                create: (_) =>
                    getIt<ProfileBloc>()..add(const ProfileStarted()),
              ),
              BlocProvider(
                create: (_) => MainShellBloc(),
              ),
            ],
            child: const MainShellPage(),
          );
        },
      ),
      GoRoute(
        path: BookingDetailPage.routePath,
        name: BookingDetailPage.routeName,
        builder: (context, state) {
          final bookingId = state.pathParameters['bookingId'] ?? '';
          return BlocProvider(
            create: (_) => getIt<BookingDetailBloc>()
              ..add(BookingDetailStarted(bookingId)),
            child: BookingDetailPage(bookingId: bookingId),
          );
        },
      ),
      GoRoute(
        path: BookingHistoryPage.routePath,
        name: BookingHistoryPage.routeName,
        builder: (context, state) {
          return const BookingHistoryPage();
        },
      ),
      GoRoute(
        path: MyPetsPage.routePath,
        name: MyPetsPage.routeName,
        builder: (context, state) {
          final args = MyPetsPage.argsFrom(state.extra);
          return MultiBlocProvider(
            providers: [
              BlocProvider(
                create: (_) => getIt<PetsBloc>()
                  ..add(PetsStarted(serviceId: args?.serviceId)),
              ),
              BlocProvider(
                create: (_) => getIt<BookingBloc>()
                  ..add(BookingStarted(serviceId: args?.serviceId)),
              ),
            ],
            child: MyPetsPage(serviceId: args?.serviceId),
          );
        },
      ),
      GoRoute(
        path: ProfileMyPetsPage.routePath,
        name: ProfileMyPetsPage.routeName,
        builder: (context, state) {
          return BlocProvider(
            create: (_) => getIt<PetsBloc>()..add(const PetsStarted()),
            child: const ProfileMyPetsPage(),
          );
        },
      ),
      GoRoute(
        path: PetProfileDetailPage.routePath,
        name: PetProfileDetailPage.routeName,
        builder: (context, state) {
          final petId = state.pathParameters['petId'] ?? '';
          final initialPet = state.extra is Pet ? state.extra as Pet : null;

          return BlocProvider(
            create: (_) => getIt<PetsBloc>()..add(const PetsStarted()),
            child: PetProfileDetailPage(
              petId: petId,
              initialPet: initialPet,
            ),
          );
        },
      ),
      GoRoute(
        path: ProfileAddressPage.routePath,
        name: ProfileAddressPage.routeName,
        builder: (context, state) {
          return BlocProvider(
            create: (_) =>
                getIt<ProfileAddressBloc>()..add(const ProfileAddressStarted()),
            child: const ProfileAddressPage(),
          );
        },
      ),
      GoRoute(
        path: ProfileEditPage.routePath,
        name: ProfileEditPage.routeName,
        builder: (context, state) {
          return BlocProvider(
            create: (_) =>
                getIt<ProfileEditBloc>()..add(const ProfileEditStarted()),
            child: const ProfileEditPage(),
          );
        },
      ),
      GoRoute(
        path: HelpCenterPage.routePath,
        name: HelpCenterPage.routeName,
        builder: (context, state) {
          return BlocProvider(
            create: (_) =>
                getIt<HelpCenterBloc>()..add(const HelpCenterStarted()),
            child: const HelpCenterPage(),
          );
        },
      ),
      GoRoute(
        path: HelpCenterDetailPage.routePath,
        name: HelpCenterDetailPage.routeName,
        builder: (context, state) {
          final topic = state.extra as HelpCenterCategory?;
          if (topic == null) {
            return const _RouteMissingPage(message: 'Không tìm thấy mục hỗ trợ.');
          }
          return HelpCenterDetailPage(topic: topic);
        },
      ),
      GoRoute(
        path: HelpCenterFaqDetailPage.routePath,
        name: HelpCenterFaqDetailPage.routeName,
        builder: (context, state) {
          final faq = state.extra as HelpCenterFaq?;
          if (faq == null) {
            return const _RouteMissingPage(message: 'Không tìm thấy câu hỏi.');
          }
          return HelpCenterFaqDetailPage(faq: faq);
        },
      ),
      GoRoute(
        path: AppReviewPage.routePath,
        name: AppReviewPage.routeName,
        builder: (context, state) {
          return BlocProvider(
            create: (_) => getIt<AppReviewBloc>(),
            child: const AppReviewPage(),
          );
        },
      ),
      GoRoute(
        path: LanguageSettingsPage.routePath,
        name: LanguageSettingsPage.routeName,
        builder: (context, state) {
          return const LanguageSettingsPage();
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
            email: state.extra as String? ?? '',
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

class _RouteMissingPage extends StatelessWidget {
  const _RouteMissingPage({required this.message});

  final String message;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(backgroundColor: Colors.white),
      body: Center(child: Text(message)),
    );
  }
}
