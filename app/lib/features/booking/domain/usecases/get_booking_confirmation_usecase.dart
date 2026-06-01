import 'package:app/core/common/typedefs.dart';
import 'package:app/core/usecase/usecase.dart';
import 'package:app/features/booking/domain/entities/booking_confirmation_content.dart';
import 'package:app/features/booking/domain/entities/booking_confirmation_request.dart';
import 'package:app/features/booking/domain/repositories/booking_confirmation_repository.dart';
import 'package:injectable/injectable.dart';

@injectable
class GetBookingConfirmationUseCase
    implements UseCase<BookingConfirmationContent, BookingConfirmationRequest> {
  GetBookingConfirmationUseCase(this._repository);

  final BookingConfirmationRepository _repository;

  @override
  ResultFuture<BookingConfirmationContent> call(
    BookingConfirmationRequest params,
  ) {
    return _repository.getConfirmationContent(params);
  }
}
