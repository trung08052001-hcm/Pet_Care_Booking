import 'package:app/core/common/typedefs.dart';
import 'package:app/core/error/app_error.dart' show Failure, FailureMapper;
import 'package:app/features/booking/data/datasources/booking_detail_local_data_source.dart';
import 'package:app/features/booking/domain/entities/booking_detail.dart';
import 'package:app/features/booking/domain/entities/booking_detail_status.dart';
import 'package:app/features/booking/domain/repositories/booking_detail_repository.dart';
import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';

@LazySingleton(as: BookingDetailRepository)
class BookingDetailRepositoryImpl implements BookingDetailRepository {
  BookingDetailRepositoryImpl(this._localDataSource);

  final BookingDetailLocalDataSource _localDataSource;

  @override
  ResultFuture<BookingDetail> getBookingDetail(String bookingId) async {
    try {
      await Future<void>.delayed(const Duration(milliseconds: 150));
      final detail = _localDataSource.getById(bookingId);
      if (detail == null) {
        return const Left(
          Failure(message: 'Không tìm thấy lịch hẹn.'),
        );
      }
      return Right(detail);
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
  ResultFuture<BookingDetail> updateBookingStatus({
    required String bookingId,
    required BookingDetailStatus status,
  }) async {
    try {
      final existing = _localDataSource.getById(bookingId);
      if (existing == null) {
        return const Left(
          Failure(message: 'Không tìm thấy lịch hẹn.'),
        );
      }
      final updated = existing.copyWith(status: status);
      _localDataSource.update(updated);
      return Right(updated);
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
