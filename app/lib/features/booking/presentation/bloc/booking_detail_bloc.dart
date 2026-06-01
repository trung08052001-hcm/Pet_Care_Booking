import 'package:app/features/booking/domain/usecases/cancel_booking_usecase.dart';
import 'package:app/features/booking/domain/usecases/get_booking_detail_usecase.dart';
import 'package:app/features/booking/presentation/bloc/booking_detail_event.dart';
import 'package:app/features/booking/presentation/bloc/booking_detail_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

@injectable
class BookingDetailBloc extends Bloc<BookingDetailEvent, BookingDetailState> {
  BookingDetailBloc(
    this._getBookingDetailUseCase,
    this._cancelBookingUseCase,
  ) : super(const BookingDetailState()) {
    on<BookingDetailStarted>(_onStarted);
    on<BookingDetailCancelPressed>(_onCancelPressed);
    on<BookingDetailSupportPressed>(_onSupportPressed);
    on<BookingDetailSharePressed>(_onSharePressed);
  }

  final GetBookingDetailUseCase _getBookingDetailUseCase;
  final CancelBookingUseCase _cancelBookingUseCase;

  String? _bookingId;

  Future<void> _onStarted(
    BookingDetailStarted event,
    Emitter<BookingDetailState> emit,
  ) async {
    _bookingId = event.bookingId;
    emit(
      state.copyWith(
        status: BookingDetailPageStatus.loading,
        clearMessage: true,
        clearSnacks: true,
      ),
    );

    final result = await _getBookingDetailUseCase(event.bookingId);
    result.fold(
      (failure) => emit(
        state.copyWith(
          status: BookingDetailPageStatus.failure,
          message: failure.message,
        ),
      ),
      (detail) => emit(
        state.copyWith(
          status: BookingDetailPageStatus.success,
          detail: detail,
          clearMessage: true,
        ),
      ),
    );
  }

  Future<void> _onCancelPressed(
    BookingDetailCancelPressed event,
    Emitter<BookingDetailState> emit,
  ) async {
    final bookingId = _bookingId;
    if (bookingId == null) {
      return;
    }

    emit(
      state.copyWith(
        status: BookingDetailPageStatus.cancelling,
        clearSnacks: true,
      ),
    );

    final result = await _cancelBookingUseCase(bookingId);
    result.fold(
      (failure) => emit(
        state.copyWith(
          status: BookingDetailPageStatus.failure,
          message: failure.message,
        ),
      ),
      (detail) => emit(
        state.copyWith(
          status: BookingDetailPageStatus.success,
          detail: detail,
          showCancelSuccess: true,
        ),
      ),
    );
  }

  void _onSupportPressed(
    BookingDetailSupportPressed event,
    Emitter<BookingDetailState> emit,
  ) {
    emit(state.copyWith(clearSnacks: true));
    emit(state.copyWith(showSupportSnack: true));
  }

  void _onSharePressed(
    BookingDetailSharePressed event,
    Emitter<BookingDetailState> emit,
  ) {
    emit(state.copyWith(clearSnacks: true));
    emit(state.copyWith(showShareSnack: true));
  }
}
