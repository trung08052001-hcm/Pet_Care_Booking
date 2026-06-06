import 'package:app/features/pets/domain/entities/pet_gender.dart';
import 'package:app/features/pets/domain/entities/pet_health_status.dart';
import 'package:equatable/equatable.dart';

class Pet extends Equatable {
  const Pet({
    required this.id,
    required this.name,
    required this.breed,
    required this.ageLabel,
    required this.weightLabel,
    required this.gender,
    required this.healthStatus,
    required this.reminderLabel,
    required this.imagePlaceholderColor,
    this.imageUrl,
    this.ageYears,
    this.weightKg,
    this.petType,
    this.vaccinationStatus,
  });

  final String id;
  final String name;
  final String breed;
  final String ageLabel;
  final String weightLabel;
  final PetGender gender;
  final PetHealthStatus healthStatus;
  final String reminderLabel;
  final int imagePlaceholderColor;
  final String? imageUrl;
  final int? ageYears;
  final double? weightKg;
  final String? petType;
  final String? vaccinationStatus;

  String get detailsLine => '$breed • $ageLabel • $weightLabel';

  @override
  List<Object?> get props => [
        id,
        name,
        breed,
        ageLabel,
        weightLabel,
        gender,
        healthStatus,
        reminderLabel,
        imagePlaceholderColor,
        imageUrl,
        ageYears,
        weightKg,
        petType,
        vaccinationStatus,
      ];
}
