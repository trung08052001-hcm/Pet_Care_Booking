import 'package:app/features/booking/domain/entities/booking_step.dart';
import 'package:app/features/pets/domain/entities/pet.dart';
import 'package:equatable/equatable.dart';

enum BookingInteraction {
  none,
  advanceToService,
  addPet,
  quickAddPet,
  petMoreOptions,
}

class BookingState extends Equatable {
  const BookingState({
    this.currentStep = BookingStep.pet,
    this.searchQuery = '',
    this.serviceId,
    this.selectedPetId,
    this.selectedServiceIds = const [],
    this.totalVnd = 0,
    this.selectedAppointmentDate,
    this.selectedTimeSlotId,
    this.selectedTimeSlotLabel,
    this.bookingReference,
    this.interaction = BookingInteraction.none,
  });

  final BookingStep currentStep;
  final String searchQuery;
  final String? serviceId;
  final String? selectedPetId;
  final List<String> selectedServiceIds;
  final int totalVnd;
  final DateTime? selectedAppointmentDate;
  final String? selectedTimeSlotId;
  final String? selectedTimeSlotLabel;
  final String? bookingReference;
  final BookingInteraction interaction;

  List<Pet> filteredPets(List<Pet> pets) {
    final query = searchQuery.trim().toLowerCase();
    if (query.isEmpty) {
      return pets;
    }

    return pets
        .where(
          (pet) =>
              pet.name.toLowerCase().contains(query) ||
              pet.breed.toLowerCase().contains(query),
        )
        .toList();
  }

  BookingState copyWith({
    BookingStep? currentStep,
    String? searchQuery,
    String? serviceId,
    String? selectedPetId,
    List<String>? selectedServiceIds,
    int? totalVnd,
    DateTime? selectedAppointmentDate,
    String? selectedTimeSlotId,
    String? selectedTimeSlotLabel,
    String? bookingReference,
    BookingInteraction? interaction,
    bool clearSelectedPet = false,
    bool clearServiceId = false,
    bool clearSelectedServices = false,
    bool clearAppointment = false,
  }) {
    return BookingState(
      currentStep: currentStep ?? this.currentStep,
      searchQuery: searchQuery ?? this.searchQuery,
      serviceId: clearServiceId ? null : (serviceId ?? this.serviceId),
      selectedPetId: clearSelectedPet
          ? null
          : (selectedPetId ?? this.selectedPetId),
      selectedServiceIds: clearSelectedServices
          ? const []
          : (selectedServiceIds ?? this.selectedServiceIds),
      totalVnd: totalVnd ?? this.totalVnd,
      selectedAppointmentDate: clearAppointment
          ? null
          : (selectedAppointmentDate ?? this.selectedAppointmentDate),
      selectedTimeSlotId: clearAppointment
          ? null
          : (selectedTimeSlotId ?? this.selectedTimeSlotId),
      selectedTimeSlotLabel: clearAppointment
          ? null
          : (selectedTimeSlotLabel ?? this.selectedTimeSlotLabel),
      bookingReference: bookingReference ?? this.bookingReference,
      interaction: interaction ?? this.interaction,
    );
  }

  @override
  List<Object?> get props => [
        currentStep,
        searchQuery,
        serviceId,
        selectedPetId,
        selectedServiceIds,
        totalVnd,
        selectedAppointmentDate,
        selectedTimeSlotId,
        selectedTimeSlotLabel,
        bookingReference,
        interaction,
      ];
}
