import 'package:app/features/pets/domain/entities/pet.dart';
import 'package:app/features/pets/domain/entities/pet_promo_banner.dart';
import 'package:equatable/equatable.dart';

class MyPetsPageContent extends Equatable {
  const MyPetsPageContent({
    required this.title,
    required this.subtitle,
    required this.pets,
    required this.addPetLabel,
    required this.promoBanner,
  });

  final String title;
  final String subtitle;
  final List<Pet> pets;
  final String addPetLabel;
  final PetPromoBanner promoBanner;

  @override
  List<Object?> get props => [
        title,
        subtitle,
        pets,
        addPetLabel,
        promoBanner,
      ];
}
