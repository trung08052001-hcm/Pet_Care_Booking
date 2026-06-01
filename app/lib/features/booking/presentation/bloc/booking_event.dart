import 'package:app/features/booking/domain/entities/booking_step.dart';
import 'package:equatable/equatable.dart';

sealed class BookingEvent extends Equatable {
  const BookingEvent();

  @override
  List<Object?> get props => const [];
}

final class BookingStarted extends BookingEvent {
  const BookingStarted({this.serviceId});

  final String? serviceId;

  @override
  List<Object?> get props => [serviceId];
}

final class BookingSearchQueryChanged extends BookingEvent {
  const BookingSearchQueryChanged(this.query);

  final String query;

  @override
  List<Object?> get props => [query];
}

final class BookingStepChanged extends BookingEvent {
  const BookingStepChanged(this.step);

  final BookingStep step;

  @override
  List<Object?> get props => [step];
}

final class BookingPetBookPressed extends BookingEvent {
  const BookingPetBookPressed(this.petId);

  final String petId;

  @override
  List<Object?> get props => [petId];
}

final class BookingAddPetPressed extends BookingEvent {
  const BookingAddPetPressed();
}

final class BookingPetMoreOptionsPressed extends BookingEvent {
  const BookingPetMoreOptionsPressed(this.petId);

  final String petId;

  @override
  List<Object?> get props => [petId];
}

final class BookingQuickAddPressed extends BookingEvent {
  const BookingQuickAddPressed();
}

final class BookingInteractionConsumed extends BookingEvent {
  const BookingInteractionConsumed();
}

final class BookingServicesConfirmed extends BookingEvent {
  const BookingServicesConfirmed({
    required this.serviceIds,
    required this.totalVnd,
  });

  final List<String> serviceIds;
  final int totalVnd;

  @override
  List<Object?> get props => [serviceIds, totalVnd];
}

final class BookingServiceStepBackPressed extends BookingEvent {
  const BookingServiceStepBackPressed();
}

final class BookingAppointmentConfirmed extends BookingEvent {
  const BookingAppointmentConfirmed({
    required this.appointmentDate,
    required this.timeSlotId,
    required this.timeSlotLabel,
  });

  final DateTime appointmentDate;
  final String timeSlotId;
  final String timeSlotLabel;

  @override
  List<Object?> get props => [appointmentDate, timeSlotId, timeSlotLabel];
}

final class BookingAppointmentStepBackPressed extends BookingEvent {
  const BookingAppointmentStepBackPressed();
}

final class BookingConfirmationStepBackPressed extends BookingEvent {
  const BookingConfirmationStepBackPressed();
}

final class BookingFlowCompleted extends BookingEvent {
  const BookingFlowCompleted({required this.bookingReference});

  final String bookingReference;

  @override
  List<Object?> get props => [bookingReference];
}
