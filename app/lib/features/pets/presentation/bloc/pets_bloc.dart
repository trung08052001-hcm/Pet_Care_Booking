import 'package:app/core/usecase/usecase.dart';
import 'package:app/features/pets/domain/usecases/get_my_pets_page_content_usecase.dart';
import 'package:app/features/pets/presentation/bloc/pets_event.dart';
import 'package:app/features/pets/presentation/bloc/pets_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

@injectable
class PetsBloc extends Bloc<PetsEvent, PetsState> {
  PetsBloc(this._getMyPetsPageContentUseCase) : super(const PetsState()) {
    on<PetsStarted>(_onStarted);
    on<PetsRefreshRequested>(_onRefreshRequested);
    on<PetSelected>(_onPetSelected);
    on<PetAddPressed>(_onAddPressed);
    on<PetPromoExplorePressed>(_onPromoExplorePressed);
    on<PetFabPressed>(_onFabPressed);
  }

  final GetMyPetsPageContentUseCase _getMyPetsPageContentUseCase;

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
}
