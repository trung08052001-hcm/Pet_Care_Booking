import 'package:equatable/equatable.dart';

class AppointmentDayOption extends Equatable {
  const AppointmentDayOption({
    required this.date,
    required this.weekdayLabel,
    required this.dayNumberLabel,
  });

  final DateTime date;
  final String weekdayLabel;
  final String dayNumberLabel;

  @override
  List<Object?> get props => [date, weekdayLabel, dayNumberLabel];
}
