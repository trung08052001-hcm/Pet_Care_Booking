import 'package:equatable/equatable.dart';

sealed class PetsEvent extends Equatable {
  const PetsEvent();

  @override
  List<Object?> get props => const [];
}

final class PetsStarted extends PetsEvent {
  const PetsStarted({this.serviceId});

  final String? serviceId;

  @override
  List<Object?> get props => [serviceId];
}

final class PetsRefreshRequested extends PetsEvent {
  const PetsRefreshRequested();
}

final class PetCreateSubmitted extends PetsEvent {
  const PetCreateSubmitted({
    required this.name,
    required this.ageYears,
    required this.weightKg,
    required this.petType,
    required this.vaccinationStatus,
    this.imageDataUrl,
  });

  final String name;
  final int ageYears;
  final double weightKg;
  final String petType;
  final String vaccinationStatus;
  final String? imageDataUrl;

  @override
  List<Object?> get props => [
        name,
        ageYears,
        weightKg,
        petType,
        vaccinationStatus,
        imageDataUrl,
      ];
}

final class PetsInteractionConsumed extends PetsEvent {
  const PetsInteractionConsumed();
}

final class PetSelected extends PetsEvent {
  const PetSelected(this.petId);

  final String petId;

  @override
  List<Object?> get props => [petId];
}

final class PetAddPressed extends PetsEvent {
  const PetAddPressed();
}

final class PetPromoExplorePressed extends PetsEvent {
  const PetPromoExplorePressed();
}

final class PetFabPressed extends PetsEvent {
  const PetFabPressed();
}

final class PetBackPressed extends PetsEvent {
  const PetBackPressed();
}
