import 'package:app/core/local/hive_box_names.dart';
import 'package:app/core/local/hive_local_store.dart';
import 'package:app/features/booking/data/models/booking_api_models.dart';

class BookingLocalDataSource {
  const BookingLocalDataSource(this._store);

  static const String _availabilityPrefix = 'availability';

  final HiveLocalStore _store;

  Future<void> saveAvailability({
    required String from,
    required String to,
    required List<BookedSlotModel> slots,
  }) {
    return _store.putMap(
      boxName: HiveBoxNames.bookingCache,
      key: _availabilityKey(from: from, to: to),
      value: {
        'slots': slots.map((slot) => slot.toJson()).toList(),
        'cachedAt': DateTime.now().toIso8601String(),
      },
    );
  }

  List<BookedSlotModel> getAvailability({
    required String from,
    required String to,
  }) {
    final cached = _store.getMap(
      boxName: HiveBoxNames.bookingCache,
      key: _availabilityKey(from: from, to: to),
    );
    final rawSlots = cached?['slots'] as List? ?? const [];
    return rawSlots
        .map(
          (item) =>
              BookedSlotModel.fromJson(Map<String, dynamic>.from(item as Map)),
        )
        .toList();
  }

  Future<void> saveBookings(List<BookingModel> bookings) async {
    await _store.putMap(
      boxName: HiveBoxNames.bookingCache,
      key: 'history',
      value: {
        'bookings': bookings.map((booking) => booking.toJson()).toList(),
        'cachedAt': DateTime.now().toIso8601String(),
      },
    );
    for (final booking in bookings) {
      await saveBooking(booking);
    }
  }

  List<BookingModel> getCachedBookings() {
    final cached = _store.getMap(
      boxName: HiveBoxNames.bookingCache,
      key: 'history',
    );
    final rawBookings = cached?['bookings'] as List? ?? const [];
    return rawBookings
        .map(
          (item) =>
              BookingModel.fromJson(Map<String, dynamic>.from(item as Map)),
        )
        .toList();
  }

  Future<void> saveBooking(BookingModel booking) {
    return _store.putMap(
      boxName: HiveBoxNames.bookingCache,
      key: 'detail:${booking.id}',
      value: booking.toJson(),
    );
  }

  BookingModel? getCachedBooking(String bookingId) {
    final cached = _store.getMap(
      boxName: HiveBoxNames.bookingCache,
      key: 'detail:$bookingId',
    );
    if (cached == null) {
      return null;
    }
    return BookingModel.fromJson(cached);
  }

  static String _availabilityKey({required String from, required String to}) =>
      '$_availabilityPrefix:$from:$to';
}
