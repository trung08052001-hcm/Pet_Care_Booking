import 'package:app/core/common/typedefs.dart';
import 'package:app/core/error/app_error.dart';
import 'package:app/features/profile/data/datasources/profile_mock_data_source.dart';
import 'package:app/features/profile/domain/entities/profile_page_content.dart';
import 'package:app/features/profile/domain/repositories/profile_repository.dart';
import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';

@LazySingleton(as: ProfileRepository)
class ProfileRepositoryImpl implements ProfileRepository {
  ProfileRepositoryImpl(this._mockDataSource);

  final ProfileMockDataSource _mockDataSource;

  @override
  ResultFuture<ProfilePageContent> getProfilePageContent() async {
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
