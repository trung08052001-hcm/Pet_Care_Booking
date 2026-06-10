import 'package:equatable/equatable.dart';

class UserAddress extends Equatable {
  const UserAddress({
    required this.detail,
    this.label = '',
    this.latitude,
    this.longitude,
    this.updatedAt,
  });

  final String detail;
  final String label;
  final double? latitude;
  final double? longitude;
  final DateTime? updatedAt;

  bool get hasLocation => latitude != null && longitude != null;

  @override
  List<Object?> get props => [
        detail,
        label,
        latitude,
        longitude,
        updatedAt,
      ];
}
