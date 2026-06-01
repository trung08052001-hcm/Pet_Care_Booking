import 'package:app/features/booking/domain/entities/booking_confirmation_request.dart';
import 'package:app/features/booking/domain/usecases/get_booking_confirmation_usecase.dart';
import 'package:app/features/booking/domain/usecases/submit_booking_usecase.dart';
import 'package:app/features/booking/presentation/bloc/booking_confirmation_event.dart';
import 'package:app/features/booking/presentation/bloc/booking_confirmation_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

@injectable
class BookingConfirmationBloc
    extends Bloc<BookingConfirmationEvent, BookingConfirmationState> {
  BookingConfirmationBloc(
    this._getBookingConfirmationUseCase,
    this._submitBookingUseCase,
  ) : super(const BookingConfirmationState()) {
    on<BookingConfirmationStarted>(_onStarted);
    on<BookingConfirmationCompletePressed>(_onCompletePressed);
  }

  final GetBookingConfirmationUseCase _getBookingConfirmationUseCase;
  final SubmitBookingUseCase _submitBookingUseCase;

  BookingConfirmationRequest? _request;

  Future<void> _onStarted(
    BookingConfirmationStarted event,
    Emitter<BookingConfirmationState> emit,
  ) async {
    _request = event.request;
    emit(
      state.copyWith(
        status: BookingConfirmationStatus.loading,
        clearMessage: true,
      ),
    );

    final result = await _getBookingConfirmationUseCase(event.request);
    result.fold(
      (failure) => emit(
        state.copyWith(
          status: BookingConfirmationStatus.failure,
          message: failure.message,
        ),
      ),
      (content) => emit(
        state.copyWith(
          status: BookingConfirmationStatus.success,
          content: content,
          clearMessage: true,
        ),
      ),
    );
  }

  Future<void> _onCompletePressed(
    BookingConfirmationCompletePressed event,
    Emitter<BookingConfirmationState> emit,
  ) async {
    final request = _request;
    if (request == null) {
      return;
    }

    emit(
      state.copyWith(
        status: BookingConfirmationStatus.submitting,
        clearMessage: true,
      ),
    );

    final result = await _submitBookingUseCase(request);
    result.fold(
      (failure) => emit(
        state.copyWith(
          status: BookingConfirmationStatus.failure,
          message: failure.message,
        ),
      ),
      (reference) => emit(
        state.copyWith(
          status: BookingConfirmationStatus.completed,
          bookingReference: reference,
          clearMessage: true,
        ),
      ),
    );
  }
}
