import 'package:app/core/common/typedefs.dart';
import 'package:app/core/error/app_error.dart';
import 'package:app/features/pets/data/datasources/pets_mock_data_source.dart';
import 'package:app/features/pets/domain/entities/my_pets_page_content.dart';
import 'package:app/features/pets/domain/repositories/pets_repository.dart';
import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';

@LazySingleton(as: PetsRepository)
class PetsRepositoryImpl implements PetsRepository {
  PetsRepositoryImpl(this._mockDataSource);

  final PetsMockDataSource _mockDataSource;

  @override
  ResultFuture<MyPetsPageContent> getMyPetsPageContent() async {
    try {
      await Future<void>.delayed(const Duration(milliseconds: 250));
      return Right(_mockDataSource.getPageContent());
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
