import 'dart:async';

import 'package:app/core/network/network_info.dart';
import 'package:app/features/pets/data/datasources/pets_local_data_source.dart';
import 'package:app/features/pets/data/datasources/pets_remote_data_source.dart';
import 'package:app/features/pets/data/models/pet_models.dart';
import 'package:connectivity_plus/connectivity_plus.dart';

class PetSyncService {
  PetSyncService(
    this._localDataSource,
    this._remoteDataSource,
    this._networkInfo,
    this._connectivity,
  );

  final PetsLocalDataSource _localDataSource;
  final PetsRemoteDataSource _remoteDataSource;
  final NetworkInfo _networkInfo;
  final Connectivity _connectivity;

  StreamSubscription<List<ConnectivityResult>>? _subscription;
  bool _isSyncing = false;

  void start() {
    _subscription ??= _connectivity.onConnectivityChanged.listen((_) {
      syncPendingPets();
    });
    syncPendingPets();
  }

  Future<void> dispose() async {
    await _subscription?.cancel();
    _subscription = null;
  }

  Future<void> syncPendingPets() async {
    if (_isSyncing || !await _networkInfo.isConnected) {
      return;
    }

    _isSyncing = true;
    try {
      final drafts = _localDataSource.getPendingDrafts();
      for (final draft in drafts) {
        final localId = draft['id'] as String? ?? '';
        if (localId.isEmpty) {
          continue;
        }

        final remotePet = await _remoteDataSource.createPet(
          CreatePetRequestModel(
            name: draft['name'] as String? ?? '',
            ageYears: (draft['ageYears'] as num?)?.round() ?? 0,
            weightKg: (draft['weightKg'] as num?)?.toDouble() ?? 0,
            petType: draft['petType'] as String? ?? 'dog',
            vaccinationStatus:
                draft['vaccinationStatus'] as String? ?? 'unknown',
            imageDataUrl: draft['imageDataUrl'] as String?,
          ),
        );
        await _localDataSource.markDraftSynced(
          localId: localId,
          remotePet: remotePet,
        );
      }
    } finally {
      _isSyncing = false;
    }
  }
}
