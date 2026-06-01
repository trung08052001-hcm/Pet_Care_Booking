import 'package:app/features/booking/domain/entities/booking_confirmation_content.dart';
import 'package:equatable/equatable.dart';

enum BookingConfirmationStatus {
  initial,
  loading,
  success,
  failure,
  submitting,
  completed,
}

class BookingConfirmationState extends Equatable {
  const BookingConfirmationState({
    this.status = BookingConfirmationStatus.initial,
    this.content,
    this.bookingReference,
    this.message,
  });

  final BookingConfirmationStatus status;
  final BookingConfirmationContent? content;
  final String? bookingReference;
  final String? message;

  bool get isLoading =>
      status == BookingConfirmationStatus.loading ||
      status == BookingConfirmationStatus.initial;

  bool get isSubmitting => status == BookingConfirmationStatus.submitting;

  BookingConfirmationState copyWith({
    BookingConfirmationStatus? status,
    BookingConfirmationContent? content,
    String? bookingReference,
    String? message,
    bool clearMessage = false,
  }) {
    return BookingConfirmationState(
      status: status ?? this.status,
      content: content ?? this.content,
      bookingReference: bookingReference ?? this.bookingReference,
      message: clearMessage ? null : (message ?? this.message),
    );
  }

  @override
  List<Object?> get props => [status, content, bookingReference, message];
}
