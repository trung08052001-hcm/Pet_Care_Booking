import 'package:equatable/equatable.dart';

class BookingConfirmationRequest extends Equatable {
  const BookingConfirmationRequest({
    required this.petId,
    required this.serviceIds,
    required this.appointmentDate,
    required this.timeSlotId,
    required this.timeSlotLabel,
    required this.totalVnd,
  });

  final String petId;
  final List<String> serviceIds;
  final DateTime appointmentDate;
  final String timeSlotId;
  final String timeSlotLabel;
  final int totalVnd;

  @override
  List<Object?> get props => [
        petId,
        serviceIds,
        appointmentDate,
        timeSlotId,
        timeSlotLabel,
        totalVnd,
      ];
}
