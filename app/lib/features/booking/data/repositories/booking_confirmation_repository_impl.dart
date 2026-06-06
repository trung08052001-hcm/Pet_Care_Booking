import 'package:app/core/common/typedefs.dart';
import 'package:app/core/error/app_error.dart';
import 'package:app/core/network/api_service.dart';
import 'package:app/features/booking/data/datasources/booking_confirmation_mock_data_source.dart';
import 'package:app/features/booking/data/models/booking_api_models.dart';
import 'package:app/features/booking/domain/entities/booking_confirmation_content.dart';
import 'package:app/features/booking/domain/entities/booking_confirmation_request.dart';
import 'package:app/features/booking/domain/repositories/booking_confirmation_repository.dart';
import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';

@LazySingleton(as: BookingConfirmationRepository)
class BookingConfirmationRepositoryImpl implements BookingConfirmationRepository {
  BookingConfirmationRepositoryImpl(this._mockDataSource, [this._apiService]);

  final BookingConfirmationMockDataSource _mockDataSource;
  final AppApiService? _apiService;

  @override
  ResultFuture<BookingConfirmationContent> getConfirmationContent(
    BookingConfirmationRequest request,
  ) async {
    try {
      await Future<void>.delayed(const Duration(milliseconds: 200));
      return Right(_mockDataSource.buildContent(request));
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
  ResultFuture<String> submitBooking(
    BookingConfirmationRequest request,
  ) async {
    try {
      final apiService = _apiService;
      if (apiService != null) {
        final response = await apiService.createBooking(
          CreateBookingRequestModel(request).toJson(),
        );
        return Right(response.booking.id);
      }

      final reference = await _mockDataSource.submitBooking(request);
      return Right(reference);
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
