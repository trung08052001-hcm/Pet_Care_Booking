import 'package:app/features/home/domain/entities/home_dashboard.dart';
import 'package:equatable/equatable.dart';

enum HomeStatus {
  initial,
  loading,
  success,
  failure,
}

enum HomeInteraction {
  none,
  notifications,
  bookNow,
  promoClaim,
  featuredServicesSeeAll,
  petTipsSeeAll,
  featuredService,
  petTip,
}

class HomeState extends Equatable {
  const HomeState({
    this.status = HomeStatus.initial,
    this.dashboard,
    this.message,
    this.interaction = HomeInteraction.none,
    this.selectedServiceId,
    this.selectedTipId,
  });

  final HomeStatus status;
  final HomeDashboard? dashboard;
  final String? message;
  final HomeInteraction interaction;
  final String? selectedServiceId;
  final String? selectedTipId;

  bool get isLoading =>
      status == HomeStatus.loading || status == HomeStatus.initial;

  HomeState copyWith({
    HomeStatus? status,
    HomeDashboard? dashboard,
    String? message,
    HomeInteraction? interaction,
    String? selectedServiceId,
    String? selectedTipId,
    bool clearMessage = false,
    bool clearSelection = false,
  }) {
    return HomeState(
      status: status ?? this.status,
      dashboard: dashboard ?? this.dashboard,
      message: clearMessage ? null : (message ?? this.message),
      interaction: interaction ?? this.interaction,
      selectedServiceId: clearSelection
          ? null
          : (selectedServiceId ?? this.selectedServiceId),
      selectedTipId:
          clearSelection ? null : (selectedTipId ?? this.selectedTipId),
    );
  }

  @override
  List<Object?> get props => [
        status,
        dashboard,
        message,
        interaction,
        selectedServiceId,
        selectedTipId,
      ];
}
