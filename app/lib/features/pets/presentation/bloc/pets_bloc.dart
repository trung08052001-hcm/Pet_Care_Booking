import 'package:app/core/usecase/usecase.dart';
import 'package:app/features/pets/domain/usecases/create_pet_usecase.dart';
import 'package:app/features/pets/domain/usecases/get_my_pets_page_content_usecase.dart';
import 'package:app/features/pets/presentation/bloc/pets_event.dart';
import 'package:app/features/pets/presentation/bloc/pets_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

@injectable
class PetsBloc extends Bloc<PetsEvent, PetsState> {
  PetsBloc(
    this._getMyPetsPageContentUseCase, [
    this._createPetUseCase,
  ]) : super(const PetsState()) {
    on<PetsStarted>(_onStarted);
    on<PetsRefreshRequested>(_onRefreshRequested);
    on<PetCreateSubmitted>(_onPetCreateSubmitted);
    on<PetSelected>(_onPetSelected);
    on<PetAddPressed>(_onAddPressed);
    on<PetPromoExplorePressed>(_onPromoExplorePressed);
    on<PetFabPressed>(_onFabPressed);
    on<PetsInteractionConsumed>(_onInteractionConsumed);
  }

  final GetMyPetsPageContentUseCase _getMyPetsPageContentUseCase;
  final CreatePetUseCase? _createPetUseCase;

  Future<void> _onStarted(PetsStarted event, Emitter<PetsState> emit) async {
    emit(
      state.copyWith(
        serviceId: event.serviceId,
        status: PetsStatus.loading,
        clearMessage: true,
        interaction: PetsInteraction.none,
        clearSelection: true,
      ),
    );
    await _loadPets(emit);
  }

  Future<void> _onRefreshRequested(
    PetsRefreshRequested event,
    Emitter<PetsState> emit,
  ) =>
      _loadPets(emit);

  Future<void> _loadPets(Emitter<PetsState> emit) async {
    emit(
      state.copyWith(
        status: PetsStatus.loading,
        clearMessage: true,
      ),
    );

    final result = await _getMyPetsPageContentUseCase(const NoParams());
    result.fold(
      (failure) => emit(
        state.copyWith(
          status: PetsStatus.failure,
          message: failure.message,
        ),
      ),
      (content) => emit(
        state.copyWith(
          status: PetsStatus.success,
          content: content,
          clearMessage: true,
        ),
      ),
    );
  }

  Future<void> _onPetCreateSubmitted(
    PetCreateSubmitted event,
    Emitter<PetsState> emit,
  ) async {
    final createPetUseCase = _createPetUseCase;
    if (createPetUseCase == null) {
      emit(
        state.copyWith(
          message: 'Chưa cấu hình API thú cưng.',
          interaction: PetsInteraction.none,
        ),
      );
      return;
    }

    emit(
      state.copyWith(
        isCreatingPet: true,
        clearMessage: true,
        interaction: PetsInteraction.none,
      ),
    );

    final result = await createPetUseCase(
      CreatePetParams(
        name: event.name,
        ageYears: event.ageYears,
        weightKg: event.weightKg,
        petType: event.petType,
        vaccinationStatus: event.vaccinationStatus,
        imageDataUrl: event.imageDataUrl,
      ),
    );

    await result.fold(
      (failure) async {
        emit(
          state.copyWith(
            isCreatingPet: false,
            message: failure.message,
            interaction: PetsInteraction.none,
          ),
        );
      },
      (_) async {
        await _loadPets(emit);
        emit(
          state.copyWith(
            isCreatingPet: false,
            message: 'Đã thêm thú cưng.',
            interaction: PetsInteraction.petCreated,
          ),
        );
      },
    );
  }

  void _onPetSelected(PetSelected event, Emitter<PetsState> emit) {
    emit(
      state.copyWith(
        interaction: PetsInteraction.petSelected,
        selectedPetId: event.petId,
      ),
    );
  }

  void _onAddPressed(PetAddPressed event, Emitter<PetsState> emit) {
    emit(
      state.copyWith(
        interaction: PetsInteraction.addPet,
        clearSelection: true,
      ),
    );
  }

  void _onPromoExplorePressed(
    PetPromoExplorePressed event,
    Emitter<PetsState> emit,
  ) {
    emit(
      state.copyWith(
        interaction: PetsInteraction.promoExplore,
        clearSelection: true,
      ),
    );
  }

  void _onFabPressed(PetFabPressed event, Emitter<PetsState> emit) {
    emit(
      state.copyWith(
        interaction: PetsInteraction.fab,
        clearSelection: true,
      ),
    );
  }

  void _onInteractionConsumed(
    PetsInteractionConsumed event,
    Emitter<PetsState> emit,
  ) {
    emit(state.copyWith(interaction: PetsInteraction.none, clearMessage: true));
  }
}
