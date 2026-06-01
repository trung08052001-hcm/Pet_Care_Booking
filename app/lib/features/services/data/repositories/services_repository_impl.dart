import 'package:app/core/common/typedefs.dart';
import 'package:app/core/error/app_error.dart';
import 'package:app/features/services/data/datasources/services_mock_data_source.dart';
import 'package:app/features/services/domain/entities/services_page_content.dart';
import 'package:app/features/services/domain/repositories/services_repository.dart';
import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';

@LazySingleton(as: ServicesRepository)
class ServicesRepositoryImpl implements ServicesRepository {
  ServicesRepositoryImpl(this._mockDataSource);

  final ServicesMockDataSource _mockDataSource;

  @override
  ResultFuture<ServicesPageContent> getServicesPageContent() async {
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
