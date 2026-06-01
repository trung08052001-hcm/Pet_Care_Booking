import 'package:app/features/booking/domain/entities/booking_detail.dart';
import 'package:injectable/injectable.dart';

@lazySingleton
class BookingDetailLocalDataSource {
  final Map<String, BookingDetail> _bookings = {};

  void save(BookingDetail detail) {
    _bookings[detail.id] = detail;
  }

  BookingDetail? getById(String id) => _bookings[id];

  void update(BookingDetail detail) {
    _bookings[detail.id] = detail;
  }
}
