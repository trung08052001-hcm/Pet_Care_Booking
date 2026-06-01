import 'package:app/app/shell/main_shell_page.dart';
import 'package:app/app/theme/app_colors.dart';
import 'package:app/features/booking/domain/entities/bookable_service_icon.dart';
import 'package:app/features/booking/domain/entities/booking_detail.dart';
import 'package:app/features/booking/domain/entities/booking_detail_service_item.dart';
import 'package:app/features/booking/domain/entities/booking_detail_status.dart';
import 'package:app/features/booking/presentation/bloc/booking_detail_bloc.dart';
import 'package:app/features/booking/presentation/bloc/booking_detail_event.dart';
import 'package:app/features/booking/presentation/bloc/booking_detail_state.dart';
import 'package:app/features/booking/presentation/mappers/booking_service_ui_mapper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class BookingDetailPage extends StatelessWidget {
  const BookingDetailPage({super.key, required this.bookingId});

  final String bookingId;

  static const routeName = 'booking-detail';
  static const routePath = '/booking/detail/:bookingId';

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<BookingDetailBloc, BookingDetailState>(
      listenWhen: (previous, current) =>
          previous.showCancelSuccess != current.showCancelSuccess ||
          previous.showSupportSnack != current.showSupportSnack ||
          previous.showShareSnack != current.showShareSnack,
      listener: (context, state) {
        if (state.showCancelSuccess) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Đã hủy lịch hẹn thành công.')),
          );
        }
        if (state.showSupportSnack) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Đang chuyển tới hỗ trợ — đang phát triển.'),
            ),
          );
        }
        if (state.showShareSnack) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Chia sẻ lịch hẹn — đang phát triển.')),
          );
        }
      },
      builder: (context, state) {
        return Scaffold(
          backgroundColor: const Color(0xFFF3FAFC),
          body: SafeArea(
            child: Column(
              children: [
                _BookingDetailTopBar(
                  onBack: () {
                    if (context.canPop()) {
                      context.pop();
                    } else {
                      context.goNamed(MainShellPage.routeName);
                    }
                  },
                  onShare: () => context
                      .read<BookingDetailBloc>()
                      .add(const BookingDetailSharePressed()),
                ),
                if (state.isLoading)
                  const Expanded(
                    child: Center(
                      child: CircularProgressIndicator(color: AppColors.primary),
                    ),
                  )
                else if (state.status == BookingDetailPageStatus.failure)
                  Expanded(
                    child: Center(
                      child: Padding(
                        padding: const EdgeInsets.all(24),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              state.message ?? 'Không tải được chi tiết lịch.',
                              textAlign: TextAlign.center,
                              style: const TextStyle(color: AppColors.mutedText),
                            ),
                            const SizedBox(height: 16),
                            FilledButton(
                              onPressed: () => context
                                  .read<BookingDetailBloc>()
                                  .add(BookingDetailStarted(bookingId)),
                              child: const Text('Thử lại'),
                            ),
                          ],
                        ),
                      ),
                    ),
                  )
                else if (state.detail != null)
                  Expanded(
                    child: _BookingDetailBody(
                      detail: state.detail!,
                      isCancelling: state.isCancelling,
                      onCancel: () => _confirmCancel(context),
                      onSupport: () => context
                          .read<BookingDetailBloc>()
                          .add(const BookingDetailSupportPressed()),
                    ),
                  ),
              ],
            ),
          ),
        );
      },
    );
  }

  Future<void> _confirmCancel(BuildContext context) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Hủy lịch hẹn'),
        content: const Text(
          'Bạn có chắc muốn hủy lịch hẹn này? Hủy miễn phí trước 2 tiếng.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(false),
            child: const Text('Không'),
          ),
          FilledButton(
            onPressed: () => Navigator.of(dialogContext).pop(true),
            child: const Text('Hủy lịch'),
          ),
        ],
      ),
    );

    if (confirmed == true && context.mounted) {
      context
          .read<BookingDetailBloc>()
          .add(const BookingDetailCancelPressed());
    }
  }
}

class _BookingDetailTopBar extends StatelessWidget {
  const _BookingDetailTopBar({required this.onBack, required this.onShare});

  final VoidCallback onBack;
  final VoidCallback onShare;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(4, 8, 8, 4),
      child: Row(
        children: [
          IconButton(
            onPressed: onBack,
            icon: const Icon(Icons.arrow_back_rounded, color: AppColors.brown),
          ),
          const Expanded(
            child: Text(
              'Chi tiết lịch hẹn',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w700,
                color: AppColors.brown,
              ),
            ),
          ),
          IconButton(
            onPressed: onShare,
            icon: const Icon(Icons.ios_share_rounded, color: AppColors.brown),
          ),
        ],
      ),
    );
  }
}

class _BookingDetailBody extends StatelessWidget {
  const _BookingDetailBody({
    required this.detail,
    required this.isCancelling,
    required this.onCancel,
    required this.onSupport,
  });

  final BookingDetail detail;
  final bool isCancelling;
  final VoidCallback onCancel;
  final VoidCallback onSupport;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: ListView(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
            children: [
              _BookingCodeRow(detail: detail),
              const SizedBox(height: 16),
              _PetInfoCard(detail: detail),
              const SizedBox(height: 20),
              const Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'DỊCH VỤ ĐÃ CHỌN',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w800,
                    letterSpacing: 0.8,
                    color: AppColors.mutedText,
                  ),
                ),
              ),
              const SizedBox(height: 10),
              ...detail.services.map(
                (service) => Padding(
                  padding: const EdgeInsets.only(bottom: 10),
                  child: _ServiceRowCard(service: service),
                ),
              ),
              const SizedBox(height: 8),
              _ScheduleLocationCard(detail: detail),
              const SizedBox(height: 20),
              _PaymentSummaryCard(detail: detail),
            ],
          ),
        ),
        _ActionButtons(
          canCancel: detail.status == BookingDetailStatus.upcoming,
          isCancelling: isCancelling,
          onCancel: onCancel,
          onSupport: onSupport,
        ),
      ],
    );
  }
}

class _BookingCodeRow extends StatelessWidget {
  const _BookingCodeRow({required this.detail});

  final BookingDetail detail;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Mã đặt lịch',
                style: TextStyle(
                  fontSize: 12,
                  color: AppColors.brownText.withValues(alpha: 0.55),
                ),
              ),
              const SizedBox(height: 4),
              Text(
                detail.displayCode,
                style: const TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.w800,
                  color: AppColors.brownText,
                ),
              ),
            ],
          ),
        ),
        _StatusBadge(
          label: detail.statusLabel,
          status: detail.status,
        ),
      ],
    );
  }
}

class _StatusBadge extends StatelessWidget {
  const _StatusBadge({required this.label, required this.status});

  final String label;
  final BookingDetailStatus status;

  @override
  Widget build(BuildContext context) {
    final color = switch (status) {
      BookingDetailStatus.upcoming => AppColors.primary,
      BookingDetailStatus.completed => const Color(0xFF2E9E5B),
      BookingDetailStatus.cancelled => AppColors.mutedText,
    };

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 8,
            height: 8,
            decoration: BoxDecoration(color: color, shape: BoxShape.circle),
          ),
          const SizedBox(width: 6),
          Text(
            label,
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w700,
              color: color,
            ),
          ),
        ],
      ),
    );
  }
}

class _PetInfoCard extends StatelessWidget {
  const _PetInfoCard({required this.detail});

  final BookingDetail detail;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.cardBg,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: 28,
            backgroundColor: Color(detail.petImagePlaceholderColor),
            child: Text(
              detail.petName.isNotEmpty ? detail.petName[0] : '?',
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w800,
                color: AppColors.brownText,
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  detail.petName,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w800,
                    color: AppColors.brownText,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  detail.petSubtitle,
                  style: TextStyle(
                    fontSize: 13,
                    color: AppColors.brownText.withValues(alpha: 0.6),
                  ),
                ),
              ],
            ),
          ),
          Icon(
            Icons.pets_rounded,
            color: AppColors.primary.withValues(alpha: 0.7),
            size: 22,
          ),
        ],
      ),
    );
  }
}

class _ServiceRowCard extends StatelessWidget {
  const _ServiceRowCard({required this.service});

  final BookingDetailServiceItem service;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.cardBg,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Row(
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: Color(service.iconBackgroundColor),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              _iconFor(service.icon),
              color: AppColors.primary,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              service.title,
              style: const TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w600,
                color: AppColors.brownText,
              ),
            ),
          ),
          Text(
            BookingServiceUiMapper.formatPrice(service.priceVnd),
            style: const TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w700,
              color: AppColors.brownText,
            ),
          ),
        ],
      ),
    );
  }

  IconData _iconFor(BookableServiceIcon icon) {
    return switch (icon) {
      BookableServiceIcon.spa => Icons.bathtub_outlined,
      BookableServiceIcon.boarding => Icons.hotel_rounded,
      BookableServiceIcon.healthCheck => Icons.health_and_safety_outlined,
      BookableServiceIcon.walking => Icons.directions_walk_rounded,
    };
  }
}

class _ScheduleLocationCard extends StatelessWidget {
  const _ScheduleLocationCard({required this.detail});

  final BookingDetail detail;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFE8F4F8),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _ScheduleRow(
            icon: Icons.calendar_today_outlined,
            label: 'Ngày & Giờ',
            value: detail.dateLabel,
            subValue: detail.timeLabel,
          ),
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 14),
            child: Divider(height: 1, color: Color(0xFFD0E4EA)),
          ),
          _ScheduleRow(
            icon: Icons.location_on_outlined,
            label: 'Địa điểm',
            value: detail.locationName,
            subValue: detail.locationAddress,
          ),
          const SizedBox(height: 14),
          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: Container(
              height: 100,
              width: double.infinity,
              color: const Color(0xFFD4E8EE),
              child: Stack(
                alignment: Alignment.center,
                children: [
                  Icon(
                    Icons.map_outlined,
                    size: 48,
                    color: AppColors.brownText.withValues(alpha: 0.2),
                  ),
                  Icon(
                    Icons.location_on,
                    color: AppColors.primary.withValues(alpha: 0.85),
                    size: 32,
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

class _ScheduleRow extends StatelessWidget {
  const _ScheduleRow({
    required this.icon,
    required this.label,
    required this.value,
    required this.subValue,
  });

  final IconData icon;
  final String label;
  final String value;
  final String subValue;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: 20, color: AppColors.primary),
        const SizedBox(width: 10),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: TextStyle(
                  fontSize: 12,
                  color: AppColors.brownText.withValues(alpha: 0.5),
                ),
              ),
              const SizedBox(height: 4),
              Text(
                value,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                  color: AppColors.brownText,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                subValue,
                style: TextStyle(
                  fontSize: 13,
                  color: AppColors.brownText.withValues(alpha: 0.65),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _PaymentSummaryCard extends StatelessWidget {
  const _PaymentSummaryCard({required this.detail});

  final BookingDetail detail;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.heroBg.withValues(alpha: 0.5),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Tóm tắt thanh toán',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w800,
              color: AppColors.brownText,
            ),
          ),
          const SizedBox(height: 14),
          _PaymentLine(
            label: 'Tạm tính',
            value: BookingServiceUiMapper.formatPrice(detail.subtotalVnd),
          ),
          const SizedBox(height: 8),
          _PaymentLine(
            label: detail.discountLabel,
            value: detail.discountVnd > 0
                ? '-${BookingServiceUiMapper.formatPrice(detail.discountVnd)}'
                : BookingServiceUiMapper.formatPrice(0),
            muted: true,
          ),
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 12),
            child: Divider(height: 1),
          ),
          Row(
            children: [
              const Expanded(
                child: Text(
                  'Tổng cộng',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w800,
                    color: AppColors.brownText,
                  ),
                ),
              ),
              Text(
                BookingServiceUiMapper.formatPrice(detail.totalVnd),
                style: const TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.w800,
                  color: AppColors.primary,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              const Icon(
                Icons.check_circle_rounded,
                color: Color(0xFF2E9E5B),
                size: 20,
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  detail.paymentStatusLabel,
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: AppColors.brownText.withValues(alpha: 0.7),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _PaymentLine extends StatelessWidget {
  const _PaymentLine({
    required this.label,
    required this.value,
    this.muted = false,
  });

  final String label;
  final String value;
  final bool muted;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Text(
            label,
            style: TextStyle(
              fontSize: 14,
              color: muted ? AppColors.mutedText : AppColors.brownText,
            ),
          ),
        ),
        Text(
          value,
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: muted ? AppColors.mutedText : AppColors.brownText,
          ),
        ),
      ],
    );
  }
}

class _ActionButtons extends StatelessWidget {
  const _ActionButtons({
    required this.canCancel,
    required this.isCancelling,
    required this.onCancel,
    required this.onSupport,
  });

  final bool canCancel;
  final bool isCancelling;
  final VoidCallback onCancel;
  final VoidCallback onSupport;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
      decoration: BoxDecoration(
        color: AppColors.cardBg,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.06),
            blurRadius: 12,
            offset: const Offset(0, -4),
          ),
        ],
      ),
      child: SafeArea(
        top: false,
        child: Row(
          children: [
            Expanded(
              child: OutlinedButton.icon(
                onPressed: canCancel && !isCancelling ? onCancel : null,
                icon: isCancelling
                    ? const SizedBox(
                        width: 18,
                        height: 18,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : const Icon(Icons.close_rounded),
                label: const Text('Hủy lịch'),
                style: OutlinedButton.styleFrom(
                  foregroundColor: AppColors.brown,
                  side: const BorderSide(color: AppColors.brown),
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(28),
                  ),
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: FilledButton.icon(
                onPressed: onSupport,
                icon: const Icon(Icons.headset_mic_outlined),
                label: const Text('Hỗ trợ'),
                style: FilledButton.styleFrom(
                  backgroundColor: AppColors.brown,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(28),
                  ),
                  elevation: 0,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
