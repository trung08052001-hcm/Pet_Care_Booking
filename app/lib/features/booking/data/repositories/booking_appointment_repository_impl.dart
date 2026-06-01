import 'package:app/core/common/typedefs.dart';
import 'package:app/core/error/app_error.dart';
import 'package:app/features/booking/data/datasources/booking_appointment_mock_data_source.dart';
import 'package:app/features/booking/domain/entities/appointment_page_content.dart';
import 'package:app/features/booking/domain/repositories/booking_appointment_repository.dart';
import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';

@LazySingleton(as: BookingAppointmentRepository)
class BookingAppointmentRepositoryImpl implements BookingAppointmentRepository {
  BookingAppointmentRepositoryImpl(this._mockDataSource);

  final BookingAppointmentMockDataSource _mockDataSource;

  @override
  ResultFuture<AppointmentPageContent> getAppointmentPageContent({
    required String petId,
    required List<String> serviceIds,
  }) async {
    try {
      await Future<void>.delayed(const Duration(milliseconds: 200));
      return Right(
        _mockDataSource.getPageContent(
          petId: petId,
          serviceIds: serviceIds,
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
}
