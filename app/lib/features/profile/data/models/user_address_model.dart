import 'package:app/features/profile/domain/entities/user_address.dart';

class UserAddressModel {
  const UserAddressModel({
    required this.detail,
    this.label = '',
    this.latitude,
    this.longitude,
    this.updatedAt,
  });

  factory UserAddressModel.fromJson(Map<String, dynamic> json) {
    return UserAddressModel(
      detail: json['detail'] as String? ?? '',
      label: json['label'] as String? ?? '',
      latitude: (json['latitude'] as num?)?.toDouble(),
      longitude: (json['longitude'] as num?)?.toDouble(),
      updatedAt: DateTime.tryParse(json['updatedAt'] as String? ?? ''),
    );
  }

  final String detail;
  final String label;
  final double? latitude;
  final double? longitude;
  final DateTime? updatedAt;

  Map<String, dynamic> toJson() => {
        'detail': detail,
        'label': label,
        'latitude': latitude,
        'longitude': longitude,
      };

  UserAddress toEntity() {
    return UserAddress(
      detail: detail,
      label: label,
      latitude: latitude,
      longitude: longitude,
      updatedAt: updatedAt,
    );
  }
}
