import 'package:app/core/usecase/usecase.dart';
import 'package:app/features/home/domain/usecases/get_home_dashboard_usecase.dart';
import 'package:app/features/home/presentation/bloc/home_event.dart';
import 'package:app/features/home/presentation/bloc/home_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

@injectable
class HomeBloc extends Bloc<HomeEvent, HomeState> {
  HomeBloc(this._getHomeDashboardUseCase) : super(const HomeState()) {
    on<HomeStarted>(_onStarted);
    on<HomeRefreshRequested>(_onRefreshRequested);
    on<HomeNotificationsPressed>(_onNotificationsPressed);
    on<HomeBookNowPressed>(_onBookNowPressed);
    on<HomePromoClaimPressed>(_onPromoClaimPressed);
    on<HomeFeaturedServicesSeeAllPressed>(_onFeaturedServicesSeeAllPressed);
    on<HomePetTipsSeeAllPressed>(_onPetTipsSeeAllPressed);
    on<HomeFeaturedServicePressed>(_onFeaturedServicePressed);
    on<HomePetTipPressed>(_onPetTipPressed);
  }

  final GetHomeDashboardUseCase _getHomeDashboardUseCase;

  Future<void> _onStarted(
    HomeStarted event,
    Emitter<HomeState> emit,
  ) =>
      _loadDashboard(emit);

  Future<void> _onRefreshRequested(
    HomeRefreshRequested event,
    Emitter<HomeState> emit,
  ) =>
      _loadDashboard(emit, isRefresh: true);

  Future<void> _loadDashboard(
    Emitter<HomeState> emit, {
    bool isRefresh = false,
  }) async {
    emit(
      state.copyWith(
        status: HomeStatus.loading,
        clearMessage: true,
        interaction: HomeInteraction.none,
        clearSelection: true,
      ),
    );

    final result = await _getHomeDashboardUseCase(const NoParams());
    result.fold(
      (failure) => emit(
        state.copyWith(
          status: HomeStatus.failure,
          message: failure.message,
          clearSelection: true,
        ),
      ),
      (dashboard) => emit(
        state.copyWith(
          status: HomeStatus.success,
          dashboard: dashboard,
          clearMessage: true,
          clearSelection: true,
        ),
      ),
    );
  }

  void _onNotificationsPressed(
    HomeNotificationsPressed event,
    Emitter<HomeState> emit,
  ) {
    emit(
      state.copyWith(
        interaction: HomeInteraction.notifications,
        clearSelection: true,
      ),
    );
  }

  void _onBookNowPressed(
    HomeBookNowPressed event,
    Emitter<HomeState> emit,
  ) {
    emit(
      state.copyWith(
        interaction: HomeInteraction.bookNow,
        clearSelection: true,
      ),
    );
  }

  void _onPromoClaimPressed(
    HomePromoClaimPressed event,
    Emitter<HomeState> emit,
  ) {
    emit(
      state.copyWith(
        interaction: HomeInteraction.promoClaim,
        clearSelection: true,
      ),
    );
  }

  void _onFeaturedServicesSeeAllPressed(
    HomeFeaturedServicesSeeAllPressed event,
    Emitter<HomeState> emit,
  ) {
    emit(
      state.copyWith(
        interaction: HomeInteraction.featuredServicesSeeAll,
        clearSelection: true,
      ),
    );
  }

  void _onPetTipsSeeAllPressed(
    HomePetTipsSeeAllPressed event,
    Emitter<HomeState> emit,
  ) {
    emit(
      state.copyWith(
        interaction: HomeInteraction.petTipsSeeAll,
        clearSelection: true,
      ),
    );
  }

  void _onFeaturedServicePressed(
    HomeFeaturedServicePressed event,
    Emitter<HomeState> emit,
  ) {
    emit(
      state.copyWith(
        interaction: HomeInteraction.featuredService,
        selectedServiceId: event.serviceId,
      ),
    );
  }

  void _onPetTipPressed(
    HomePetTipPressed event,
    Emitter<HomeState> emit,
  ) {
    emit(
      state.copyWith(
        interaction: HomeInteraction.petTip,
        selectedTipId: event.tipId,
      ),
    );
  }
}
