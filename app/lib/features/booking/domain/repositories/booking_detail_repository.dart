import 'package:app/core/common/typedefs.dart';
import 'package:app/features/booking/domain/entities/booking_detail.dart';
import 'package:app/features/booking/domain/entities/booking_detail_status.dart';

abstract interface class BookingDetailRepository {
  ResultFuture<BookingDetail> getBookingDetail(String bookingId);

  ResultFuture<BookingDetail> updateBookingStatus({
    required String bookingId,
    required BookingDetailStatus status,
  });
}
