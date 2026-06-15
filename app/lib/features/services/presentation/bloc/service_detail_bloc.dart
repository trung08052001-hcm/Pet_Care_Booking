import 'package:app/features/services/domain/usecases/get_service_detail_usecase.dart';
import 'package:app/features/services/presentation/bloc/service_detail_event.dart';
import 'package:app/features/services/presentation/bloc/service_detail_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ServiceDetailBloc extends Bloc<ServiceDetailEvent, ServiceDetailState> {
  ServiceDetailBloc(this._getServiceDetailUseCase)
      : super(const ServiceDetailState()) {
    on<ServiceDetailStarted>(_onStarted);
    on<ServiceDetailBookNowPressed>(_onBookNowPressed);
  }

  final GetServiceDetailUseCase _getServiceDetailUseCase;

  Future<void> _onStarted(
    ServiceDetailStarted event,
    Emitter<ServiceDetailState> emit,
  ) async {
    emit(
      state.copyWith(
        status: ServiceDetailStatus.loading,
        interaction: ServiceDetailInteraction.none,
        clearMessage: true,
      ),
    );

    final result = await _getServiceDetailUseCase(
      GetServiceDetailParams(event.serviceId),
    );
    result.fold(
      (failure) => emit(
        state.copyWith(
          status: ServiceDetailStatus.failure,
          message: failure.message,
        ),
      ),
      (service) => emit(
        state.copyWith(
          status: ServiceDetailStatus.success,
          service: service,
          clearMessage: true,
        ),
      ),
    );
  }

  void _onBookNowPressed(
    ServiceDetailBookNowPressed event,
    Emitter<ServiceDetailState> emit,
  ) {
    emit(
      state.copyWith(
        interaction: ServiceDetailInteraction.bookNow,
      ),
    );
  }
}
