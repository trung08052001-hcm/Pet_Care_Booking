import 'package:app/features/booking/domain/entities/bookable_service_icon.dart';
import 'package:equatable/equatable.dart';

class BookableService extends Equatable {
  const BookableService({
    required this.id,
    required this.title,
    required this.description,
    required this.priceVnd,
    required this.icon,
    required this.iconBackgroundColor,
    this.priceUnitSuffix,
    this.tagLabel,
  });

  final String id;
  final String title;
  final String description;
  final int priceVnd;
  final BookableServiceIcon icon;
  final int iconBackgroundColor;
  final String? priceUnitSuffix;
  final String? tagLabel;

  @override
  List<Object?> get props => [
        id,
        title,
        description,
        priceVnd,
        icon,
        iconBackgroundColor,
        priceUnitSuffix,
        tagLabel,
      ];
}
