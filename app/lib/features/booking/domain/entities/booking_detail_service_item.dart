import 'package:app/features/booking/domain/entities/bookable_service_icon.dart';
import 'package:equatable/equatable.dart';

class BookingDetailServiceItem extends Equatable {
  const BookingDetailServiceItem({
    required this.serviceId,
    required this.title,
    required this.priceVnd,
    required this.icon,
    required this.iconBackgroundColor,
  });

  final String serviceId;
  final String title;
  final int priceVnd;
  final BookableServiceIcon icon;
  final int iconBackgroundColor;

  @override
  List<Object?> get props =>
      [serviceId, title, priceVnd, icon, iconBackgroundColor];
}
