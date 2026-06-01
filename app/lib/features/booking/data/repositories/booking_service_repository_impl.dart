import 'package:app/core/common/typedefs.dart';
import 'package:app/core/error/app_error.dart';
import 'package:app/features/booking/data/datasources/booking_service_mock_data_source.dart';
import 'package:app/features/booking/domain/entities/booking_service_page_content.dart';
import 'package:app/features/booking/domain/repositories/booking_service_repository.dart';
import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';

@LazySingleton(as: BookingServiceRepository)
class BookingServiceRepositoryImpl implements BookingServiceRepository {
  BookingServiceRepositoryImpl(this._mockDataSource);

  final BookingServiceMockDataSource _mockDataSource;

  @override
  ResultFuture<BookingServicePageContent> getBookingServicePageContent() async {
    try {
      await Future<void>.delayed(const Duration(milliseconds: 200));
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
