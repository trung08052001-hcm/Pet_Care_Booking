import 'package:app/core/common/typedefs.dart';
import 'package:app/features/booking/domain/entities/booking_service_page_content.dart';

abstract interface class BookingServiceRepository {
  ResultFuture<BookingServicePageContent> getBookingServicePageContent();
}
