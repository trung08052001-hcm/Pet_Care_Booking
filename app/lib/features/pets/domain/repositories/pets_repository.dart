import 'package:app/core/common/typedefs.dart';
import 'package:app/features/pets/domain/entities/my_pets_page_content.dart';
import 'package:app/features/pets/domain/entities/pet.dart';

abstract interface class PetsRepository {
  ResultFuture<MyPetsPageContent> getMyPetsPageContent();

  ResultFuture<Pet> createPet({
    required String name,
    required int ageYears,
    required double weightKg,
    required String petType,
    required String vaccinationStatus,
    String? imageDataUrl,
  });
}
