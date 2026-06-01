import 'package:app/features/booking/domain/entities/booking_step.dart';
import 'package:app/features/booking/presentation/bloc/booking_event.dart';
import 'package:app/features/booking/presentation/bloc/booking_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

@injectable
class BookingBloc extends Bloc<BookingEvent, BookingState> {
  BookingBloc() : super(const BookingState()) {
    on<BookingStarted>(_onStarted);
    on<BookingSearchQueryChanged>(_onSearchQueryChanged);
    on<BookingStepChanged>(_onStepChanged);
    on<BookingPetBookPressed>(_onPetBookPressed);
    on<BookingAddPetPressed>(_onAddPetPressed);
    on<BookingPetMoreOptionsPressed>(_onPetMoreOptionsPressed);
    on<BookingQuickAddPressed>(_onQuickAddPressed);
    on<BookingInteractionConsumed>(_onInteractionConsumed);
    on<BookingServicesConfirmed>(_onServicesConfirmed);
    on<BookingServiceStepBackPressed>(_onServiceStepBackPressed);
    on<BookingAppointmentConfirmed>(_onAppointmentConfirmed);
    on<BookingAppointmentStepBackPressed>(_onAppointmentStepBackPressed);
    on<BookingConfirmationStepBackPressed>(_onConfirmationStepBackPressed);
    on<BookingFlowCompleted>(_onFlowCompleted);
  }

  void _onStarted(BookingStarted event, Emitter<BookingState> emit) {
    emit(
      BookingState(serviceId: event.serviceId, currentStep: BookingStep.pet),
    );
  }

  void _onSearchQueryChanged(
    BookingSearchQueryChanged event,
    Emitter<BookingState> emit,
  ) {
    emit(state.copyWith(searchQuery: event.query));
  }

  void _onStepChanged(BookingStepChanged event, Emitter<BookingState> emit) {
    emit(state.copyWith(currentStep: event.step));
  }

  void _onPetBookPressed(
    BookingPetBookPressed event,
    Emitter<BookingState> emit,
  ) {
    emit(
      state.copyWith(
        selectedPetId: event.petId,
        currentStep: BookingStep.service,
        interaction: BookingInteraction.advanceToService,
      ),
    );
  }

  void _onAddPetPressed(
    BookingAddPetPressed event,
    Emitter<BookingState> emit,
  ) {
    emit(
      state.copyWith(
        interaction: BookingInteraction.addPet,
        clearSelectedPet: true,
      ),
    );
  }

  void _onPetMoreOptionsPressed(
    BookingPetMoreOptionsPressed event,
    Emitter<BookingState> emit,
  ) {
    emit(
      state.copyWith(
        selectedPetId: event.petId,
        interaction: BookingInteraction.petMoreOptions,
      ),
    );
  }

  void _onQuickAddPressed(
    BookingQuickAddPressed event,
    Emitter<BookingState> emit,
  ) {
    emit(
      state.copyWith(
        interaction: BookingInteraction.quickAddPet,
        clearSelectedPet: true,
      ),
    );
  }

  void _onInteractionConsumed(
    BookingInteractionConsumed event,
    Emitter<BookingState> emit,
  ) {
    emit(state.copyWith(interaction: BookingInteraction.none));
  }

  void _onServicesConfirmed(
    BookingServicesConfirmed event,
    Emitter<BookingState> emit,
  ) {
    emit(
      state.copyWith(
        selectedServiceIds: event.serviceIds,
        totalVnd: event.totalVnd,
        currentStep: BookingStep.appointment,
        interaction: BookingInteraction.none,
      ),
    );
  }

  void _onServiceStepBackPressed(
    BookingServiceStepBackPressed event,
    Emitter<BookingState> emit,
  ) {
    emit(
      state.copyWith(
        currentStep: BookingStep.pet,
        clearSelectedServices: true,
        totalVnd: 0,
        clearAppointment: true,
      ),
    );
  }

  void _onAppointmentConfirmed(
    BookingAppointmentConfirmed event,
    Emitter<BookingState> emit,
  ) {
    emit(
      state.copyWith(
        selectedAppointmentDate: event.appointmentDate,
        selectedTimeSlotId: event.timeSlotId,
        selectedTimeSlotLabel: event.timeSlotLabel,
        currentStep: BookingStep.confirmation,
      ),
    );
  }

  void _onAppointmentStepBackPressed(
    BookingAppointmentStepBackPressed event,
    Emitter<BookingState> emit,
  ) {
    emit(
      state.copyWith(
        currentStep: BookingStep.service,
        clearAppointment: true,
      ),
    );
  }

  void _onConfirmationStepBackPressed(
    BookingConfirmationStepBackPressed event,
    Emitter<BookingState> emit,
  ) {
    emit(
      state.copyWith(
        currentStep: BookingStep.appointment,
      ),
    );
  }

  void _onFlowCompleted(
    BookingFlowCompleted event,
    Emitter<BookingState> emit,
  ) {
    emit(
      state.copyWith(
        bookingReference: event.bookingReference,
      ),
    );
  }
}
