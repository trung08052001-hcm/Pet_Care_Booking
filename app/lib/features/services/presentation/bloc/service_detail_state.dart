import 'package:app/features/services/domain/entities/pet_care_service.dart';
import 'package:equatable/equatable.dart';

enum ServiceDetailStatus {
  initial,
  loading,
  success,
  failure,
}

enum ServiceDetailInteraction {
  none,
  bookNow,
}

class ServiceDetailState extends Equatable {
  const ServiceDetailState({
    this.status = ServiceDetailStatus.initial,
    this.service,
    this.message,
    this.interaction = ServiceDetailInteraction.none,
  });

  final ServiceDetailStatus status;
  final PetCareService? service;
  final String? message;
  final ServiceDetailInteraction interaction;

  bool get isLoading =>
      status == ServiceDetailStatus.loading ||
      status == ServiceDetailStatus.initial;

  ServiceDetailState copyWith({
    ServiceDetailStatus? status,
    PetCareService? service,
    String? message,
    ServiceDetailInteraction? interaction,
    bool clearMessage = false,
  }) {
    return ServiceDetailState(
      status: status ?? this.status,
      service: service ?? this.service,
      message: clearMessage ? null : (message ?? this.message),
      interaction: interaction ?? this.interaction,
    );
  }

  @override
  List<Object?> get props => [
        status,
        service,
        message,
        interaction,
      ];
}
