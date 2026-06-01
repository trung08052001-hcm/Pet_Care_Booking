import 'package:app/features/booking/domain/entities/bookable_service.dart';
import 'package:equatable/equatable.dart';

class BookingServicePageContent extends Equatable {
  const BookingServicePageContent({
    required this.title,
    required this.subtitle,
    required this.services,
    required this.tipTitle,
    required this.tipBody,
    required this.totalLabel,
    required this.continueLabel,
  });

  final String title;
  final String subtitle;
  final List<BookableService> services;
  final String tipTitle;
  final String tipBody;
  final String totalLabel;
  final String continueLabel;

  @override
  List<Object?> get props => [
        title,
        subtitle,
        services,
        tipTitle,
        tipBody,
        totalLabel,
        continueLabel,
      ];
}
