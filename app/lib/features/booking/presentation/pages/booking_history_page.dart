import 'package:app/app/navigation/booking_navigation.dart';
import 'package:app/app/theme/app_colors.dart';
import 'package:app/core/di/injection.dart';
import 'package:app/core/network/api_service.dart';
import 'package:app/features/booking/data/models/booking_api_models.dart';
import 'package:flutter/material.dart';

class BookingHistoryPage extends StatefulWidget {
  const BookingHistoryPage({super.key});

  static const routePath = '/booking/history';
  static const routeName = 'booking-history';

  @override
  State<BookingHistoryPage> createState() => _BookingHistoryPageState();
}

class _BookingHistoryPageState extends State<BookingHistoryPage> {
  late Future<BookingsApiResponseModel> _future;

  @override
  void initState() {
    super.initState();
    _future = _loadBookings();
  }

  Future<BookingsApiResponseModel> _loadBookings() {
    return getIt<AppApiService>().getBookings();
  }

  void _refresh() {
    setState(() {
      _future = _loadBookings();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.scaffoldBg,
      appBar: AppBar(
        title: const Text('Lịch sử đặt chỗ'),
        backgroundColor: AppColors.scaffoldBg,
        foregroundColor: AppColors.brownText,
        elevation: 0,
      ),
      body: FutureBuilder<BookingsApiResponseModel>(
        future: _future,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(color: AppColors.primary),
            );
          }

          if (snapshot.hasError) {
            return _BookingHistoryMessage(
              title: 'Không tải được lịch sử đặt chỗ',
              actionLabel: 'Thử lại',
              onAction: _refresh,
            );
          }

          final bookings = snapshot.data?.bookings ?? const <BookingModel>[];
          if (bookings.isEmpty) {
            return _BookingHistoryMessage(
              title: 'Bạn chưa có lịch đặt nào',
              actionLabel: 'Tải lại',
              onAction: _refresh,
            );
          }

          return RefreshIndicator(
            color: AppColors.primary,
            onRefresh: () async => _refresh(),
            child: ListView.separated(
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
              itemBuilder: (context, index) {
                final booking = bookings[index];
                return _BookingHistoryTile(
                  booking: booking,
                  onTap: () => openBookingDetail(context, bookingId: booking.id),
                );
              },
              separatorBuilder: (_, __) => const SizedBox(height: 12),
              itemCount: bookings.length,
            ),
          );
        },
      ),
    );
  }
}

class _BookingHistoryMessage extends StatelessWidget {
  const _BookingHistoryMessage({
    required this.title,
    required this.actionLabel,
    required this.onAction,
  });

  final String title;
  final String actionLabel;
  final VoidCallback onAction;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              title,
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: AppColors.brownText,
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 14),
            FilledButton(
              onPressed: onAction,
              style: FilledButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: Colors.white,
              ),
              child: Text(actionLabel),
            ),
          ],
        ),
      ),
    );
  }
}

class _BookingHistoryTile extends StatelessWidget {
  const _BookingHistoryTile({
    required this.booking,
    required this.onTap,
  });

  final BookingModel booking;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final status = _statusLabel(booking.status);
    final statusColor = _statusColor(booking.status);

    return Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(8),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(8),
        child: Padding(
          padding: const EdgeInsets.all(14),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(
                      booking.displayCode.isEmpty
                          ? '#${booking.id}'
                          : booking.displayCode,
                      style: const TextStyle(
                        color: AppColors.brownText,
                        fontSize: 15,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                  DecoratedBox(
                    decoration: BoxDecoration(
                      color: statusColor.withValues(alpha: 0.12),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      child: Text(
                        status,
                        style: TextStyle(
                          color: statusColor,
                          fontSize: 12,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              Text(
                booking.petName,
                style: const TextStyle(
                  color: AppColors.brownText,
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                ),
              ),
              if (booking.petSubtitle.isNotEmpty) ...[
                const SizedBox(height: 4),
                Text(
                  booking.petSubtitle,
                  style: const TextStyle(
                    color: AppColors.mutedText,
                    fontSize: 13,
                  ),
                ),
              ],
              const SizedBox(height: 10),
              Row(
                children: [
                  const Icon(
                    Icons.calendar_month_outlined,
                    color: AppColors.primary,
                    size: 18,
                  ),
                  const SizedBox(width: 6),
                  Expanded(
                    child: Text(
                      '${_dateLabel(booking.appointmentDate)} - ${booking.timeSlotLabel}',
                      style: const TextStyle(
                        color: AppColors.brownText,
                        fontSize: 13,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              Row(
                children: [
                  Expanded(
                    child: Text(
                      booking.services.map((service) => service.name).join(', '),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        color: AppColors.mutedText,
                        fontSize: 13,
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    _moneyLabel(booking.totalVnd),
                    style: const TextStyle(
                      color: AppColors.primary,
                      fontSize: 14,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  static String _statusLabel(String status) {
    return switch (status) {
      'completed' => 'Hoàn tất',
      'cancelled' => 'Đã hủy',
      _ => 'Sắp tới',
    };
  }

  static Color _statusColor(String status) {
    return switch (status) {
      'completed' => const Color(0xFF2E7D32),
      'cancelled' => const Color(0xFFC62828),
      _ => AppColors.primary,
    };
  }

  static String _dateLabel(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }

  static String _moneyLabel(int amount) {
    final value = amount.toString();
    final buffer = StringBuffer();
    for (var i = 0; i < value.length; i += 1) {
      final indexFromEnd = value.length - i;
      buffer.write(value[i]);
      if (indexFromEnd > 1 && indexFromEnd % 3 == 1) {
        buffer.write('.');
      }
    }
    return '${buffer}đ';
  }
}
