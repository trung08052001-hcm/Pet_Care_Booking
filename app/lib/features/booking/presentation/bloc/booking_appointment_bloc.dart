import 'package:app/features/booking/domain/usecases/get_appointment_page_content_usecase.dart';
import 'package:app/features/booking/presentation/bloc/booking_appointment_event.dart';
import 'package:app/features/booking/presentation/bloc/booking_appointment_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

@injectable
class BookingAppointmentBloc
    extends Bloc<BookingAppointmentEvent, BookingAppointmentState> {
  BookingAppointmentBloc(this._getAppointmentPageContentUseCase)
      : super(const BookingAppointmentState()) {
    on<BookingAppointmentStarted>(_onStarted);
    on<BookingAppointmentDateSelected>(_onDateSelected);
    on<BookingAppointmentTimeSlotSelected>(_onTimeSlotSelected);
    on<BookingAppointmentConfirmPressed>(_onConfirmPressed);
  }

  final GetAppointmentPageContentUseCase _getAppointmentPageContentUseCase;

  Future<void> _onStarted(
    BookingAppointmentStarted event,
    Emitter<BookingAppointmentState> emit,
  ) async {
    emit(
      state.copyWith(
        status: BookingAppointmentStatus.loading,
        petId: event.petId,
        serviceIds: event.serviceIds,
        totalVnd: event.totalVnd,
        clearMessage: true,
        clearTimeSlot: true,
      ),
    );

    final result = await _getAppointmentPageContentUseCase(
      GetAppointmentPageContentParams(
        petId: event.petId,
        serviceIds: event.serviceIds,
      ),
    );

    result.fold(
      (failure) => emit(
        state.copyWith(
          status: BookingAppointmentStatus.failure,
          message: failure.message,
        ),
      ),
      (content) {
        final defaultDate = content.days.length > 1
            ? content.days[1].date
            : content.days.first.date;
        final selectedDate = event.initialDate ?? defaultDate;
        final initialSlotId = event.initialTimeSlotId;

        emit(
          state.copyWith(
            status: BookingAppointmentStatus.success,
            content: content,
            selectedDate: selectedDate,
            selectedTimeSlotId: initialSlotId,
            clearMessage: true,
          ),
        );
      },
    );
  }

  void _onDateSelected(
    BookingAppointmentDateSelected event,
    Emitter<BookingAppointmentState> emit,
  ) {
    emit(
      state.copyWith(
        selectedDate: event.date,
        clearTimeSlot: true,
      ),
    );
  }

  void _onTimeSlotSelected(
    BookingAppointmentTimeSlotSelected event,
    Emitter<BookingAppointmentState> emit,
  ) {
    emit(state.copyWith(selectedTimeSlotId: event.slotId));
  }

  void _onConfirmPressed(
    BookingAppointmentConfirmPressed event,
    Emitter<BookingAppointmentState> emit,
  ) {
    if (!state.canConfirm) {
      return;
    }
  }
}
