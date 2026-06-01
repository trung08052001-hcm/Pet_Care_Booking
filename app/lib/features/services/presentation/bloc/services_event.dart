import 'package:app/features/services/domain/entities/service_category_filter.dart';
import 'package:equatable/equatable.dart';

sealed class ServicesEvent extends Equatable {
  const ServicesEvent();

  @override
  List<Object?> get props => const [];
}

final class ServicesStarted extends ServicesEvent {
  const ServicesStarted();
}

final class ServicesRefreshRequested extends ServicesEvent {
  const ServicesRefreshRequested();
}

final class ServicesCategoryFilterChanged extends ServicesEvent {
  const ServicesCategoryFilterChanged(this.category);

  final ServiceCategoryFilter category;

  @override
  List<Object?> get props => [category];
}

final class ServicesNotificationsPressed extends ServicesEvent {
  const ServicesNotificationsPressed();
}

final class ServiceBookNowPressed extends ServicesEvent {
  const ServiceBookNowPressed(this.serviceId);

  final String serviceId;

  @override
  List<Object?> get props => [serviceId];
}
