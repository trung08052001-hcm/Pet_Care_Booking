import 'package:app/features/booking/domain/entities/booking_line_item.dart';
import 'package:app/features/booking/domain/entities/booking_payment_method.dart';
import 'package:equatable/equatable.dart';

class BookingConfirmationContent extends Equatable {
  const BookingConfirmationContent({
    required this.title,
    required this.petName,
    required this.petSubtitle,
    required this.serviceLabel,
    required this.serviceValue,
    required this.timeLabel,
    required this.timeValue,
    required this.locationLabel,
    required this.locationValue,
    required this.paymentSectionTitle,
    required this.lineItems,
    required this.discountLabel,
    required this.discountVnd,
    required this.totalLabel,
    required this.totalVnd,
    required this.paymentMethod,
    required this.cancellationNote,
    required this.completeButtonLabel,
    required this.petImagePlaceholderColor,
  });

  final String title;
  final String petName;
  final String petSubtitle;
  final String serviceLabel;
  final String serviceValue;
  final String timeLabel;
  final String timeValue;
  final String locationLabel;
  final String locationValue;
  final String paymentSectionTitle;
  final List<BookingLineItem> lineItems;
  final String discountLabel;
  final int discountVnd;
  final String totalLabel;
  final int totalVnd;
  final BookingPaymentMethod paymentMethod;
  final String cancellationNote;
  final String completeButtonLabel;
  final int petImagePlaceholderColor;

  @override
  List<Object?> get props => [
        title,
        petName,
        petSubtitle,
        serviceLabel,
        serviceValue,
        timeLabel,
        timeValue,
        locationLabel,
        locationValue,
        paymentSectionTitle,
        lineItems,
        discountLabel,
        discountVnd,
        totalLabel,
        totalVnd,
        paymentMethod,
        cancellationNote,
        completeButtonLabel,
        petImagePlaceholderColor,
      ];
}
