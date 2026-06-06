import 'package:app/core/common/typedefs.dart';
import 'package:app/core/usecase/usecase.dart';
import 'package:app/features/pets/domain/entities/pet.dart';
import 'package:app/features/pets/domain/repositories/pets_repository.dart';

class CreatePetParams {
  const CreatePetParams({
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
}

class CreatePetUseCase implements UseCase<Pet, CreatePetParams> {
  const CreatePetUseCase(this._repository);

  final PetsRepository _repository;

  @override
  ResultFuture<Pet> call(CreatePetParams params) {
    return _repository.createPet(
      name: params.name,
      ageYears: params.ageYears,
      weightKg: params.weightKg,
      petType: params.petType,
      vaccinationStatus: params.vaccinationStatus,
      imageDataUrl: params.imageDataUrl,
    );
  }
}
