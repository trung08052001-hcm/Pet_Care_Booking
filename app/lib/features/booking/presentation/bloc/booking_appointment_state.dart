import 'package:app/features/booking/domain/entities/appointment_page_content.dart';
import 'package:app/features/booking/domain/entities/appointment_time_slot.dart';
import 'package:equatable/equatable.dart';

enum BookingAppointmentStatus {
  initial,
  loading,
  success,
  failure,
}

class BookingAppointmentState extends Equatable {
  const BookingAppointmentState({
    this.status = BookingAppointmentStatus.initial,
    this.content,
    this.petId,
    this.serviceIds = const [],
    this.totalVnd = 0,
    this.selectedDate,
    this.selectedTimeSlotId,
    this.message,
  });

  final BookingAppointmentStatus status;
  final AppointmentPageContent? content;
  final String? petId;
  final List<String> serviceIds;
  final int totalVnd;
  final DateTime? selectedDate;
  final String? selectedTimeSlotId;
  final String? message;

  bool get isLoading =>
      status == BookingAppointmentStatus.loading ||
      status == BookingAppointmentStatus.initial;

  List<AppointmentTimeSlot> get slotsForSelectedDate {
    final content = this.content;
    final date = selectedDate;
    if (content == null || date == null) {
      return const [];
    }
    final key = '${date.year}-${date.month}-${date.day}';
    return content.slotsByDateKey[key] ?? const [];
  }

  AppointmentTimeSlot? get selectedSlot {
    final id = selectedTimeSlotId;
    if (id == null) {
      return null;
    }
    for (final slot in slotsForSelectedDate) {
      if (slot.id == id) {
        return slot;
      }
    }
    return null;
  }

  bool get canConfirm {
    final slot = selectedSlot;
    return selectedDate != null &&
        slot != null &&
        slot.availability == AppointmentSlotAvailability.available;
  }

  String? get appointmentSummaryLabel {
    final date = selectedDate;
    final slot = selectedSlot;
    if (date == null || slot == null) {
      return null;
    }
    return '${date.day} Tháng ${date.month} Lúc ${slot.label}';
  }

  BookingAppointmentState copyWith({
    BookingAppointmentStatus? status,
    AppointmentPageContent? content,
    String? petId,
    List<String>? serviceIds,
    int? totalVnd,
    DateTime? selectedDate,
    String? selectedTimeSlotId,
    String? message,
    bool clearMessage = false,
    bool clearTimeSlot = false,
  }) {
    return BookingAppointmentState(
      status: status ?? this.status,
      content: content ?? this.content,
      petId: petId ?? this.petId,
      serviceIds: serviceIds ?? this.serviceIds,
      totalVnd: totalVnd ?? this.totalVnd,
      selectedDate: selectedDate ?? this.selectedDate,
      selectedTimeSlotId:
          clearTimeSlot ? null : (selectedTimeSlotId ?? this.selectedTimeSlotId),
      message: clearMessage ? null : (message ?? this.message),
    );
  }

  @override
  List<Object?> get props => [
        status,
        content,
        petId,
        serviceIds,
        totalVnd,
        selectedDate,
        selectedTimeSlotId,
        message,
      ];
}
