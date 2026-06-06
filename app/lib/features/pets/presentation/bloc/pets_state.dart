import 'package:app/features/pets/domain/entities/my_pets_page_content.dart';
import 'package:equatable/equatable.dart';

enum PetsStatus {
  initial,
  loading,
  success,
  failure,
}

enum PetsInteraction {
  none,
  petSelected,
  addPet,
  petCreated,
  promoExplore,
  fab,
}

class PetsState extends Equatable {
  const PetsState({
    this.status = PetsStatus.initial,
    this.content,
    this.serviceId,
    this.message,
    this.interaction = PetsInteraction.none,
    this.selectedPetId,
    this.isCreatingPet = false,
  });

  final PetsStatus status;
  final MyPetsPageContent? content;
  final String? serviceId;
  final String? message;
  final PetsInteraction interaction;
  final String? selectedPetId;
  final bool isCreatingPet;

  bool get isLoading =>
      status == PetsStatus.loading || status == PetsStatus.initial;

  PetsState copyWith({
    PetsStatus? status,
    MyPetsPageContent? content,
    String? serviceId,
    String? message,
    PetsInteraction? interaction,
    String? selectedPetId,
    bool? isCreatingPet,
    bool clearMessage = false,
    bool clearSelection = false,
  }) {
    return PetsState(
      status: status ?? this.status,
      content: content ?? this.content,
      serviceId: serviceId ?? this.serviceId,
      message: clearMessage ? null : (message ?? this.message),
      interaction: interaction ?? this.interaction,
      selectedPetId:
          clearSelection ? null : (selectedPetId ?? this.selectedPetId),
      isCreatingPet: isCreatingPet ?? this.isCreatingPet,
    );
  }

  @override
  List<Object?> get props => [
        status,
        content,
        serviceId,
        message,
        interaction,
        selectedPetId,
        isCreatingPet,
      ];
}
