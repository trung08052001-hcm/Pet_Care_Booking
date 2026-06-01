import 'package:app/features/booking/domain/entities/appointment_time_period.dart';
import 'package:equatable/equatable.dart';

enum AppointmentSlotAvailability {
  available,
  full,
}

class AppointmentTimeSlot extends Equatable {
  const AppointmentTimeSlot({
    required this.id,
    required this.label,
    required this.period,
    required this.availability,
  });

  final String id;
  final String label;
  final AppointmentTimePeriod period;
  final AppointmentSlotAvailability availability;

  @override
  List<Object?> get props => [id, label, period, availability];
}
