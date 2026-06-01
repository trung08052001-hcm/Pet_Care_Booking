import 'package:app/features/booking/domain/entities/appointment_day_option.dart';
import 'package:app/features/booking/domain/entities/appointment_pet_summary.dart';
import 'package:app/features/booking/domain/entities/appointment_time_slot.dart';
import 'package:equatable/equatable.dart';

class AppointmentPageContent extends Equatable {
  const AppointmentPageContent({
    required this.title,
    required this.monthLabel,
    required this.dateSectionTitle,
    required this.timeSectionTitle,
    required this.morningSectionTitle,
    required this.afternoonSectionTitle,
    required this.commitmentTitle,
    required this.commitmentBody,
    required this.totalLabel,
    required this.confirmButtonLabel,
    required this.petSummary,
    required this.days,
    required this.slotsByDateKey,
  });

  final String title;
  final String monthLabel;
  final String dateSectionTitle;
  final String timeSectionTitle;
  final String morningSectionTitle;
  final String afternoonSectionTitle;
  final String commitmentTitle;
  final String commitmentBody;
  final String totalLabel;
  final String confirmButtonLabel;
  final AppointmentPetSummary petSummary;
  final List<AppointmentDayOption> days;
  final Map<String, List<AppointmentTimeSlot>> slotsByDateKey;

  @override
  List<Object?> get props => [
        title,
        monthLabel,
        dateSectionTitle,
        timeSectionTitle,
        morningSectionTitle,
        afternoonSectionTitle,
        commitmentTitle,
        commitmentBody,
        totalLabel,
        confirmButtonLabel,
        petSummary,
        days,
        slotsByDateKey,
      ];
}
