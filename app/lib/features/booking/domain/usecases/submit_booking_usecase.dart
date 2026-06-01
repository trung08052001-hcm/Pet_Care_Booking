import 'package:app/core/common/typedefs.dart';
import 'package:app/core/usecase/usecase.dart';
import 'package:app/features/booking/domain/entities/booking_confirmation_request.dart';
import 'package:app/features/booking/domain/repositories/booking_confirmation_repository.dart';
import 'package:injectable/injectable.dart';

@injectable
class SubmitBookingUseCase
    implements UseCase<String, BookingConfirmationRequest> {
  SubmitBookingUseCase(this._repository);

  final BookingConfirmationRepository _repository;

  @override
  ResultFuture<String> call(BookingConfirmationRequest params) {
    return _repository.submitBooking(params);
  }
}
