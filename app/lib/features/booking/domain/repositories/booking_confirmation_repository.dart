import 'package:app/core/common/typedefs.dart';
import 'package:app/features/booking/domain/entities/booking_confirmation_content.dart';
import 'package:app/features/booking/domain/entities/booking_confirmation_request.dart';

abstract interface class BookingConfirmationRepository {
  ResultFuture<BookingConfirmationContent> getConfirmationContent(
    BookingConfirmationRequest request,
  );

  ResultFuture<String> submitBooking(BookingConfirmationRequest request);
}
