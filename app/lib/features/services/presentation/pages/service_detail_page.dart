import 'package:app/app/navigation/booking_navigation.dart';
import 'package:app/app/theme/app_colors.dart';
import 'package:app/features/services/domain/entities/pet_care_service.dart';
import 'package:app/features/services/presentation/bloc/service_detail_bloc.dart';
import 'package:app/features/services/presentation/bloc/service_detail_event.dart';
import 'package:app/features/services/presentation/bloc/service_detail_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ServiceDetailPage extends StatelessWidget {
  const ServiceDetailPage({
    required this.serviceId,
    super.key,
  });

  static const routeName = 'service-detail';
  static const routePath = '/services/:serviceId';

  final String serviceId;

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ServiceDetailBloc, ServiceDetailState>(
      listenWhen: (previous, current) =>
          previous.interaction != current.interaction,
      listener: (context, state) {
        if (state.interaction == ServiceDetailInteraction.bookNow) {
          final service = state.service;
          if (service != null) {
            openBookingPetSelection(context, serviceId: service.id);
          }
        }
      },
      builder: (context, state) {
        if (state.isLoading) {
          return const Scaffold(
            backgroundColor: Colors.white,
            body: Center(
              child: CircularProgressIndicator(color: AppColors.primary),
            ),
          );
        }

        if (state.status == ServiceDetailStatus.failure ||
            state.service == null) {
          return Scaffold(
            backgroundColor: Colors.white,
            appBar: AppBar(backgroundColor: Colors.white),
            body: Center(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Text(
                  state.message ?? 'Không tải được thông tin dịch vụ.',
                  textAlign: TextAlign.center,
                  style: const TextStyle(color: AppColors.mutedText),
                ),
              ),
            ),
          );
        }

        return _ServiceDetailContent(service: state.service!);
      },
    );
  }
}

class _ServiceDetailContent extends StatelessWidget {
  const _ServiceDetailContent({required this.service});

  final PetCareService service;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          CustomScrollView(
            slivers: [
              SliverToBoxAdapter(child: _HeroSection(service: service)),
              SliverPadding(
                padding: const EdgeInsets.fromLTRB(20, 0, 20, 120),
                sliver: SliverList.list(
                  children: [
                    if (service.promoTitle.isNotEmpty) ...[
                      const SizedBox(height: 18),
                      _PromoCard(service: service),
                    ],
                    const SizedBox(height: 24),
                    _ChecklistSection(
                      title: 'Dịch vụ bao gồm',
                      items: service.includedItems,
                      icon: Icons.check_circle_rounded,
                      color: service.promoTone == 'green'
                          ? const Color(0xFF2F9A55)
                          : AppColors.primary,
                    ),
                    const SizedBox(height: 24),
                    _BenefitsSection(items: service.benefits),
                    if (service.noticeText.isNotEmpty) ...[
                      const SizedBox(height: 20),
                      _NoticeCard(text: service.noticeText),
                    ],
                  ],
                ),
              ),
            ],
          ),
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: _BookingBar(service: service),
          ),
        ],
      ),
    );
  }
}

class _HeroSection extends StatelessWidget {
  const _HeroSection({required this.service});

  final PetCareService service;

  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        SizedBox(
          height: 380,
          width: double.infinity,
          child: service.image.startsWith('http')
              ? Image.network(
                  service.image,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) =>
                      const _HeroFallback(),
                )
              : const _HeroFallback(),
        ),
        Positioned(
          top: MediaQuery.paddingOf(context).top + 12,
          left: 16,
          right: 16,
          child: Row(
            children: [
              _RoundIconButton(
                icon: Icons.arrow_back_ios_new_rounded,
                onTap: () => Navigator.of(context).maybePop(),
              ),
              const Spacer(),
              _RoundIconButton(
                icon: Icons.favorite_rounded,
                color: AppColors.primary,
                onTap: () {},
              ),
              const SizedBox(width: 10),
              _RoundIconButton(
                icon: Icons.ios_share_rounded,
                onTap: () {},
              ),
            ],
          ),
        ),
        Container(
          margin: const EdgeInsets.only(top: 280),
          width: double.infinity,
          padding: const EdgeInsets.fromLTRB(22, 58, 22, 22),
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
          ),
          child: Column(
            children: [
              Text(
                service.title,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.w800,
                  color: AppColors.brownText,
                  height: 1.15,
                ),
              ),
              const SizedBox(height: 10),
              Text(
                service.description,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 14,
                  height: 1.45,
                  color: AppColors.brownText.withValues(alpha: 0.72),
                ),
              ),
              const SizedBox(height: 22),
              _ServiceMetaRow(service: service),
            ],
          ),
        ),
        Positioned(
          left: 0,
          right: 0,
          top: 248,
          child: Center(
            child: Container(
              width: 86,
              height: 86,
              decoration: BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.12),
                    blurRadius: 16,
                    offset: const Offset(0, 6),
                  ),
                ],
              ),
              child: Icon(
                _serviceIcon(service),
                color: AppColors.primary,
                size: 38,
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _RoundIconButton extends StatelessWidget {
  const _RoundIconButton({
    required this.icon,
    required this.onTap,
    this.color = AppColors.brownText,
  });

  final IconData icon;
  final VoidCallback onTap;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white,
      shape: const CircleBorder(),
      child: InkWell(
        customBorder: const CircleBorder(),
        onTap: onTap,
        child: SizedBox(
          width: 42,
          height: 42,
          child: Icon(icon, color: color, size: 20),
        ),
      ),
    );
  }
}

class _HeroFallback extends StatelessWidget {
  const _HeroFallback();

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: const BoxDecoration(color: Color(0xFFF7E8DA)),
      child: Center(
        child: Icon(
          Icons.pets_rounded,
          size: 80,
          color: AppColors.brownText.withValues(alpha: 0.25),
        ),
      ),
    );
  }
}

class _ServiceMetaRow extends StatelessWidget {
  const _ServiceMetaRow({required this.service});

  final PetCareService service;

  @override
  Widget build(BuildContext context) {
    final items = [
      _MetaItem(Icons.star_rounded, service.ratingText, const Color(0xFFFFB020)),
      _MetaItem(Icons.people_alt_outlined, service.usageText, AppColors.brownText),
      _MetaItem(Icons.access_time_rounded, service.durationText, AppColors.brownText),
    ].where((item) => item.label.isNotEmpty).toList(growable: false);

    return Wrap(
      alignment: WrapAlignment.center,
      spacing: 16,
      runSpacing: 8,
      children: items
          .map(
            (item) => Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(item.icon, size: 18, color: item.color),
                const SizedBox(width: 5),
                Text(
                  item.label,
                  style: const TextStyle(
                    fontSize: 13,
                    color: AppColors.brownText,
                  ),
                ),
              ],
            ),
          )
          .toList(growable: false),
    );
  }
}

class _MetaItem {
  const _MetaItem(this.icon, this.label, this.color);

  final IconData icon;
  final String label;
  final Color color;
}

class _PromoCard extends StatelessWidget {
  const _PromoCard({required this.service});

  final PetCareService service;

  @override
  Widget build(BuildContext context) {
    final isGreen = service.promoTone == 'green';
    final color = isGreen ? const Color(0xFF2F9A55) : AppColors.primary;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          Icon(Icons.local_offer_outlined, color: color, size: 28),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  service.promoTitle,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w800,
                    color: AppColors.brownText,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  service.promoDescription,
                  style: TextStyle(
                    fontSize: 12,
                    height: 1.4,
                    color: AppColors.brownText.withValues(alpha: 0.72),
                  ),
                ),
              ],
            ),
          ),
          if (service.promoDiscountText.isNotEmpty) ...[
            const SizedBox(width: 12),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
              decoration: BoxDecoration(
                color: color,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                service.promoDiscountText,
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class _ChecklistSection extends StatelessWidget {
  const _ChecklistSection({
    required this.title,
    required this.items,
    required this.icon,
    required this.color,
  });

  final String title;
  final List<String> items;
  final IconData icon;
  final Color color;

  @override
  Widget build(BuildContext context) {
    if (items.isEmpty) {
      return const SizedBox.shrink();
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w800,
            color: AppColors.brownText,
          ),
        ),
        const SizedBox(height: 14),
        ...items.map(
          (item) => Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(icon, size: 18, color: color),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    item,
                    style: TextStyle(
                      fontSize: 13,
                      height: 1.45,
                      color: AppColors.brownText.withValues(alpha: 0.78),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class _BenefitsSection extends StatelessWidget {
  const _BenefitsSection({required this.items});

  final List<String> items;

  @override
  Widget build(BuildContext context) {
    if (items.isEmpty) {
      return const SizedBox.shrink();
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Lợi ích cho bé cưng',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w800,
            color: AppColors.brownText,
          ),
        ),
        const SizedBox(height: 14),
        ...items.map(
          (item) => Container(
            width: double.infinity,
            margin: const EdgeInsets.only(bottom: 10),
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: AppColors.primary.withValues(alpha: 0.06),
              borderRadius: BorderRadius.circular(14),
            ),
            child: Row(
              children: [
                const Icon(
                  Icons.favorite_border_rounded,
                  size: 20,
                  color: AppColors.primary,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    item,
                    style: const TextStyle(
                      fontSize: 13,
                      height: 1.35,
                      color: AppColors.brownText,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class _NoticeCard extends StatelessWidget {
  const _NoticeCard({required this.text});

  final String text;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.primary.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(14),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(
            Icons.info_outline_rounded,
            size: 20,
            color: AppColors.primary,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              text,
              style: TextStyle(
                fontSize: 13,
                height: 1.45,
                color: AppColors.brownText.withValues(alpha: 0.75),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _BookingBar extends StatelessWidget {
  const _BookingBar({required this.service});

  final PetCareService service;

  @override
  Widget build(BuildContext context) {
    final bottomPadding = MediaQuery.paddingOf(context).bottom;
    return Container(
      padding: EdgeInsets.fromLTRB(20, 12, 20, 12 + bottomPadding),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(
          top: BorderSide(color: AppColors.divider.withValues(alpha: 0.8)),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.06),
            blurRadius: 16,
            offset: const Offset(0, -6),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'Giá từ',
                  style: TextStyle(
                    fontSize: 12,
                    color: AppColors.brownText.withValues(alpha: 0.65),
                  ),
                ),
                Text(
                  service.priceText.replaceFirst('Từ ', ''),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w800,
                    color: AppColors.primary,
                  ),
                ),
              ],
            ),
          ),
          FilledButton.icon(
            onPressed: () => context
                .read<ServiceDetailBloc>()
                .add(const ServiceDetailBookNowPressed()),
            style: FilledButton.styleFrom(
              backgroundColor: AppColors.primary,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(28),
              ),
              elevation: 0,
            ),
            icon: const Text(
              'Đặt lịch ngay',
              style: TextStyle(fontWeight: FontWeight.w800),
            ),
            label: const Icon(Icons.arrow_forward_rounded, size: 20),
          ),
        ],
      ),
    );
  }
}

IconData _serviceIcon(PetCareService service) {
  final value = '${service.icon} ${service.slug} ${service.title}'.toLowerCase();
  if (value.contains('hotel')) {
    return Icons.holiday_village_outlined;
  }
  if (value.contains('medical') ||
      value.contains('vet') ||
      value.contains('bác') ||
      value.contains('thú y')) {
    return Icons.medical_services_outlined;
  }
  return Icons.content_cut_rounded;
}
