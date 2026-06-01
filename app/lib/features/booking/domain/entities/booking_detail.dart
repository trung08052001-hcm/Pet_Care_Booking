import 'package:app/features/booking/domain/entities/booking_detail_service_item.dart';
import 'package:app/features/booking/domain/entities/booking_detail_status.dart';
import 'package:equatable/equatable.dart';

class BookingDetail extends Equatable {
  const BookingDetail({
    required this.id,
    required this.displayCode,
    required this.status,
    required this.petId,
    required this.petName,
    required this.petSubtitle,
    required this.petImagePlaceholderColor,
    required this.services,
    required this.dateLabel,
    required this.timeLabel,
    required this.locationName,
    required this.locationAddress,
    required this.subtotalVnd,
    required this.discountLabel,
    required this.discountVnd,
    required this.totalVnd,
    required this.paymentStatusLabel,
    required this.appointmentDate,
    required this.timeSlotLabel,
    required this.createdAt,
  });

  final String id;
  final String displayCode;
  final BookingDetailStatus status;
  final String petId;
  final String petName;
  final String petSubtitle;
  final int petImagePlaceholderColor;
  final List<BookingDetailServiceItem> services;
  final String dateLabel;
  final String timeLabel;
  final String locationName;
  final String locationAddress;
  final int subtotalVnd;
  final String discountLabel;
  final int discountVnd;
  final int totalVnd;
  final String paymentStatusLabel;
  final DateTime appointmentDate;
  final String timeSlotLabel;
  final DateTime createdAt;

  String get statusLabel => switch (status) {
        BookingDetailStatus.upcoming => 'Sắp tới',
        BookingDetailStatus.completed => 'Hoàn thành',
        BookingDetailStatus.cancelled => 'Đã hủy',
      };

  BookingDetail copyWith({
    BookingDetailStatus? status,
  }) {
    return BookingDetail(
      id: id,
      displayCode: displayCode,
      status: status ?? this.status,
      petId: petId,
      petName: petName,
      petSubtitle: petSubtitle,
      petImagePlaceholderColor: petImagePlaceholderColor,
      services: services,
      dateLabel: dateLabel,
      timeLabel: timeLabel,
      locationName: locationName,
      locationAddress: locationAddress,
      subtotalVnd: subtotalVnd,
      discountLabel: discountLabel,
      discountVnd: discountVnd,
      totalVnd: totalVnd,
      paymentStatusLabel: paymentStatusLabel,
      appointmentDate: appointmentDate,
      timeSlotLabel: timeSlotLabel,
      createdAt: createdAt,
    );
  }

  @override
  List<Object?> get props => [
        id,
        displayCode,
        status,
        petId,
        petName,
        petSubtitle,
        petImagePlaceholderColor,
        services,
        dateLabel,
        timeLabel,
        locationName,
        locationAddress,
        subtotalVnd,
        discountLabel,
        discountVnd,
        totalVnd,
        paymentStatusLabel,
        appointmentDate,
        timeSlotLabel,
        createdAt,
      ];
}
