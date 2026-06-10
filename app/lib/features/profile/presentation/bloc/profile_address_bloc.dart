import 'package:app/core/usecase/usecase.dart';
import 'package:app/features/profile/data/services/current_location_address_service.dart';
import 'package:app/features/profile/domain/usecases/get_profile_address_usecase.dart';
import 'package:app/features/profile/domain/usecases/save_profile_address_usecase.dart';
import 'package:app/features/profile/presentation/bloc/profile_address_event.dart';
import 'package:app/features/profile/presentation/bloc/profile_address_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ProfileAddressBloc
    extends Bloc<ProfileAddressEvent, ProfileAddressState> {
  ProfileAddressBloc(
    this._getProfileAddressUseCase,
    this._saveProfileAddressUseCase,
    this._currentLocationAddressService,
  ) : super(const ProfileAddressState()) {
    on<ProfileAddressStarted>(_onStarted);
    on<ProfileAddressDetailChanged>(_onDetailChanged);
    on<ProfileAddressLabelChanged>(_onLabelChanged);
    on<ProfileAddressLocatePressed>(_onLocatePressed);
    on<ProfileAddressSavePressed>(_onSavePressed);
    on<ProfileAddressMessageConsumed>(_onMessageConsumed);
  }

  final GetProfileAddressUseCase _getProfileAddressUseCase;
  final SaveProfileAddressUseCase _saveProfileAddressUseCase;
  final CurrentLocationAddressService _currentLocationAddressService;

  Future<void> _onStarted(
    ProfileAddressStarted event,
    Emitter<ProfileAddressState> emit,
  ) async {
    emit(
      state.copyWith(
        status: ProfileAddressStatus.loading,
        clearMessage: true,
        interaction: ProfileAddressInteraction.none,
      ),
    );

    final result = await _getProfileAddressUseCase(const NoParams());
    result.fold(
      (failure) => emit(
        state.copyWith(
          status: ProfileAddressStatus.failure,
          message: failure.message,
        ),
      ),
      (address) => emit(
        state.copyWith(
          status: ProfileAddressStatus.ready,
          address: address,
          detail: address?.detail ?? '',
          label: address?.label ?? '',
          latitude: address?.latitude,
          longitude: address?.longitude,
          clearMessage: true,
        ),
      ),
    );
  }

  void _onDetailChanged(
    ProfileAddressDetailChanged event,
    Emitter<ProfileAddressState> emit,
  ) {
    emit(
      state.copyWith(
        status: ProfileAddressStatus.ready,
        detail: event.detail,
        clearMessage: true,
      ),
    );
  }

  void _onLabelChanged(
    ProfileAddressLabelChanged event,
    Emitter<ProfileAddressState> emit,
  ) {
    emit(
      state.copyWith(
        status: ProfileAddressStatus.ready,
        label: event.label,
        clearMessage: true,
      ),
    );
  }

  Future<void> _onLocatePressed(
    ProfileAddressLocatePressed event,
    Emitter<ProfileAddressState> emit,
  ) async {
    emit(
      state.copyWith(
        status: ProfileAddressStatus.locating,
        clearMessage: true,
        interaction: ProfileAddressInteraction.none,
      ),
    );

    try {
      final location = await _currentLocationAddressService.resolveCurrentAddress();
      emit(
        state.copyWith(
          status: ProfileAddressStatus.ready,
          detail: location.address,
          latitude: location.latitude,
          longitude: location.longitude,
          message: 'Đã lấy vị trí hiện tại.',
          interaction: ProfileAddressInteraction.located,
        ),
      );
    } on Exception catch (error) {
      emit(
        state.copyWith(
          status: ProfileAddressStatus.ready,
          message: error.toString().replaceFirst('Exception: ', ''),
        ),
      );
    }
  }

  Future<void> _onSavePressed(
    ProfileAddressSavePressed event,
    Emitter<ProfileAddressState> emit,
  ) async {
    if (state.detail.trim().isEmpty) {
      emit(
        state.copyWith(
          status: ProfileAddressStatus.ready,
          message: 'Vui lòng nhập địa chỉ của bạn.',
        ),
      );
      return;
    }

    emit(
      state.copyWith(
        status: ProfileAddressStatus.saving,
        clearMessage: true,
        interaction: ProfileAddressInteraction.none,
      ),
    );

    final result = await _saveProfileAddressUseCase(
      SaveProfileAddressParams(
        detail: state.detail.trim(),
        label: state.label.trim(),
        latitude: state.latitude,
        longitude: state.longitude,
      ),
    );

    result.fold(
      (failure) => emit(
        state.copyWith(
          status: ProfileAddressStatus.ready,
          message: failure.message,
        ),
      ),
      (address) => emit(
        state.copyWith(
          status: ProfileAddressStatus.ready,
          address: address,
          detail: address.detail,
          label: address.label,
          latitude: address.latitude,
          longitude: address.longitude,
          message: 'Đã lưu địa chỉ.',
          interaction: ProfileAddressInteraction.saved,
        ),
      ),
    );
  }

  void _onMessageConsumed(
    ProfileAddressMessageConsumed event,
    Emitter<ProfileAddressState> emit,
  ) {
    emit(
      state.copyWith(
        clearMessage: true,
        interaction: ProfileAddressInteraction.none,
      ),
    );
  }
}
