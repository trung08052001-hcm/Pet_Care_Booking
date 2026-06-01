import 'package:equatable/equatable.dart';

sealed class HomeEvent extends Equatable {
  const HomeEvent();

  @override
  List<Object?> get props => const [];
}

/// Load home dashboard (initial & refresh).
final class HomeStarted extends HomeEvent {
  const HomeStarted();
}

final class HomeRefreshRequested extends HomeEvent {
  const HomeRefreshRequested();
}

final class HomeNotificationsPressed extends HomeEvent {
  const HomeNotificationsPressed();
}

final class HomeBookNowPressed extends HomeEvent {
  const HomeBookNowPressed();
}

final class HomePromoClaimPressed extends HomeEvent {
  const HomePromoClaimPressed();
}

final class HomeFeaturedServicesSeeAllPressed extends HomeEvent {
  const HomeFeaturedServicesSeeAllPressed();
}

final class HomePetTipsSeeAllPressed extends HomeEvent {
  const HomePetTipsSeeAllPressed();
}

final class HomeFeaturedServicePressed extends HomeEvent {
  const HomeFeaturedServicePressed(this.serviceId);

  final String serviceId;

  @override
  List<Object?> get props => [serviceId];
}

final class HomePetTipPressed extends HomeEvent {
  const HomePetTipPressed(this.tipId);

  final String tipId;

  @override
  List<Object?> get props => [tipId];
}
