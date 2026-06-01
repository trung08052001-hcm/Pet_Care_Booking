import 'package:app/features/booking/domain/entities/booking_detail.dart';
import 'package:equatable/equatable.dart';

enum BookingDetailPageStatus {
  initial,
  loading,
  success,
  failure,
  cancelling,
}

class BookingDetailState extends Equatable {
  const BookingDetailState({
    this.status = BookingDetailPageStatus.initial,
    this.detail,
    this.message,
    this.showCancelSuccess = false,
    this.showSupportSnack = false,
    this.showShareSnack = false,
  });

  final BookingDetailPageStatus status;
  final BookingDetail? detail;
  final String? message;
  final bool showCancelSuccess;
  final bool showSupportSnack;
  final bool showShareSnack;

  bool get isLoading =>
      status == BookingDetailPageStatus.loading ||
      status == BookingDetailPageStatus.initial;

  bool get isCancelling => status == BookingDetailPageStatus.cancelling;

  BookingDetailState copyWith({
    BookingDetailPageStatus? status,
    BookingDetail? detail,
    String? message,
    bool? showCancelSuccess,
    bool? showSupportSnack,
    bool? showShareSnack,
    bool clearMessage = false,
    bool clearSnacks = false,
  }) {
    return BookingDetailState(
      status: status ?? this.status,
      detail: detail ?? this.detail,
      message: clearMessage ? null : (message ?? this.message),
      showCancelSuccess: clearSnacks
          ? false
          : (showCancelSuccess ?? this.showCancelSuccess),
      showSupportSnack:
          clearSnacks ? false : (showSupportSnack ?? this.showSupportSnack),
      showShareSnack:
          clearSnacks ? false : (showShareSnack ?? this.showShareSnack),
    );
  }

  @override
  List<Object?> get props => [
        status,
        detail,
        message,
        showCancelSuccess,
        showSupportSnack,
        showShareSnack,
      ];
}
