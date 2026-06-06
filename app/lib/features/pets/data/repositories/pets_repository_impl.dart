import 'package:app/core/common/typedefs.dart';
import 'package:app/core/error/app_error.dart';
import 'package:app/core/network/network_info.dart';
import 'package:app/features/pets/data/datasources/pets_mock_data_source.dart';
import 'package:app/features/pets/data/datasources/pets_remote_data_source.dart';
import 'package:app/features/pets/data/models/pet_models.dart';
import 'package:app/features/pets/domain/entities/my_pets_page_content.dart';
import 'package:app/features/pets/domain/entities/pet.dart';
import 'package:app/features/pets/domain/repositories/pets_repository.dart';
import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';

@LazySingleton(as: PetsRepository)
class PetsRepositoryImpl implements PetsRepository {
  PetsRepositoryImpl(
    this._mockDataSource, [
    this._remoteDataSource,
    this._networkInfo,
  ]);

  final PetsMockDataSource _mockDataSource;
  final PetsRemoteDataSource? _remoteDataSource;
  final NetworkInfo? _networkInfo;

  @override
  ResultFuture<MyPetsPageContent> getMyPetsPageContent() async {
    try {
      final remoteDataSource = _remoteDataSource;
      final networkInfo = _networkInfo;

      if (remoteDataSource == null || networkInfo == null) {
        await Future<void>.delayed(const Duration(milliseconds: 250));
        return Right(_mockDataSource.getPageContent());
      }

      if (!await networkInfo.isConnected) {
        return const Left(Failure(message: 'No internet connection.'));
      }

      final pets = await remoteDataSource.getPets();
      return Right(
        _mockDataSource.getPageContent(
          pets: pets.map((pet) => pet.toEntity()).toList(),
        ),
      );
    } on Exception catch (exception, stackTrace) {
      return Left(
        FailureMapper.fromException(
          exception,
          stackTrace: stackTrace,
        ),
      );
    }
  }

  @override
  ResultFuture<Pet> createPet({
    required String name,
    required int ageYears,
    required double weightKg,
    required String petType,
    required String vaccinationStatus,
    String? imageDataUrl,
  }) async {
    try {
      final remoteDataSource = _remoteDataSource;
      final networkInfo = _networkInfo;

      if (remoteDataSource == null || networkInfo == null) {
        return const Left(Failure(message: 'Pet API is not configured.'));
      }

      if (!await networkInfo.isConnected) {
        return const Left(Failure(message: 'No internet connection.'));
      }

      final pet = await remoteDataSource.createPet(
        CreatePetRequestModel(
          name: name.trim(),
          ageYears: ageYears,
          weightKg: weightKg,
          petType: petType,
          vaccinationStatus: vaccinationStatus,
          imageDataUrl: imageDataUrl,
        ),
      );
      return Right(pet.toEntity());
    } on Exception catch (exception, stackTrace) {
      return Left(
        FailureMapper.fromException(
          exception,
          stackTrace: stackTrace,
        ),
      );
    }
  }
}
