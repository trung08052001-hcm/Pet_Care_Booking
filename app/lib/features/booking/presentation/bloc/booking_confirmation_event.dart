import 'package:app/features/booking/domain/entities/booking_confirmation_request.dart';
import 'package:equatable/equatable.dart';

sealed class BookingConfirmationEvent extends Equatable {
  const BookingConfirmationEvent();

  @override
  List<Object?> get props => const [];
}

final class BookingConfirmationStarted extends BookingConfirmationEvent {
  const BookingConfirmationStarted(this.request);

  final BookingConfirmationRequest request;

  @override
  List<Object?> get props => [request];
}

final class BookingConfirmationCompletePressed extends BookingConfirmationEvent {
  const BookingConfirmationCompletePressed();
}

final class BookingConfirmationChangePaymentPressed extends BookingConfirmationEvent {
  const BookingConfirmationChangePaymentPressed();
}
