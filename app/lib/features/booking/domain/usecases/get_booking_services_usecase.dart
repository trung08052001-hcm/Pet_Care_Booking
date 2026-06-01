import 'package:app/core/common/typedefs.dart';
import 'package:app/core/usecase/usecase.dart';
import 'package:app/features/booking/domain/entities/booking_service_page_content.dart';
import 'package:app/features/booking/domain/repositories/booking_service_repository.dart';
import 'package:injectable/injectable.dart';

@injectable
class GetBookingServicesUseCase
    implements UseCase<BookingServicePageContent, NoParams> {
  GetBookingServicesUseCase(this._repository);

  final BookingServiceRepository _repository;

  @override
  ResultFuture<BookingServicePageContent> call(NoParams params) {
    return _repository.getBookingServicePageContent();
  }
}
