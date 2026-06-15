import 'package:app/app/navigation/booking_navigation.dart';
import 'package:app/app/theme/app_colors.dart';
import 'package:app/features/home/domain/entities/home_dashboard.dart';
import 'package:app/features/home/domain/entities/home_featured_service.dart';
import 'package:app/features/home/domain/entities/home_pet_tip.dart';
import 'package:app/features/home/domain/entities/home_promo.dart';
import 'package:app/features/home/domain/entities/home_welcome.dart';
import 'package:app/features/home/presentation/bloc/home_bloc.dart';
import 'package:app/features/home/presentation/bloc/home_event.dart';
import 'package:app/features/home/presentation/bloc/home_state.dart';
import 'package:app/features/home/presentation/mappers/home_ui_mapper.dart';
import 'package:app/features/services/presentation/pages/service_detail_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<HomeBloc, HomeState>(
      listenWhen: (previous, current) =>
          previous.interaction != current.interaction ||
          previous.selectedServiceId != current.selectedServiceId,
      listener: (context, state) {
        if (state.interaction == HomeInteraction.featuredService &&
            state.selectedServiceId != null) {
          context.pushNamed(
            ServiceDetailPage.routeName,
            pathParameters: {'serviceId': state.selectedServiceId!},
          );
        }
      },
      builder: (context, state) {
        if (state.status == HomeStatus.failure) {
          return _HomeErrorView(
            message: state.message ?? 'Không tải được trang chủ.',
            onRetry: () =>
                context.read<HomeBloc>().add(const HomeRefreshRequested()),
          );
        }

        if (state.isLoading || state.dashboard == null) {
          return const Center(
            child: CircularProgressIndicator(color: AppColors.primary),
          );
        }

        return _HomeContent(dashboard: state.dashboard!);
      },
    );
  }
}

class _HomeErrorView extends StatelessWidget {
  const _HomeErrorView({
    required this.message,
    required this.onRetry,
  });

  final String message;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              message,
              textAlign: TextAlign.center,
              style: const TextStyle(color: AppColors.mutedText),
            ),
            const SizedBox(height: 16),
            FilledButton(
              onPressed: onRetry,
              child: const Text('Thử lại'),
            ),
          ],
        ),
      ),
    );
  }
}

class _HomeContent extends StatelessWidget {
  const _HomeContent({required this.dashboard});

  final HomeDashboard dashboard;

  @override
  Widget build(BuildContext context) {
    final bloc = context.read<HomeBloc>();

    return RefreshIndicator(
      color: AppColors.primary,
      onRefresh: () async {
        bloc.add(const HomeRefreshRequested());
        await bloc.stream.firstWhere(
          (state) =>
              state.status == HomeStatus.success ||
              state.status == HomeStatus.failure,
        );
      },
      child: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(
            child: _HomeAppBar(
              onNotificationsPressed: () =>
                  bloc.add(const HomeNotificationsPressed()),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _WelcomeBanner(
                    welcome: dashboard.welcome,
                    onBookNow: () {
                      bloc.add(const HomeBookNowPressed());
                      openBookingPetSelection(context);
                    },
                  ),
                  const SizedBox(height: 24),
                  _SectionHeader(
                    title: dashboard.featuredServicesSectionTitle,
                    actionLabel: '',
                    onActionTap: null,
                  ),
                  const SizedBox(height: 12),
                  _FeaturedServicesRow(
                    services: dashboard.featuredServices,
                    onServiceTap: (id) =>
                        bloc.add(HomeFeaturedServicePressed(id)),
                  ),
                  const SizedBox(height: 24),
                  _PromoCard(
                    promo: dashboard.promo,
                    onClaim: () => bloc.add(const HomePromoClaimPressed()),
                  ),
                  const SizedBox(height: 24),
                  _SectionHeader(
                    title: dashboard.petTipsSectionTitle,
                    actionLabel: 'Xem thêm',
                    onActionTap: () =>
                        bloc.add(const HomePetTipsSeeAllPressed()),
                  ),
                  const SizedBox(height: 12),
                  _PetTipsRow(
                    tips: dashboard.petTips,
                    onTipTap: (id) => bloc.add(HomePetTipPressed(id)),
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

class _HomeAppBar extends StatelessWidget {
  const _HomeAppBar({required this.onNotificationsPressed});

  final VoidCallback onNotificationsPressed;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      bottom: false,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 8, 8, 4),
        child: Row(
          children: [
            Container(
              width: 32,
              height: 32,
              decoration: BoxDecoration(
                color: AppColors.primary.withValues(alpha: 0.15),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.pets_rounded,
                size: 18,
                color: AppColors.primary,
              ),
            ),
            const SizedBox(width: 8),
            const Text(
              'PawSitive Care',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w700,
                color: AppColors.brown,
                letterSpacing: -0.3,
              ),
            ),
            const Spacer(),
            IconButton(
              onPressed: onNotificationsPressed,
              icon: const Icon(
                Icons.notifications_none_rounded,
                color: AppColors.brownText,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _WelcomeBanner extends StatelessWidget {
  const _WelcomeBanner({
    required this.welcome,
    required this.onBookNow,
  });

  final HomeWelcome welcome;
  final VoidCallback onBookNow;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 168,
      decoration: BoxDecoration(
        color: AppColors.heroBg,
        borderRadius: BorderRadius.circular(20),
      ),
      clipBehavior: Clip.antiAlias,
      child: Stack(
        children: [
          Positioned(
            left: 20,
            top: 20,
            right: 120,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  welcome.greeting,
                  style: TextStyle(
                    fontSize: 13,
                    color: AppColors.brownText.withValues(alpha: 0.75),
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  welcome.title,
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w800,
                    height: 1.2,
                    color: AppColors.brownText,
                  ),
                ),
                const SizedBox(height: 14),
                FilledButton(
                  onPressed: onBookNow,
                  style: FilledButton.styleFrom(
                    backgroundColor: AppColors.brown,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 18,
                      vertical: 10,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(24),
                    ),
                    elevation: 0,
                  ),
                  child: Text(
                    welcome.bookCtaLabel,
                    style: const TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
          ),
          Positioned(
            right: -8,
            bottom: -4,
            child: Container(
              width: 130,
              height: 130,
              decoration: BoxDecoration(
                color: AppColors.primary.withValues(alpha: 0.12),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.pets,
                size: 72,
                color: AppColors.primary,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  const _SectionHeader({
    required this.title,
    required this.actionLabel,
    required this.onActionTap,
  });

  final String title;
  final String actionLabel;
  final VoidCallback? onActionTap;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Text(
            title,
            style: const TextStyle(
              fontSize: 17,
              fontWeight: FontWeight.w700,
              color: AppColors.brownText,
            ),
          ),
        ),
        if (actionLabel.isNotEmpty && onActionTap != null)
          TextButton(
            onPressed: onActionTap,
            style: TextButton.styleFrom(
              foregroundColor: AppColors.primary,
              padding: const EdgeInsets.symmetric(horizontal: 8),
              minimumSize: Size.zero,
              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
            ),
            child: Text(
              actionLabel,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
      ],
    );
  }
}

class _FeaturedServicesRow extends StatelessWidget {
  const _FeaturedServicesRow({
    required this.services,
    required this.onServiceTap,
  });

  final List<HomeFeaturedService> services;
  final ValueChanged<String> onServiceTap;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 108,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: services.length,
        separatorBuilder: (context, _) => const SizedBox(width: 12),
        itemBuilder: (context, index) {
          final service = services[index];
          return GestureDetector(
            onTap: () => onServiceTap(service.id),
            child: Container(
              width: 108,
              padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 12),
              decoration: BoxDecoration(
                color: AppColors.cardBg,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.05),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    HomeUiMapper.featuredServiceIcon(service.type),
                    size: 28,
                    color: AppColors.primary,
                  ),
                  const SizedBox(height: 10),
                  Text(
                    service.label,
                    textAlign: TextAlign.center,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: AppColors.brownText,
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

class _PromoCard extends StatelessWidget {
  const _PromoCard({
    required this.promo,
    required this.onClaim,
  });

  final HomePromo promo;
  final VoidCallback onClaim;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 140,
      decoration: BoxDecoration(
        color: AppColors.primary,
        borderRadius: BorderRadius.circular(20),
      ),
      clipBehavior: Clip.antiAlias,
      child: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.all(18),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.25),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    promo.badgeLabel,
                    style: const TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.w700,
                      color: Colors.white,
                      letterSpacing: 0.5,
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  promo.title,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w800,
                    height: 1.25,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  promo.subtitle,
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.white.withValues(alpha: 0.9),
                  ),
                ),
                const Spacer(),
                FilledButton(
                  onPressed: onClaim,
                  style: FilledButton.styleFrom(
                    backgroundColor: AppColors.brown,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 8,
                    ),
                    minimumSize: Size.zero,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    elevation: 0,
                  ),
                  child: Text(
                    promo.ctaLabel,
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
          ),
          Positioned(
            right: 16,
            bottom: 16,
            child: Container(
              width: 72,
              height: 72,
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.2),
                borderRadius: BorderRadius.circular(14),
              ),
              child: const Icon(
                Icons.pets,
                size: 40,
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _PetTipsRow extends StatelessWidget {
  const _PetTipsRow({
    required this.tips,
    required this.onTipTap,
  });

  final List<HomePetTip> tips;
  final ValueChanged<String> onTipTap;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 220,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: tips.length,
        separatorBuilder: (context, _) => const SizedBox(width: 14),
        itemBuilder: (context, index) {
          final tip = tips[index];
          return GestureDetector(
            onTap: () => onTipTap(tip.id),
            child: SizedBox(
              width: 200,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    height: 120,
                    decoration: BoxDecoration(
                      color: HomeUiMapper.tipPlaceholderColor(
                        tip.imagePlaceholderColor,
                      ),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Center(
                      child: Icon(
                        Icons.image_outlined,
                        size: 40,
                        color: AppColors.brownText.withValues(alpha: 0.35),
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    tip.category,
                    style: const TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w700,
                      color: AppColors.primary,
                      letterSpacing: 0.6,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    tip.title,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                      height: 1.3,
                      color: AppColors.brownText,
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
