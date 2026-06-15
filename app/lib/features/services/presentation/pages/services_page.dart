import 'package:app/app/navigation/booking_navigation.dart';
import 'package:app/app/theme/app_colors.dart';
import 'package:app/features/services/domain/entities/pet_care_service.dart';
import 'package:app/features/services/domain/entities/service_category_filter.dart';
import 'package:app/features/services/domain/entities/services_page_content.dart';
import 'package:app/features/services/presentation/bloc/services_bloc.dart';
import 'package:app/features/services/presentation/bloc/services_event.dart';
import 'package:app/features/services/presentation/bloc/services_state.dart';
import 'package:app/features/services/presentation/mappers/services_ui_mapper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ServicesPage extends StatelessWidget {
  const ServicesPage({super.key});

  static const _categories = ServiceCategoryFilter.values;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ServicesBloc, ServicesState>(
      builder: (context, state) {
        if (state.status == ServicesStatus.failure) {
          return _ServicesErrorView(
            message: state.message ?? 'Không tải được danh sách dịch vụ.',
            onRetry: () => context
                .read<ServicesBloc>()
                .add(const ServicesRefreshRequested()),
          );
        }

        if (state.isLoading || state.content == null) {
          return const Center(
            child: CircularProgressIndicator(color: AppColors.primary),
          );
        }

        return _ServicesContent(
          content: state.content!,
          selectedCategory: state.selectedCategory,
          services: state.visibleServices,
        );
      },
    );
  }
}

class _ServicesErrorView extends StatelessWidget {
  const _ServicesErrorView({
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

class _ServicesContent extends StatelessWidget {
  const _ServicesContent({
    required this.content,
    required this.selectedCategory,
    required this.services,
  });

  final ServicesPageContent content;
  final ServiceCategoryFilter selectedCategory;
  final List<PetCareService> services;

  @override
  Widget build(BuildContext context) {
    final bloc = context.read<ServicesBloc>();

    return RefreshIndicator(
      color: AppColors.primary,
      onRefresh: () async {
        bloc.add(const ServicesRefreshRequested());
        await bloc.stream.firstWhere(
          (state) =>
              state.status == ServicesStatus.success ||
              state.status == ServicesStatus.failure,
        );
      },
      child: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(
            child: _ServicesAppBar(
              onNotificationsPressed: () =>
                  bloc.add(const ServicesNotificationsPressed()),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 4, 16, 0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    content.title,
                    style: const TextStyle(
                      fontSize: 26,
                      fontWeight: FontWeight.w800,
                      color: AppColors.brownText,
                      height: 1.15,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    ServicesUiMapper.subtitle(selectedCategory),
                    style: TextStyle(
                      fontSize: 14,
                      height: 1.4,
                      color: AppColors.brownText.withValues(alpha: 0.65),
                    ),
                  ),
                  const SizedBox(height: 20),
                  _CategoryFilterRow(
                    selectedCategory: selectedCategory,
                    onCategorySelected: (category) => bloc.add(
                      ServicesCategoryFilterChanged(category),
                    ),
                  ),
                  const SizedBox(height: 20),
                ],
              ),
            ),
          ),
          if (services.isEmpty)
            const SliverFillRemaining(
              hasScrollBody: false,
              child: Center(
                child: Text(
                  'Chưa có dịch vụ phù hợp với bộ lọc này.',
                  style: TextStyle(color: AppColors.mutedText),
                ),
              ),
            )
          else
            SliverPadding(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 24),
              sliver: SliverList.separated(
                itemCount: services.length,
                separatorBuilder: (context, _) => const SizedBox(height: 16),
                itemBuilder: (context, index) {
                  final service = services[index];
                  return _ServiceCard(
                    service: service,
                    onBookNow: () {
                      bloc.add(ServiceBookNowPressed(service.id));
                      openBookingPetSelection(
                        context,
                        serviceId: service.id,
                      );
                    },
                  );
                },
              ),
            ),
        ],
      ),
    );
  }
}

class _ServicesAppBar extends StatelessWidget {
  const _ServicesAppBar({required this.onNotificationsPressed});

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

class _CategoryFilterRow extends StatelessWidget {
  const _CategoryFilterRow({
    required this.selectedCategory,
    required this.onCategorySelected,
  });

  final ServiceCategoryFilter selectedCategory;
  final ValueChanged<ServiceCategoryFilter> onCategorySelected;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 44,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: ServicesPage._categories.length,
        separatorBuilder: (context, _) => const SizedBox(width: 10),
        itemBuilder: (context, index) {
          final category = ServicesPage._categories[index];
          final isSelected = category == selectedCategory;

          return GestureDetector(
            onTap: () => onCategorySelected(category),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              padding: const EdgeInsets.symmetric(horizontal: 16),
              decoration: BoxDecoration(
                color: isSelected ? AppColors.primary : AppColors.cardBg,
                borderRadius: BorderRadius.circular(22),
                border: Border.all(
                  color: isSelected
                      ? AppColors.primary
                      : AppColors.divider,
                ),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  DefaultTextStyle(
                    style: TextStyle(
                      color: isSelected ? Colors.white : AppColors.brownText,
                    ),
                    child: ServicesUiMapper.categoryLeading(category),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    ServicesUiMapper.categoryLabel(category),
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: isSelected ? Colors.white : AppColors.brownText,
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

class _ServiceCard extends StatelessWidget {
  const _ServiceCard({
    required this.service,
    required this.onBookNow,
  });

  final PetCareService service;
  final VoidCallback onBookNow;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.cardBg,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      clipBehavior: Clip.antiAlias,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            height: 160,
            width: double.infinity,
            color: const Color(0xFFF7E8DA),
            child: service.image.startsWith('http')
                ? Image.network(
                    service.image,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) =>
                        _ServiceImageFallback(service: service),
                  )
                : _ServiceImageFallback(service: service),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 14, 16, 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Text(
                        service.title,
                        style: const TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.w700,
                          color: AppColors.brownText,
                        ),
                      ),
                    ),
                    if (service.badge.isNotEmpty) ...[
                      const SizedBox(width: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: const Color(0xFFE3F2FD),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          service.badge,
                          style: const TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.w700,
                            color: Color(0xFF1976D2),
                            letterSpacing: 0.4,
                          ),
                        ),
                      ),
                    ],
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  service.description,
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 13,
                    height: 1.45,
                    color: AppColors.brownText.withValues(alpha: 0.6),
                  ),
                ),
                const SizedBox(height: 14),
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        service.priceText,
                        style: const TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w700,
                          color: AppColors.brownText,
                        ),
                      ),
                    ),
                    FilledButton(
                      onPressed: onBookNow,
                      style: FilledButton.styleFrom(
                        backgroundColor: AppColors.brown,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 20,
                          vertical: 10,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(22),
                        ),
                        elevation: 0,
                      ),
                      child: const Text(
                        'Đặt ngay',
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _ServiceImageFallback extends StatelessWidget {
  const _ServiceImageFallback({required this.service});

  final PetCareService service;

  @override
  Widget build(BuildContext context) {
    final icon = service.category == ServiceCategoryFilter.cat
        ? Icons.cruelty_free_rounded
        : Icons.pets_rounded;

    return DecoratedBox(
      decoration: const BoxDecoration(
        color: Color(0xFFF7E8DA),
      ),
      child: Center(
        child: Icon(
          icon,
          size: 54,
          color: AppColors.brownText.withValues(alpha: 0.28),
        ),
      ),
    );
  }
}
