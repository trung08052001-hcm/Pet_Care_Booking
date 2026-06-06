import 'package:app/core/local/hive_box_names.dart';
import 'package:app/core/local/hive_local_store.dart';
import 'package:app/features/pets/data/models/pet_models.dart';

class PetsLocalDataSource {
  const PetsLocalDataSource(this._store);

  final HiveLocalStore _store;

  Future<void> savePets(List<PetModel> pets) async {
    await _store.clear(HiveBoxNames.pets);
    for (final pet in pets) {
      await _store.putMap(
        boxName: HiveBoxNames.pets,
        key: pet.id,
        value: pet.toJson(),
      );
    }
  }

  List<PetModel> getCachedPets() {
    return _store.values(HiveBoxNames.pets).map(PetModel.fromJson).toList();
  }

  Future<PetModel> saveDraft(CreatePetRequestModel request) async {
    final localId = 'local-pet-${DateTime.now().microsecondsSinceEpoch}';
    final draft = <String, dynamic>{
      ...request.toJson(),
      'id': localId,
      'syncStatus': 'pending',
      'createdAt': DateTime.now().toIso8601String(),
    };

    await _store.putMap(
      boxName: HiveBoxNames.petDrafts,
      key: localId,
      value: draft,
    );
    await _store.putMap(boxName: HiveBoxNames.pets, key: localId, value: draft);

    return PetModel.fromJson(draft);
  }

  List<Map<String, dynamic>> getPendingDrafts() {
    return _store
        .values(HiveBoxNames.petDrafts)
        .where((item) => item['syncStatus'] == 'pending')
        .toList();
  }

  Future<void> markDraftSynced({
    required String localId,
    required PetModel remotePet,
  }) async {
    await _store.delete(boxName: HiveBoxNames.petDrafts, key: localId);
    await _store.delete(boxName: HiveBoxNames.pets, key: localId);
    await _store.putMap(
      boxName: HiveBoxNames.pets,
      key: remotePet.id,
      value: remotePet.toJson(),
    );
  }
}
