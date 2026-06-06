import 'dart:async';

import 'package:app/core/common/typedefs.dart';
import 'package:app/core/error/app_error.dart' show Failure, FailureMapper;
import 'package:app/core/network/api_service.dart';
import 'package:app/features/booking/data/datasources/booking_detail_local_data_source.dart';
import 'package:app/core/network/network_info.dart';
import 'package:app/features/booking/data/datasources/booking_local_data_source.dart';
import 'package:app/features/booking/domain/entities/booking_detail.dart';
import 'package:app/features/booking/domain/entities/booking_detail_status.dart';
import 'package:app/features/booking/domain/repositories/booking_detail_repository.dart';
import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';

@LazySingleton(as: BookingDetailRepository)
class BookingDetailRepositoryImpl implements BookingDetailRepository {
  BookingDetailRepositoryImpl(
    this._localDataSource, [
    this._apiService,
    this._networkInfo,
    this._bookingLocalDataSource,
  ]);

  final BookingDetailLocalDataSource _localDataSource;
  final AppApiService? _apiService;
  final NetworkInfo? _networkInfo;
  final BookingLocalDataSource? _bookingLocalDataSource;

  @override
  ResultFuture<BookingDetail> getBookingDetail(String bookingId) async {
    try {
      final apiService = _apiService;
      if (apiService != null) {
        final networkInfo = _networkInfo;
        if (networkInfo != null && !await networkInfo.isConnected) {
          final cached = _bookingLocalDataSource?.getCachedBooking(bookingId);
          if (cached != null) {
            return Right(cached.toEntity());
          }
        }
        try {
          final response = await apiService
              .getBooking(bookingId)
              .timeout(const Duration(seconds: 4));
          await _bookingLocalDataSource?.saveBooking(response.booking);
          return Right(response.booking.toEntity());
        } on Exception {
          final cached = _bookingLocalDataSource?.getCachedBooking(bookingId);
          if (cached != null) {
            return Right(cached.toEntity());
          }
          rethrow;
        }
      }

      await Future<void>.delayed(const Duration(milliseconds: 150));
      final detail = _localDataSource.getById(bookingId);
      if (detail == null) {
        return const Left(Failure(message: 'Không tìm thấy lịch hẹn.'));
      }
      return Right(detail);
    } on Exception catch (exception, stackTrace) {
      return Left(
        FailureMapper.fromException(exception, stackTrace: stackTrace),
      );
    }
  }

  @override
  ResultFuture<BookingDetail> updateBookingStatus({
    required String bookingId,
    required BookingDetailStatus status,
  }) async {
    try {
      final apiService = _apiService;
      if (apiService != null && status == BookingDetailStatus.cancelled) {
        final networkInfo = _networkInfo;
        if (networkInfo != null && !await networkInfo.isConnected) {
          return const Left(
            Failure(
              message: 'Bạn cần kết nối mạng để hủy lịch hẹn trên server.',
            ),
          );
        }
        final response = await apiService.cancelBooking(bookingId);
        await _bookingLocalDataSource?.saveBooking(response.booking);
        return Right(response.booking.toEntity());
      }

      final existing = _localDataSource.getById(bookingId);
      if (existing == null) {
        return const Left(Failure(message: 'Không tìm thấy lịch hẹn.'));
      }
      final updated = existing.copyWith(status: status);
      _localDataSource.update(updated);
      return Right(updated);
    } on Exception catch (exception, stackTrace) {
      return Left(
        FailureMapper.fromException(exception, stackTrace: stackTrace),
      );
    }
  }
}
