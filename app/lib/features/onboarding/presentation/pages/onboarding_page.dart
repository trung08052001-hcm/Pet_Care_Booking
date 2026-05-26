import 'package:app/core/app_localizations.dart';
import 'package:app/features/authentication/presentation/pages/sign_in_page.dart';
import 'package:app/features/onboarding/presentation/bloc/onboarding_bloc.dart';
import 'package:app/features/onboarding/presentation/bloc/onboarding_event.dart';
import 'package:app/features/onboarding/presentation/bloc/onboarding_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class OnboardingPage extends StatefulWidget {
  const OnboardingPage({super.key});

  static const routeName = 'onboarding';
  static const routePath = '/';

  @override
  State<OnboardingPage> createState() => _OnboardingPageState();
}

class _OnboardingPageState extends State<OnboardingPage> {
  late final PageController _pageController;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  Future<void> _handlePrimaryAction(BuildContext context) async {
    final isLastPage = context.read<OnboardingBloc>().state.isLastPage;

    if (isLastPage) {
      context.read<OnboardingBloc>().add(const OnboardingFinishedRequested());
      return;
    }

    await _pageController.nextPage(
      duration: const Duration(milliseconds: 360),
      curve: Curves.easeInOutCubic,
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final pages = [
      _OnboardingContent(
        title: l10n.onboardingTitle1,
        description: l10n.onboardingDescription1,
        badge: l10n.onboardingBadge1,
        illustrationType: _IllustrationType.care,
      ),
      _OnboardingContent(
        title: l10n.onboardingTitle2,
        description: l10n.onboardingDescription2,
        badge: l10n.onboardingBadge2,
        illustrationType: _IllustrationType.experts,
      ),
      _OnboardingContent(
        title: l10n.onboardingTitle3,
        description: l10n.onboardingDescription3,
        badge: l10n.onboardingBadge3,
        illustrationType: _IllustrationType.booking,
      ),
    ];

    return BlocListener<OnboardingBloc, OnboardingState>(
      listenWhen: (previous, current) =>
          previous.isCompleted != current.isCompleted && current.isCompleted,
      listener: (context, state) {
        context.goNamed(SignInPage.routeName);
      },
      child: Scaffold(
        backgroundColor: const Color(0xFFF8F1E7),
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(20, 12, 20, 20),
            child: Column(
              children: [
                Row(
                  children: [
                    const Icon(
                      Icons.pets_rounded,
                      size: 18,
                      color: Color(0xFFFF8A3D),
                    ),
                    const SizedBox(width: 6),
                    Text(
                      l10n.onboardingBrand,
                      style: const TextStyle(
                        color: Color(0xFF9A5C1F),
                        fontSize: 15,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const Spacer(),
                    TextButton(
                      onPressed: () {
                        context
                            .read<OnboardingBloc>()
                            .add(const OnboardingFinishedRequested());
                      },
                      style: TextButton.styleFrom(
                        foregroundColor: const Color(0xFF8D8D8D),
                      ),
                      child: Text(l10n.skip),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Expanded(
                  child: PageView.builder(
                    controller: _pageController,
                    onPageChanged: (index) {
                      context.read<OnboardingBloc>().add(
                        OnboardingPageChanged(index),
                      );
                    },
                    itemCount: pages.length,
                    itemBuilder: (context, index) {
                      final page = pages[index];

                      return Center(
                        child: ConstrainedBox(
                          constraints: const BoxConstraints(maxWidth: 380),
                          child: Container(
                            margin: const EdgeInsets.symmetric(vertical: 8),
                            padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(26),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withValues(alpha: 0.05),
                                  blurRadius: 24,
                                  offset: const Offset(0, 14),
                                ),
                              ],
                            ),
                            child: Column(
                              children: [
                                _OnboardingIllustration(
                                  badgeLabel: page.badge,
                                  illustrationType: page.illustrationType,
                                ),
                                const SizedBox(height: 28),
                                Text(
                                  page.title,
                                  textAlign: TextAlign.center,
                                  style: const TextStyle(
                                    color: Color(0xFF2E2E2E),
                                    fontSize: 30,
                                    fontWeight: FontWeight.w800,
                                    height: 1.12,
                                  ),
                                ),
                                const SizedBox(height: 14),
                                Padding(
                                  padding:
                                      const EdgeInsets.symmetric(horizontal: 12),
                                  child: Text(
                                    page.description,
                                    textAlign: TextAlign.center,
                                    style: const TextStyle(
                                      color: Color(0xFF8C8C8C),
                                      fontSize: 15,
                                      height: 1.55,
                                    ),
                                  ),
                                ),
                                const Spacer(),
                                _OnboardingFooter(
                                  pageCount: pages.length,
                                  onPrimaryPressed: () {
                                    _handlePrimaryAction(context);
                                  },
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _OnboardingContent {
  const _OnboardingContent({
    required this.title,
    required this.description,
    required this.badge,
    required this.illustrationType,
  });

  final String title;
  final String description;
  final String badge;
  final _IllustrationType illustrationType;
}

enum _IllustrationType {
  care,
  experts,
  booking,
}

class _OnboardingIllustration extends StatelessWidget {
  const _OnboardingIllustration({
    required this.badgeLabel,
    required this.illustrationType,
  });

  final String badgeLabel;
  final _IllustrationType illustrationType;

  @override
  Widget build(BuildContext context) {
    return RepaintBoundary(
      child: AspectRatio(
        aspectRatio: 0.95,
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(24),
            gradient: const LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Color(0xFFFFF3E7),
                Color(0xFFFFE2C6),
              ],
            ),
          ),
          child: Stack(
            children: [
              Positioned(
                left: 20,
                top: 18,
                child: _DecorativeBubble(
                  size: 86,
                  color: Colors.white.withValues(alpha: 0.5),
                ),
              ),
              Positioned(
                right: 24,
                top: 34,
                child: _DecorativeBubble(
                  size: 34,
                  color: Colors.white.withValues(alpha: 0.65),
                ),
              ),
              Positioned(
                left: 0,
                right: 0,
                top: 20,
                bottom: 0,
                child: Center(
                  child: switch (illustrationType) {
                    _IllustrationType.care => const _CareIllustration(),
                    _IllustrationType.experts => const _ExpertsIllustration(),
                    _IllustrationType.booking => const _BookingIllustration(),
                  },
                ),
              ),
              Positioned(
                right: 16,
                bottom: 16,
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(999),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.08),
                        blurRadius: 18,
                        offset: const Offset(0, 8),
                      ),
                    ],
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 8,
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                          width: 24,
                          height: 24,
                          decoration: const BoxDecoration(
                            color: Color(0xFFFFEFE2),
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            Icons.favorite_rounded,
                            size: 14,
                            color: Color(0xFFFF8A3D),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          badgeLabel,
                          style: const TextStyle(
                            color: Color(0xFF6B6B6B),
                            fontSize: 11,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _OnboardingFooter extends StatelessWidget {
  const _OnboardingFooter({
    required this.pageCount,
    required this.onPrimaryPressed,
  });

  final int pageCount;
  final VoidCallback onPrimaryPressed;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return BlocBuilder<OnboardingBloc, OnboardingState>(
      buildWhen: (previous, current) => previous.currentPage != current.currentPage,
      builder: (context, state) {
        return Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(
                pageCount,
                (dotIndex) => AnimatedContainer(
                  duration: const Duration(milliseconds: 220),
                  margin: const EdgeInsets.symmetric(horizontal: 4),
                  height: 7,
                  width: state.currentPage == dotIndex ? 22 : 7,
                  decoration: BoxDecoration(
                    color: state.currentPage == dotIndex
                        ? const Color(0xFFFF8A3D)
                        : const Color(0xFFF0D3BE),
                    borderRadius: BorderRadius.circular(999),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 22),
            AnimatedSwitcher(
              duration: const Duration(milliseconds: 220),
              switchInCurve: Curves.easeOutCubic,
              switchOutCurve: Curves.easeInCubic,
              child: state.isLastPage
                  ? SizedBox(
                      key: const ValueKey('last-page-button'),
                      width: double.infinity,
                      child: FilledButton(
                        onPressed: onPrimaryPressed,
                        style: FilledButton.styleFrom(
                          backgroundColor: const Color(0xFFFF8A3D),
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(18),
                          ),
                          textStyle: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(l10n.getStarted),
                            const SizedBox(width: 8),
                            const Icon(Icons.arrow_forward_rounded),
                          ],
                        ),
                      ),
                    )
                  : SizedBox(
                      key: const ValueKey('swipe-hint'),
                      height: 56,
                      child: Center(
                        child: Text(
                          l10n.swipeToContinue,
                          style: const TextStyle(
                            color: Color(0xFFB08968),
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
            ),
          ],
        );
      },
    );
  }
}

class _DecorativeBubble extends StatelessWidget {
  const _DecorativeBubble({
    required this.size,
    required this.color,
  });

  final double size;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: color,
        shape: BoxShape.circle,
      ),
    );
  }
}

class _CareIllustration extends StatelessWidget {
  const _CareIllustration();

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        Container(
          width: 220,
          height: 220,
          decoration: const BoxDecoration(
            color: Color(0xFFFF9B50),
            shape: BoxShape.circle,
          ),
        ),
        Container(
          width: 178,
          height: 178,
          decoration: const BoxDecoration(
            color: Color(0xFFFFF7F0),
            shape: BoxShape.circle,
          ),
        ),
        const Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.pets_rounded,
              size: 94,
              color: Color(0xFFB86A2D),
            ),
            SizedBox(height: 10),
            Text(
              'PET CARE',
              style: TextStyle(
                color: Color(0xFF6C4020),
                fontSize: 18,
                fontWeight: FontWeight.w800,
                letterSpacing: 1.3,
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class _ExpertsIllustration extends StatelessWidget {
  const _ExpertsIllustration();

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        Container(
          width: 220,
          height: 220,
          decoration: const BoxDecoration(
            color: Color(0xFFFF9B50),
            shape: BoxShape.circle,
          ),
        ),
        Container(
          width: 176,
          height: 176,
          decoration: const BoxDecoration(
            color: Color(0xFFFFF7F0),
            shape: BoxShape.circle,
          ),
        ),
        const Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            CircleAvatar(
              radius: 42,
              backgroundColor: Color(0xFFFFFFFF),
              child: Icon(
                Icons.medical_services_rounded,
                size: 44,
                color: Color(0xFFFF8A3D),
              ),
            ),
            SizedBox(height: 16),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.pets_rounded,
                  size: 22,
                  color: Color(0xFF6C4020),
                ),
                SizedBox(width: 8),
                Text(
                  'TOP VETS',
                  style: TextStyle(
                    color: Color(0xFF6C4020),
                    fontSize: 17,
                    fontWeight: FontWeight.w800,
                    letterSpacing: 1.1,
                  ),
                ),
              ],
            ),
          ],
        ),
      ],
    );
  }
}

class _BookingIllustration extends StatelessWidget {
  const _BookingIllustration();

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 250,
      height: 210,
      child: Stack(
        alignment: Alignment.center,
        children: [
          Positioned(
            left: 18,
            top: 34,
            child: Container(
              width: 92,
              height: 64,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(18),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.06),
                    blurRadius: 16,
                    offset: const Offset(0, 10),
                  ),
                ],
              ),
              child: const Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.calendar_month_rounded,
                    color: Color(0xFFFF8A3D),
                  ),
                  SizedBox(height: 4),
                  Text(
                    '10:00 AM',
                    style: TextStyle(
                      color: Color(0xFF5B5B5B),
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ),
            ),
          ),
          Positioned(
            right: 22,
            top: 14,
            child: Transform.rotate(
              angle: 0.06,
              child: Container(
                width: 124,
                height: 190,
                decoration: BoxDecoration(
                  color: const Color(0xFFECECEC),
                  borderRadius: BorderRadius.circular(28),
                ),
              ),
            ),
          ),
          Positioned(
            right: 40,
            top: 8,
            child: Container(
              width: 128,
              height: 196,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(30),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.08),
                    blurRadius: 18,
                    offset: const Offset(0, 10),
                  ),
                ],
              ),
              child: Column(
                children: [
                  const SizedBox(height: 16),
                  Container(
                    width: 44,
                    height: 4,
                    decoration: BoxDecoration(
                      color: const Color(0xFFE4E4E4),
                      borderRadius: BorderRadius.circular(999),
                    ),
                  ),
                  const SizedBox(height: 16),
                  ...List.generate(
                    3,
                    (index) => Container(
                      margin: const EdgeInsets.fromLTRB(14, 0, 14, 10),
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: const Color(0xFFFFF3E8),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Row(
                        children: [
                          Container(
                            width: 36,
                            height: 36,
                            decoration: const BoxDecoration(
                              color: Color(0xFFFFA76B),
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(
                              Icons.pets_rounded,
                              color: Colors.white,
                              size: 20,
                            ),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  height: 8,
                                  decoration: BoxDecoration(
                                    color: const Color(0xFFFFC69C),
                                    borderRadius: BorderRadius.circular(999),
                                  ),
                                ),
                                const SizedBox(height: 6),
                                Container(
                                  width: 44,
                                  height: 8,
                                  decoration: BoxDecoration(
                                    color: const Color(0xFFFFE1C8),
                                    borderRadius: BorderRadius.circular(999),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
