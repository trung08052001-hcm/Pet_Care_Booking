import 'package:equatable/equatable.dart';

sealed class ServiceDetailEvent extends Equatable {
  const ServiceDetailEvent();

  @override
  List<Object?> get props => const [];
}

final class ServiceDetailStarted extends ServiceDetailEvent {
  const ServiceDetailStarted(this.serviceId);

  final String serviceId;

  @override
  List<Object?> get props => [serviceId];
}

final class ServiceDetailBookNowPressed extends ServiceDetailEvent {
  const ServiceDetailBookNowPressed();
}
