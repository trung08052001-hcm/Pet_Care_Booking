import 'package:app/features/booking/data/datasources/booking_service_mock_data_source.dart';
import 'package:app/features/booking/domain/entities/booking_confirmation_content.dart';
import 'package:app/features/booking/domain/entities/booking_confirmation_request.dart';
import 'package:app/features/booking/domain/entities/booking_detail.dart';
import 'package:app/features/booking/domain/entities/bookable_service_icon.dart';
import 'package:app/features/booking/domain/entities/booking_detail_service_item.dart';
import 'package:app/features/booking/domain/entities/booking_detail_status.dart';

abstract final class BookingDetailMapper {
  static BookingDetail fromConfirmation({
    required String bookingId,
    required BookingConfirmationRequest request,
    required BookingConfirmationContent content,
    required BookingServiceMockDataSource servicesDataSource,
  }) {
    final catalog = servicesDataSource.getPageContent().services;
    final services = <BookingDetailServiceItem>[];

    for (final serviceId in request.serviceIds) {
      for (final service in catalog) {
        if (service.id == serviceId) {
          services.add(
            BookingDetailServiceItem(
              serviceId: service.id,
              title: _displayTitle(service.id, service.title),
              priceVnd: service.priceVnd,
              icon: service.icon,
              iconBackgroundColor: service.iconBackgroundColor,
            ),
          );
          break;
        }
      }
    }

    if (request.serviceIds.length == 1 &&
        request.serviceIds.contains('booking-spa')) {
      services.add(
        const BookingDetailServiceItem(
          serviceId: 'booking-grooming',
          title: 'Cắt tỉa tạo kiểu',
          priceVnd: 200000,
          icon: BookableServiceIcon.spa,
          iconBackgroundColor: 0xFFFFE8D6,
        ),
      );
    }

    final subtotalVnd =
        services.fold<int>(0, (sum, item) => sum + item.priceVnd);
    final discountVnd =
        subtotalVnd > content.totalVnd ? subtotalVnd - content.totalVnd : 0;
    final discountLabel = discountVnd > 0
        ? 'Giảm giá (PetLove)'
        : content.discountLabel;

    final weekday = _weekdayLabel(request.appointmentDate.weekday);
    final day = request.appointmentDate.day;
    final month = request.appointmentDate.month;
    final dateLabel = '$weekday, $day Tháng $month, 2023';
    final timeLabel = _formatTimeLabel(request.timeSlotLabel);

    return BookingDetail(
      id: bookingId,
      displayCode: '#$bookingId',
      status: BookingDetailStatus.upcoming,
      petId: request.petId,
      petName: content.petName,
      petSubtitle: _petSubtitleWithWeight(request.petId, content.petSubtitle),
      petImagePlaceholderColor: content.petImagePlaceholderColor,
      services: services,
      dateLabel: dateLabel,
      timeLabel: timeLabel,
      locationName: 'PawSitive Sanctuary',
      locationAddress: '123 Đường Hạnh Phúc, Quận 1, TP. HCM',
      subtotalVnd: subtotalVnd,
      discountLabel: discountLabel,
      discountVnd: discountVnd,
      totalVnd: content.totalVnd,
      paymentStatusLabel: 'Đã thanh toán qua MoMo',
      appointmentDate: request.appointmentDate,
      timeSlotLabel: request.timeSlotLabel,
      createdAt: DateTime.now(),
    );
  }

  static String _displayTitle(String serviceId, String fallback) {
    return switch (serviceId) {
      'booking-spa' => 'Tắm & Spa cao cấp',
      'booking-grooming' => 'Cắt tỉa tạo kiểu',
      _ => fallback,
    };
  }

  static String _petSubtitleWithWeight(String petId, String base) {
    return switch (petId) {
      'pet-mochi' => 'Corgi • 2 tuổi • 8.5kg',
      'pet-luna' => 'Golden Retriever • 2 tuổi • 28kg',
      _ => base,
    };
  }

  static String _formatTimeLabel(String slotLabel) {
    if (slotLabel.contains('AM') || slotLabel.contains('PM')) {
      return slotLabel;
    }
    final parts = slotLabel.split(':');
    if (parts.length != 2) {
      return slotLabel;
    }
    final hour = int.tryParse(parts[0]) ?? 0;
    final minute = parts[1];
    if (hour < 12) {
      return '$slotLabel AM';
    }
    return '${hour == 12 ? 12 : hour - 12}:$minute PM';
  }

  static String _weekdayLabel(int weekday) {
    return switch (weekday) {
      DateTime.monday => 'Thứ Hai',
      DateTime.tuesday => 'Thứ Ba',
      DateTime.wednesday => 'Thứ Tư',
      DateTime.thursday => 'Thứ Năm',
      DateTime.friday => 'Thứ Sáu',
      DateTime.saturday => 'Thứ Bảy',
      DateTime.sunday => 'Chủ nhật',
      _ => 'Thứ',
    };
  }
}
