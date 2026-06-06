import 'package:app/features/booking/domain/entities/booking_detail.dart';
import 'package:app/features/booking/domain/entities/booking_detail_service_item.dart';
import 'package:app/features/booking/domain/entities/booking_detail_status.dart';
import 'package:app/features/booking/domain/entities/bookable_service_icon.dart';
import 'package:app/features/booking/domain/entities/booking_confirmation_request.dart';

class CreateBookingRequestModel {
  const CreateBookingRequestModel(this.request);

  final BookingConfirmationRequest request;

  Map<String, dynamic> toJson() => {
        'petId': request.petId,
        'serviceIds': request.serviceIds,
        'appointmentDate': request.appointmentDate.toIso8601String(),
        'timeSlotId': request.timeSlotId,
        'timeSlotLabel': request.timeSlotLabel,
        'totalVnd': request.totalVnd,
      };
}

class BookingAvailabilityResponseModel {
  const BookingAvailabilityResponseModel({required this.slots});

  factory BookingAvailabilityResponseModel.fromJson(Map<String, dynamic> json) {
    final data = Map<String, dynamic>.from(json['data'] as Map? ?? {});
    final rawSlots = data['slots'] as List? ?? const [];
    return BookingAvailabilityResponseModel(
      slots: rawSlots
          .map((item) => BookedSlotModel.fromJson(Map<String, dynamic>.from(item as Map)))
          .toList(),
    );
  }

  final List<BookedSlotModel> slots;
}

class BookedSlotModel {
  const BookedSlotModel({required this.dateKey, required this.timeSlotId});

  factory BookedSlotModel.fromJson(Map<String, dynamic> json) {
    return BookedSlotModel(
      dateKey: json['dateKey'] as String? ?? '',
      timeSlotId: json['timeSlotId'] as String? ?? '',
    );
  }

  final String dateKey;
  final String timeSlotId;
}

class BookingsApiResponseModel {
  const BookingsApiResponseModel({required this.bookings});

  factory BookingsApiResponseModel.fromJson(Map<String, dynamic> json) {
    final data = Map<String, dynamic>.from(json['data'] as Map? ?? {});
    final rawBookings = data['bookings'] as List? ?? const [];
    return BookingsApiResponseModel(
      bookings: rawBookings
          .map((item) => BookingModel.fromJson(Map<String, dynamic>.from(item as Map)))
          .toList(),
    );
  }

  final List<BookingModel> bookings;
}

class BookingApiResponseModel {
  const BookingApiResponseModel({required this.booking});

  factory BookingApiResponseModel.fromJson(Map<String, dynamic> json) {
    final data = Map<String, dynamic>.from(json['data'] as Map? ?? {});
    return BookingApiResponseModel(
      booking: BookingModel.fromJson(Map<String, dynamic>.from(data['booking'] as Map)),
    );
  }

  final BookingModel booking;
}

class BookingModel {
  const BookingModel({
    required this.id,
    required this.displayCode,
    required this.status,
    required this.petId,
    required this.petName,
    required this.petSubtitle,
    required this.services,
    required this.appointmentDate,
    required this.timeSlotLabel,
    required this.locationName,
    required this.locationAddress,
    required this.subtotalVnd,
    required this.discountLabel,
    required this.discountVnd,
    required this.totalVnd,
    required this.paymentStatusLabel,
    required this.createdAt,
  });

  factory BookingModel.fromJson(Map<String, dynamic> json) {
    final rawServices = json['services'] as List? ?? const [];
    return BookingModel(
      id: json['id'] as String? ?? '',
      displayCode: json['displayCode'] as String? ?? '',
      status: json['status'] as String? ?? 'upcoming',
      petId: json['petId'] as String? ?? '',
      petName: json['petName'] as String? ?? 'Thú cưng',
      petSubtitle: json['petSubtitle'] as String? ?? '',
      services: rawServices
          .map((item) => BookingServiceModel.fromJson(Map<String, dynamic>.from(item as Map)))
          .toList(),
      appointmentDate:
          DateTime.tryParse(json['appointmentDate'] as String? ?? '') ?? DateTime(2026),
      timeSlotLabel: json['timeSlotLabel'] as String? ?? '',
      locationName: json['locationName'] as String? ?? 'PawSitive Sanctuary',
      locationAddress: json['locationAddress'] as String? ?? '',
      subtotalVnd: (json['subtotalVnd'] as num?)?.round() ?? 0,
      discountLabel: json['discountLabel'] as String? ?? 'Giảm giá',
      discountVnd: (json['discountVnd'] as num?)?.round() ?? 0,
      totalVnd: (json['totalVnd'] as num?)?.round() ?? 0,
      paymentStatusLabel:
          json['paymentStatusLabel'] as String? ?? 'Thanh toán tại cửa hàng',
      createdAt: DateTime.tryParse(json['createdAt'] as String? ?? '') ?? DateTime.now(),
    );
  }

  final String id;
  final String displayCode;
  final String status;
  final String petId;
  final String petName;
  final String petSubtitle;
  final List<BookingServiceModel> services;
  final DateTime appointmentDate;
  final String timeSlotLabel;
  final String locationName;
  final String locationAddress;
  final int subtotalVnd;
  final String discountLabel;
  final int discountVnd;
  final int totalVnd;
  final String paymentStatusLabel;
  final DateTime createdAt;

  BookingDetail toEntity() {
    return BookingDetail(
      id: id,
      displayCode: displayCode.isEmpty ? '#${id.toUpperCase()}' : displayCode,
      status: _statusFromString(status),
      petId: petId,
      petName: petName,
      petSubtitle: petSubtitle,
      petImagePlaceholderColor: 0xFFE8D5C4,
      services: services.map((service) => service.toEntity()).toList(),
      dateLabel: _dateLabel(appointmentDate),
      timeLabel: timeSlotLabel,
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

  static BookingDetailStatus _statusFromString(String value) {
    return switch (value) {
      'completed' => BookingDetailStatus.completed,
      'cancelled' => BookingDetailStatus.cancelled,
      _ => BookingDetailStatus.upcoming,
    };
  }

  static String _dateLabel(DateTime date) {
    final weekday = switch (date.weekday) {
      DateTime.monday => 'Thứ 2',
      DateTime.tuesday => 'Thứ 3',
      DateTime.wednesday => 'Thứ 4',
      DateTime.thursday => 'Thứ 5',
      DateTime.friday => 'Thứ 6',
      DateTime.saturday => 'Thứ 7',
      DateTime.sunday => 'Chủ nhật',
      _ => 'Thứ',
    };
    return '$weekday, ${date.day} Tháng ${date.month}, ${date.year}';
  }
}

class BookingServiceModel {
  const BookingServiceModel({
    required this.id,
    required this.name,
    required this.amountVnd,
  });

  factory BookingServiceModel.fromJson(Map<String, dynamic> json) {
    return BookingServiceModel(
      id: json['id'] as String? ?? '',
      name: json['name'] as String? ?? '',
      amountVnd: (json['amountVnd'] as num?)?.round() ?? 0,
    );
  }

  final String id;
  final String name;
  final int amountVnd;

  BookingDetailServiceItem toEntity() {
    return BookingDetailServiceItem(
      serviceId: id,
      title: name,
      priceVnd: amountVnd,
      icon: BookableServiceIcon.spa,
      iconBackgroundColor: 0xFFFFF3E8,
    );
  }
}
