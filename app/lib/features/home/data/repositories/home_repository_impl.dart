import 'package:app/core/common/typedefs.dart';
import 'package:app/core/error/app_error.dart';
import 'package:app/features/home/data/datasources/home_mock_data_source.dart';
import 'package:app/features/home/domain/entities/home_dashboard.dart';
import 'package:app/features/home/domain/repositories/home_repository.dart';
import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';

@LazySingleton(as: HomeRepository)
class HomeRepositoryImpl implements HomeRepository {
  HomeRepositoryImpl(this._mockDataSource);

  final HomeMockDataSource _mockDataSource;

  @override
  ResultFuture<HomeDashboard> getHomeDashboard() async {
    try {
      await Future<void>.delayed(const Duration(milliseconds: 250));
      return Right(_mockDataSource.getDashboard());
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
