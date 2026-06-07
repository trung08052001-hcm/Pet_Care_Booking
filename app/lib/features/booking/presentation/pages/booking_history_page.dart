import 'dart:async';

import 'package:app/app/navigation/booking_navigation.dart';
import 'package:app/app/theme/app_colors.dart';
import 'package:app/core/di/injection.dart';
import 'package:app/core/network/api_service.dart';
import 'package:app/core/network/network_info.dart';
import 'package:app/features/booking/data/datasources/booking_local_data_source.dart';
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
  List<BookingModel> _bookings = const [];
  bool _isRefreshing = true;
  bool _hasError = false;

  @override
  void initState() {
    super.initState();
    _bookings = getIt<BookingLocalDataSource>().getCachedBookings();
    unawaited(_refreshBookings());
  }

  Future<void> _refreshBookings() async {
    final localDataSource = getIt<BookingLocalDataSource>();
    if (mounted) {
      setState(() {
        _isRefreshing = true;
        _hasError = false;
      });
    }

    if (!await getIt<NetworkInfo>().isConnected) {
      if (mounted) {
        setState(() {
          _bookings = localDataSource.getCachedBookings();
          _isRefreshing = false;
        });
      }
      return;
    }

    try {
      final response = await getIt<AppApiService>().getBookings().timeout(
        const Duration(seconds: 4),
      );
      await localDataSource.saveBookings(response.bookings);
      if (mounted) {
        setState(() {
          _bookings = response.bookings;
          _isRefreshing = false;
        });
      }
    } on Exception {
      if (mounted) {
        setState(() {
          _bookings = localDataSource.getCachedBookings();
          _isRefreshing = false;
          _hasError = true;
        });
      }
    }
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
      body: Stack(
        children: [
          if (_bookings.isEmpty)
            _BookingHistoryMessage(
              title: _isRefreshing
                  ? 'Đang tải lịch sử đặt chỗ...'
                  : _hasError
                  ? 'Không tải được lịch sử đặt chỗ'
                  : 'Bạn chưa có lịch đặt nào',
              actionLabel: 'Tải lại',
              onAction: () => unawaited(_refreshBookings()),
            )
          else
            RefreshIndicator(
              color: AppColors.primary,
              onRefresh: _refreshBookings,
              child: ListView.separated(
                padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
                itemCount: _bookings.length,
                separatorBuilder: (context, index) =>
                    const SizedBox(height: 12),
                itemBuilder: (context, index) {
                  final booking = _bookings[index];
                  return _BookingHistoryTile(
                    booking: booking,
                    onTap: () =>
                        openBookingDetail(context, bookingId: booking.id),
                  );
                },
              ),
            ),
          if (_isRefreshing && _bookings.isNotEmpty)
            const Positioned(
              left: 0,
              right: 0,
              top: 0,
              child: LinearProgressIndicator(color: AppColors.primary),
            ),
        ],
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
                fontWeight: FontWeight.w700,
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
  const _BookingHistoryTile({required this.booking, required this.onTap});

  final BookingModel booking;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
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
                        fontWeight: FontWeight.w800,
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
                        _statusLabel(booking.status),
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
                  fontWeight: FontWeight.w800,
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
    return '$bufferđ';
  }
}
