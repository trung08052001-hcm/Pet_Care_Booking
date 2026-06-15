import 'package:app/core/usecase/usecase.dart';
import 'package:app/features/services/domain/entities/pet_care_service.dart';
import 'package:app/features/services/domain/entities/service_category_filter.dart';
import 'package:app/features/services/domain/usecases/get_services_page_content_usecase.dart';
import 'package:app/features/services/presentation/bloc/services_event.dart';
import 'package:app/features/services/presentation/bloc/services_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

@injectable
class ServicesBloc extends Bloc<ServicesEvent, ServicesState> {
  ServicesBloc(this._getServicesPageContentUseCase)
      : super(const ServicesState()) {
    on<ServicesStarted>(_onStarted);
    on<ServicesRefreshRequested>(_onRefreshRequested);
    on<ServicesCategoryFilterChanged>(_onCategoryFilterChanged);
    on<ServicesNotificationsPressed>(_onNotificationsPressed);
    on<ServiceBookNowPressed>(_onBookNowPressed);
  }

  final GetServicesPageContentUseCase _getServicesPageContentUseCase;

  Future<void> _onStarted(
    ServicesStarted event,
    Emitter<ServicesState> emit,
  ) =>
      _loadContent(emit);

  Future<void> _onRefreshRequested(
    ServicesRefreshRequested event,
    Emitter<ServicesState> emit,
  ) =>
      _loadContent(emit);

  Future<void> _loadContent(Emitter<ServicesState> emit) async {
    emit(
      state.copyWith(
        status: ServicesStatus.loading,
        clearMessage: true,
        interaction: ServicesInteraction.none,
        clearSelection: true,
      ),
    );

    final result = await _getServicesPageContentUseCase(const NoParams());
    result.fold(
      (failure) => emit(
        state.copyWith(
          status: ServicesStatus.failure,
          message: failure.message,
          visibleServices: const [],
          clearSelection: true,
        ),
      ),
      (content) {
        final visible = _filterServices(
          content.services,
          state.selectedCategory,
        );
        emit(
          state.copyWith(
            status: ServicesStatus.success,
            content: content,
            visibleServices: visible,
            clearMessage: true,
            clearSelection: true,
          ),
        );
      },
    );
  }

  void _onCategoryFilterChanged(
    ServicesCategoryFilterChanged event,
    Emitter<ServicesState> emit,
  ) {
    final content = state.content;
    if (content == null) {
      emit(state.copyWith(selectedCategory: event.category));
      return;
    }

    emit(
      state.copyWith(
        selectedCategory: event.category,
        visibleServices: _filterServices(content.services, event.category),
        interaction: ServicesInteraction.none,
        clearSelection: true,
      ),
    );
  }

  void _onNotificationsPressed(
    ServicesNotificationsPressed event,
    Emitter<ServicesState> emit,
  ) {
    emit(
      state.copyWith(
        interaction: ServicesInteraction.notifications,
        clearSelection: true,
      ),
    );
  }

  void _onBookNowPressed(
    ServiceBookNowPressed event,
    Emitter<ServicesState> emit,
  ) {
    emit(
      state.copyWith(
        interaction: ServicesInteraction.bookNow,
        selectedServiceId: event.serviceId,
      ),
    );
  }

  List<PetCareService> _filterServices(
    List<PetCareService> services,
    ServiceCategoryFilter category,
  ) {
    return switch (category) {
      ServiceCategoryFilter.all => services,
      ServiceCategoryFilter.dog => services
          .where((service) => service.category == ServiceCategoryFilter.dog)
          .toList(growable: false),
      ServiceCategoryFilter.cat => services
          .where((service) => service.category == ServiceCategoryFilter.cat)
          .toList(growable: false),
    };
  }
}
