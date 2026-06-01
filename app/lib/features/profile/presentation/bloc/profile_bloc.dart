import 'package:app/core/usecase/usecase.dart';
import 'package:app/features/profile/domain/usecases/get_profile_page_content_usecase.dart';
import 'package:app/features/profile/domain/usecases/logout_usecase.dart';
import 'package:app/features/profile/presentation/bloc/profile_event.dart';
import 'package:app/features/profile/presentation/bloc/profile_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

@injectable
class ProfileBloc extends Bloc<ProfileEvent, ProfileState> {
  ProfileBloc(
    this._getProfilePageContentUseCase,
    this._logoutUseCase,
  ) : super(const ProfileState()) {
    on<ProfileStarted>(_onStarted);
    on<ProfileRefreshRequested>(_onRefreshRequested);
    on<ProfileEditPressed>(_onEditPressed);
    on<ProfileAvatarChangePressed>(_onAvatarChangePressed);
    on<ProfileMenuItemPressed>(_onMenuItemPressed);
    on<ProfileLogoutPressed>(_onLogoutPressed);
    on<ProfileNotificationsPressed>(_onNotificationsPressed);
  }

  final GetProfilePageContentUseCase _getProfilePageContentUseCase;
  final LogoutUseCase _logoutUseCase;

  Future<void> _onStarted(
    ProfileStarted event,
    Emitter<ProfileState> emit,
  ) =>
      _loadProfile(emit);

  Future<void> _onRefreshRequested(
    ProfileRefreshRequested event,
    Emitter<ProfileState> emit,
  ) =>
      _loadProfile(emit);

  Future<void> _loadProfile(Emitter<ProfileState> emit) async {
    emit(
      state.copyWith(
        status: ProfileStatus.loading,
        clearMessage: true,
        interaction: ProfileInteraction.none,
        clearMenuSelection: true,
      ),
    );

    final result = await _getProfilePageContentUseCase(const NoParams());
    result.fold(
      (failure) => emit(
        state.copyWith(
          status: ProfileStatus.failure,
          message: failure.message,
        ),
      ),
      (content) => emit(
        state.copyWith(
          status: ProfileStatus.success,
          content: content,
          clearMessage: true,
        ),
      ),
    );
  }

  void _onEditPressed(
    ProfileEditPressed event,
    Emitter<ProfileState> emit,
  ) {
    emit(
      state.copyWith(
        interaction: ProfileInteraction.editProfile,
        clearMenuSelection: true,
      ),
    );
  }

  void _onAvatarChangePressed(
    ProfileAvatarChangePressed event,
    Emitter<ProfileState> emit,
  ) {
    emit(
      state.copyWith(
        interaction: ProfileInteraction.changeAvatar,
        clearMenuSelection: true,
      ),
    );
  }

  void _onMenuItemPressed(
    ProfileMenuItemPressed event,
    Emitter<ProfileState> emit,
  ) {
    final items = [
      ...?state.content?.mainMenuItems,
      ...?state.content?.supportMenuItems,
    ];
    String? menuId;
    for (final menu in items) {
      if (menu.type == event.type) {
        menuId = menu.id;
        break;
      }
    }

    emit(
      state.copyWith(
        interaction: ProfileInteraction.menuItem,
        selectedMenuItemId: menuId,
      ),
    );
  }

  Future<void> _onLogoutPressed(
    ProfileLogoutPressed event,
    Emitter<ProfileState> emit,
  ) async {
    emit(
      state.copyWith(
        status: ProfileStatus.loggingOut,
        interaction: ProfileInteraction.none,
        clearMessage: true,
      ),
    );

    final result = await _logoutUseCase(const NoParams());
    result.fold(
      (failure) => emit(
        state.copyWith(
          status: ProfileStatus.success,
          message: failure.message,
        ),
      ),
      (_) => emit(
        state.copyWith(
          status: ProfileStatus.success,
          interaction: ProfileInteraction.logoutCompleted,
          clearMessage: true,
        ),
      ),
    );
  }

  void _onNotificationsPressed(
    ProfileNotificationsPressed event,
    Emitter<ProfileState> emit,
  ) {
    emit(
      state.copyWith(
        interaction: ProfileInteraction.notifications,
        clearMenuSelection: true,
      ),
    );
  }
}
