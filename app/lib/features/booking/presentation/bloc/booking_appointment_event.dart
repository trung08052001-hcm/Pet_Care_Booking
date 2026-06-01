import 'package:equatable/equatable.dart';

sealed class BookingAppointmentEvent extends Equatable {
  const BookingAppointmentEvent();

  @override
  List<Object?> get props => const [];
}

final class BookingAppointmentStarted extends BookingAppointmentEvent {
  const BookingAppointmentStarted({
    required this.petId,
    required this.serviceIds,
    required this.totalVnd,
    this.initialDate,
    this.initialTimeSlotId,
  });

  final String petId;
  final List<String> serviceIds;
  final int totalVnd;
  final DateTime? initialDate;
  final String? initialTimeSlotId;

  @override
  List<Object?> get props =>
      [petId, serviceIds, totalVnd, initialDate, initialTimeSlotId];
}

final class BookingAppointmentDateSelected extends BookingAppointmentEvent {
  const BookingAppointmentDateSelected(this.date);

  final DateTime date;

  @override
  List<Object?> get props => [date];
}

final class BookingAppointmentTimeSlotSelected extends BookingAppointmentEvent {
  const BookingAppointmentTimeSlotSelected(this.slotId);

  final String slotId;

  @override
  List<Object?> get props => [slotId];
}

final class BookingAppointmentConfirmPressed extends BookingAppointmentEvent {
  const BookingAppointmentConfirmPressed();
}
