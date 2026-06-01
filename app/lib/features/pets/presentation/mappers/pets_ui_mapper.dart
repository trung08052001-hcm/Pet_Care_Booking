import 'package:app/app/theme/app_colors.dart';
import 'package:app/features/pets/domain/entities/pet_gender.dart';
import 'package:flutter/material.dart';

abstract final class PetsUiMapper {
  static Color genderBadgeColor(PetGender gender) {
    return switch (gender) {
      PetGender.female => AppColors.brown,
      PetGender.male => const Color(0xFF9E9E9E),
    };
  }

  static IconData genderIcon(PetGender gender) {
    return switch (gender) {
      PetGender.female => Icons.female_rounded,
      PetGender.male => Icons.male_rounded,
    };
  }

  static Color placeholderColor(int argb) => Color(argb);
}
