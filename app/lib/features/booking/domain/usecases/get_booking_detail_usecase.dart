import 'package:app/core/common/typedefs.dart';
import 'package:app/core/usecase/usecase.dart';
import 'package:app/features/booking/domain/entities/booking_detail.dart';
import 'package:app/features/booking/domain/repositories/booking_detail_repository.dart';
import 'package:injectable/injectable.dart';

@injectable
class GetBookingDetailUseCase implements UseCase<BookingDetail, String> {
  GetBookingDetailUseCase(this._repository);

  final BookingDetailRepository _repository;

  @override
  ResultFuture<BookingDetail> call(String bookingId) {
    return _repository.getBookingDetail(bookingId);
  }
}
