import 'package:equatable/equatable.dart';

sealed class BookingDetailEvent extends Equatable {
  const BookingDetailEvent();

  @override
  List<Object?> get props => const [];
}

final class BookingDetailStarted extends BookingDetailEvent {
  const BookingDetailStarted(this.bookingId);

  final String bookingId;

  @override
  List<Object?> get props => [bookingId];
}

final class BookingDetailCancelPressed extends BookingDetailEvent {
  const BookingDetailCancelPressed();
}

final class BookingDetailSupportPressed extends BookingDetailEvent {
  const BookingDetailSupportPressed();
}

final class BookingDetailSharePressed extends BookingDetailEvent {
  const BookingDetailSharePressed();
}
