import 'package:app/features/services/domain/entities/pet_care_service.dart';
import 'package:app/features/services/domain/entities/service_category_filter.dart';
import 'package:app/features/services/domain/entities/services_page_content.dart';
import 'package:equatable/equatable.dart';

enum ServicesStatus {
  initial,
  loading,
  success,
  failure,
}

enum ServicesInteraction {
  none,
  notifications,
  bookNow,
}

class ServicesState extends Equatable {
  const ServicesState({
    this.status = ServicesStatus.initial,
    this.content,
    this.selectedCategory = ServiceCategoryFilter.all,
    this.visibleServices = const [],
    this.message,
    this.interaction = ServicesInteraction.none,
    this.selectedServiceId,
  });

  final ServicesStatus status;
  final ServicesPageContent? content;
  final ServiceCategoryFilter selectedCategory;
  final List<PetCareService> visibleServices;
  final String? message;
  final ServicesInteraction interaction;
  final String? selectedServiceId;

  bool get isLoading =>
      status == ServicesStatus.loading || status == ServicesStatus.initial;

  ServicesState copyWith({
    ServicesStatus? status,
    ServicesPageContent? content,
    ServiceCategoryFilter? selectedCategory,
    List<PetCareService>? visibleServices,
    String? message,
    ServicesInteraction? interaction,
    String? selectedServiceId,
    bool clearMessage = false,
    bool clearSelection = false,
  }) {
    return ServicesState(
      status: status ?? this.status,
      content: content ?? this.content,
      selectedCategory: selectedCategory ?? this.selectedCategory,
      visibleServices: visibleServices ?? this.visibleServices,
      message: clearMessage ? null : (message ?? this.message),
      interaction: interaction ?? this.interaction,
      selectedServiceId: clearSelection
          ? null
          : (selectedServiceId ?? this.selectedServiceId),
    );
  }

  @override
  List<Object?> get props => [
        status,
        content,
        selectedCategory,
        visibleServices,
        message,
        interaction,
        selectedServiceId,
      ];
}
