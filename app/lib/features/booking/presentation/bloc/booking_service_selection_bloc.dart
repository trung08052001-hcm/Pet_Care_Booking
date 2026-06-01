import 'package:app/core/usecase/usecase.dart';
import 'package:app/features/booking/data/datasources/booking_service_mock_data_source.dart';
import 'package:app/features/booking/domain/entities/bookable_service.dart';
import 'package:app/features/booking/domain/usecases/get_booking_services_usecase.dart';
import 'package:app/features/booking/presentation/bloc/booking_service_selection_event.dart';
import 'package:app/features/booking/presentation/bloc/booking_service_selection_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

@injectable
class BookingServiceSelectionBloc
    extends Bloc<BookingServiceSelectionEvent, BookingServiceSelectionState> {
  BookingServiceSelectionBloc(this._getBookingServicesUseCase)
      : super(const BookingServiceSelectionState()) {
    on<BookingServiceSelectionStarted>(_onStarted);
    on<BookingServiceTogglePressed>(_onTogglePressed);
    on<BookingServiceContinuePressed>(_onContinuePressed);
  }

  final GetBookingServicesUseCase _getBookingServicesUseCase;

  Future<void> _onStarted(
    BookingServiceSelectionStarted event,
    Emitter<BookingServiceSelectionState> emit,
  ) async {
    emit(
      state.copyWith(
        status: BookingServiceSelectionStatus.loading,
        petId: event.petId,
        selectedServiceIds: const {},
        totalVnd: 0,
        clearMessage: true,
      ),
    );

    final result = await _getBookingServicesUseCase(const NoParams());
    result.fold(
      (failure) => emit(
        state.copyWith(
          status: BookingServiceSelectionStatus.failure,
          message: failure.message,
        ),
      ),
      (content) {
        final mappedId = BookingServiceMockDataSource.mapCatalogServiceId(
          event.preselectedServiceId,
        );
        final initialSelection = <String>{};
        if (mappedId != null &&
            content.services.any((service) => service.id == mappedId)) {
          initialSelection.add(mappedId);
        }

        emit(
          state.copyWith(
            status: BookingServiceSelectionStatus.success,
            content: content,
            selectedServiceIds: initialSelection,
            totalVnd: _calculateTotal(content.services, initialSelection),
            clearMessage: true,
          ),
        );
      },
    );
  }

  void _onTogglePressed(
    BookingServiceTogglePressed event,
    Emitter<BookingServiceSelectionState> emit,
  ) {
    final content = state.content;
    if (content == null) {
      return;
    }

    final updated = Set<String>.from(state.selectedServiceIds);
    if (updated.contains(event.serviceId)) {
      updated.remove(event.serviceId);
    } else {
      updated.add(event.serviceId);
    }

    emit(
      state.copyWith(
        selectedServiceIds: updated,
        totalVnd: _calculateTotal(content.services, updated),
      ),
    );
  }

  void _onContinuePressed(
    BookingServiceContinuePressed event,
    Emitter<BookingServiceSelectionState> emit,
  ) {
    if (!state.canContinue) {
      return;
    }
  }

  int _calculateTotal(
    List<BookableService> services,
    Set<String> selectedIds,
  ) {
    return services
        .where((service) => selectedIds.contains(service.id))
        .fold<int>(0, (sum, service) => sum + service.priceVnd);
  }
}
