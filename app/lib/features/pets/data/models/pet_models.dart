import 'package:app/features/pets/domain/entities/pet.dart';
import 'package:app/features/pets/domain/entities/pet_gender.dart';
import 'package:app/features/pets/domain/entities/pet_health_status.dart';

class CreatePetRequestModel {
  const CreatePetRequestModel({
    required this.name,
    required this.ageYears,
    required this.weightKg,
    required this.petType,
    required this.vaccinationStatus,
    this.imageDataUrl,
  });

  final String name;
  final int ageYears;
  final double weightKg;
  final String petType;
  final String vaccinationStatus;
  final String? imageDataUrl;

  Map<String, dynamic> toJson() => {
    'name': name,
    'ageYears': ageYears,
    'weightKg': weightKg,
    'petType': petType,
    'vaccinationStatus': vaccinationStatus,
    if (imageDataUrl != null && imageDataUrl!.isNotEmpty)
      'imageDataUrl': imageDataUrl,
  };
}

class PetsApiResponseModel {
  const PetsApiResponseModel({
    required this.success,
    required this.message,
    required this.pets,
  });

  factory PetsApiResponseModel.fromJson(Map<String, dynamic> json) {
    final data = Map<String, dynamic>.from(json['data'] as Map? ?? {});
    final rawPets = data['pets'] as List? ?? const [];
    return PetsApiResponseModel(
      success: json['success'] == true,
      message: json['message'] as String? ?? '',
      pets: rawPets
          .map(
            (item) => PetModel.fromJson(Map<String, dynamic>.from(item as Map)),
          )
          .toList(),
    );
  }

  final bool success;
  final String message;
  final List<PetModel> pets;
}

class PetApiResponseModel {
  const PetApiResponseModel({
    required this.success,
    required this.message,
    required this.pet,
  });

  factory PetApiResponseModel.fromJson(Map<String, dynamic> json) {
    final data = Map<String, dynamic>.from(json['data'] as Map? ?? {});
    return PetApiResponseModel(
      success: json['success'] == true,
      message: json['message'] as String? ?? '',
      pet: PetModel.fromJson(Map<String, dynamic>.from(data['pet'] as Map)),
    );
  }

  final bool success;
  final String message;
  final PetModel pet;
}

class PetModel {
  const PetModel({
    required this.id,
    required this.name,
    required this.ageYears,
    required this.weightKg,
    required this.petType,
    required this.vaccinationStatus,
    this.imageDataUrl,
  });

  factory PetModel.fromJson(Map<String, dynamic> json) {
    return PetModel(
      id: json['id'] as String? ?? '',
      name: json['name'] as String? ?? '',
      ageYears: (json['ageYears'] as num?)?.round() ?? 0,
      weightKg: (json['weightKg'] as num?)?.toDouble() ?? 0,
      petType: json['petType'] as String? ?? 'dog',
      vaccinationStatus: json['vaccinationStatus'] as String? ?? 'unknown',
      imageDataUrl: json['imageDataUrl'] as String?,
    );
  }

  final String id;
  final String name;
  final int ageYears;
  final double weightKg;
  final String petType;
  final String vaccinationStatus;
  final String? imageDataUrl;

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'ageYears': ageYears,
    'weightKg': weightKg,
    'petType': petType,
    'vaccinationStatus': vaccinationStatus,
    if (imageDataUrl != null && imageDataUrl!.isNotEmpty)
      'imageDataUrl': imageDataUrl,
  };

  Pet toEntity() {
    return Pet(
      id: id,
      name: name,
      breed: _petTypeLabel(petType),
      ageLabel: '$ageYears tuổi',
      weightLabel: '${_formatWeight(weightKg)}kg',
      gender: PetGender.female,
      healthStatus: vaccinationStatus == 'needs_booster'
          ? PetHealthStatus.needsRevisit
          : PetHealthStatus.good,
      reminderLabel: _vaccinationLabel(vaccinationStatus),
      imagePlaceholderColor: 0xFFD4E4E8,
      imageUrl: imageDataUrl,
      ageYears: ageYears,
      weightKg: weightKg,
      petType: petType,
      vaccinationStatus: vaccinationStatus,
    );
  }

  static String _formatWeight(double value) {
    if (value == value.roundToDouble()) {
      return value.toStringAsFixed(0);
    }
    return value.toStringAsFixed(1);
  }

  static String _vaccinationLabel(String status) {
    return switch (status) {
      'vaccinated' => 'Đã tiêm phòng',
      'not_vaccinated' => 'Chưa tiêm phòng',
      'needs_booster' => 'Cần tiêm nhắc',
      _ => 'Chưa rõ mũi chích',
    };
  }

  static String _petTypeLabel(String petType) {
    return switch (petType) {
      'cat' => 'Mèo',
      'rabbit' => 'Thỏ',
      'bird' => 'Chim',
      _ => 'Chó',
    };
  }
}
