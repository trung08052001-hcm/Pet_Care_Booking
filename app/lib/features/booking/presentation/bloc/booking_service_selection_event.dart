import 'package:equatable/equatable.dart';

sealed class BookingServiceSelectionEvent extends Equatable {
  const BookingServiceSelectionEvent();

  @override
  List<Object?> get props => const [];
}

final class BookingServiceSelectionStarted extends BookingServiceSelectionEvent {
  const BookingServiceSelectionStarted({
    this.petId,
    this.preselectedServiceId,
  });

  final String? petId;
  final String? preselectedServiceId;

  @override
  List<Object?> get props => [petId, preselectedServiceId];
}

final class BookingServiceTogglePressed extends BookingServiceSelectionEvent {
  const BookingServiceTogglePressed(this.serviceId);

  final String serviceId;

  @override
  List<Object?> get props => [serviceId];
}

final class BookingServiceContinuePressed extends BookingServiceSelectionEvent {
  const BookingServiceContinuePressed();
}
