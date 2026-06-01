import 'package:app/core/common/typedefs.dart';
import 'package:app/features/booking/domain/entities/appointment_page_content.dart';

abstract interface class BookingAppointmentRepository {
  ResultFuture<AppointmentPageContent> getAppointmentPageContent({
    required String petId,
    required List<String> serviceIds,
  });
}
