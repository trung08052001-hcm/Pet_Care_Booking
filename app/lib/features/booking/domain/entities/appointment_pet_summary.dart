import 'package:equatable/equatable.dart';

class AppointmentPetSummary extends Equatable {
  const AppointmentPetSummary({
    required this.petId,
    required this.name,
    required this.imagePlaceholderColor,
    required this.serviceTags,
  });

  final String petId;
  final String name;
  final int imagePlaceholderColor;
  final List<String> serviceTags;

  @override
  List<Object?> get props => [petId, name, imagePlaceholderColor, serviceTags];
}
