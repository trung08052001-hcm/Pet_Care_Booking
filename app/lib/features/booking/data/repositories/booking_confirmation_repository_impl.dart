import 'dart:async';

import 'package:app/core/common/typedefs.dart';
import 'package:app/core/error/app_error.dart';
import 'package:app/core/network/api_service.dart';
import 'package:app/core/network/network_info.dart';
import 'package:app/features/booking/data/datasources/booking_confirmation_mock_data_source.dart';
import 'package:app/features/booking/data/models/booking_api_models.dart';
import 'package:app/features/booking/domain/entities/booking_confirmation_content.dart';
import 'package:app/features/booking/domain/entities/booking_confirmation_request.dart';
import 'package:app/features/booking/domain/repositories/booking_confirmation_repository.dart';
import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';

@LazySingleton(as: BookingConfirmationRepository)
class BookingConfirmationRepositoryImpl
    implements BookingConfirmationRepository {
  BookingConfirmationRepositoryImpl(
    this._mockDataSource, [
    this._apiService,
    this._networkInfo,
  ]);

  final BookingConfirmationMockDataSource _mockDataSource;
  final AppApiService? _apiService;
  final NetworkInfo? _networkInfo;

  @override
  ResultFuture<BookingConfirmationContent> getConfirmationContent(
    BookingConfirmationRequest request,
  ) async {
    try {
      await Future<void>.delayed(const Duration(milliseconds: 200));
      return Right(_mockDataSource.buildContent(request));
    } on Exception catch (exception, stackTrace) {
      return Left(
        FailureMapper.fromException(exception, stackTrace: stackTrace),
      );
    }
  }

  @override
  ResultFuture<String> submitBooking(BookingConfirmationRequest request) async {
    try {
      final apiService = _apiService;
      if (apiService != null) {
        final networkInfo = _networkInfo;
        if (networkInfo != null && !await networkInfo.isConnected) {
          return const Left(
            Failure(
              message:
                  'Bạn cần kết nối mạng để xác nhận lịch hẹn. Slot phải được kiểm tra với server.',
            ),
          );
        }
        final response = await apiService
            .createBooking(CreateBookingRequestModel(request).toJson())
            .timeout(const Duration(seconds: 10));
        return Right(response.booking.id);
      }

      final reference = await _mockDataSource.submitBooking(request);
      return Right(reference);
    } on TimeoutException {
      return const Left(
        Failure(
          message:
              'API đặt lịch phản hồi chậm. Vui lòng kiểm tra backend hoặc thử lại.',
        ),
      );
    } on Exception catch (exception, stackTrace) {
      return Left(
        FailureMapper.fromException(exception, stackTrace: stackTrace),
      );
    }
  }
}
