import 'package:app/core/network/api_service.dart';
import 'package:app/features/pets/data/models/pet_models.dart';

abstract interface class PetsRemoteDataSource {
  Future<List<PetModel>> getPets();

  Future<PetModel> createPet(CreatePetRequestModel request);
}

class PetsRemoteDataSourceImpl implements PetsRemoteDataSource {
  const PetsRemoteDataSourceImpl(this._apiService);

  final AppApiService _apiService;

  @override
  Future<List<PetModel>> getPets() async {
    final response = await _apiService.getPets();
    return response.pets;
  }

  @override
  Future<PetModel> createPet(CreatePetRequestModel request) async {
    final response = await _apiService.createPet(request.toJson());
    return response.pet;
  }
}
