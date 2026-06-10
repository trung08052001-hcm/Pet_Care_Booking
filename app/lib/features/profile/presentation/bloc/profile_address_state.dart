import 'package:app/features/profile/domain/entities/user_address.dart';
import 'package:equatable/equatable.dart';

enum ProfileAddressStatus {
  initial,
  loading,
  ready,
  saving,
  locating,
  failure,
}

enum ProfileAddressInteraction {
  none,
  saved,
  located,
}

class ProfileAddressState extends Equatable {
  const ProfileAddressState({
    this.status = ProfileAddressStatus.initial,
    this.address,
    this.detail = '',
    this.label = '',
    this.latitude,
    this.longitude,
    this.message,
    this.interaction = ProfileAddressInteraction.none,
  });

  final ProfileAddressStatus status;
  final UserAddress? address;
  final String detail;
  final String label;
  final double? latitude;
  final double? longitude;
  final String? message;
  final ProfileAddressInteraction interaction;

  bool get isLoading =>
      status == ProfileAddressStatus.initial ||
      status == ProfileAddressStatus.loading;

  bool get isSaving => status == ProfileAddressStatus.saving;

  bool get isLocating => status == ProfileAddressStatus.locating;

  bool get canSave => detail.trim().isNotEmpty && !isSaving && !isLocating;

  ProfileAddressState copyWith({
    ProfileAddressStatus? status,
    UserAddress? address,
    String? detail,
    String? label,
    double? latitude,
    double? longitude,
    String? message,
    ProfileAddressInteraction? interaction,
    bool clearMessage = false,
    bool clearLocation = false,
  }) {
    return ProfileAddressState(
      status: status ?? this.status,
      address: address ?? this.address,
      detail: detail ?? this.detail,
      label: label ?? this.label,
      latitude: clearLocation ? null : (latitude ?? this.latitude),
      longitude: clearLocation ? null : (longitude ?? this.longitude),
      message: clearMessage ? null : (message ?? this.message),
      interaction: interaction ?? this.interaction,
    );
  }

  @override
  List<Object?> get props => [
        status,
        address,
        detail,
        label,
        latitude,
        longitude,
        message,
        interaction,
      ];
}
