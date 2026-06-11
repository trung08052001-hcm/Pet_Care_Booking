import 'package:app/features/profile/domain/usecases/get_profile_edit_user_usecase.dart';
import 'package:app/features/profile/domain/usecases/update_profile_edit_usecase.dart';
import 'package:app/features/profile/presentation/bloc/profile_edit_event.dart';
import 'package:app/features/profile/presentation/bloc/profile_edit_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ProfileEditBloc extends Bloc<ProfileEditEvent, ProfileEditState> {
  ProfileEditBloc(
    this._getProfileEditUserUseCase,
    this._updateProfileEditUseCase,
  ) : super(const ProfileEditState()) {
    on<ProfileEditStarted>(_onStarted);
    on<ProfileEditAvatarChanged>(_onAvatarChanged);
    on<ProfileEditCurrentPasswordChanged>(_onCurrentPasswordChanged);
    on<ProfileEditNewPasswordChanged>(_onNewPasswordChanged);
    on<ProfileEditConfirmPasswordChanged>(_onConfirmPasswordChanged);
    on<ProfileEditSubmitted>(_onSubmitted);
    on<ProfileEditMessageConsumed>(_onMessageConsumed);
  }

  final GetProfileEditUserUseCase _getProfileEditUserUseCase;
  final UpdateProfileEditUseCase _updateProfileEditUseCase;

  Future<void> _onStarted(
    ProfileEditStarted event,
    Emitter<ProfileEditState> emit,
  ) async {
    emit(
      state.copyWith(
        status: ProfileEditStatus.loading,
        clearMessage: true,
        interaction: ProfileEditInteraction.none,
      ),
    );

    try {
      final user = await _getProfileEditUserUseCase();
      emit(
        state.copyWith(
          status: ProfileEditStatus.ready,
          user: user,
          avatarDataUrl: user.avatar,
          clearMessage: true,
        ),
      );
    } on Exception catch (error) {
      emit(
        state.copyWith(
          status: ProfileEditStatus.failure,
          message: error.toString().replaceFirst('Exception: ', ''),
        ),
      );
    }
  }

  void _onAvatarChanged(
    ProfileEditAvatarChanged event,
    Emitter<ProfileEditState> emit,
  ) {
    emit(
      state.copyWith(
        status: ProfileEditStatus.ready,
        avatarDataUrl: event.avatarDataUrl,
        clearMessage: true,
        interaction: ProfileEditInteraction.none,
      ),
    );
  }

  void _onCurrentPasswordChanged(
    ProfileEditCurrentPasswordChanged event,
    Emitter<ProfileEditState> emit,
  ) {
    emit(state.copyWith(currentPassword: event.value, clearMessage: true));
  }

  void _onNewPasswordChanged(
    ProfileEditNewPasswordChanged event,
    Emitter<ProfileEditState> emit,
  ) {
    emit(state.copyWith(newPassword: event.value, clearMessage: true));
  }

  void _onConfirmPasswordChanged(
    ProfileEditConfirmPasswordChanged event,
    Emitter<ProfileEditState> emit,
  ) {
    emit(state.copyWith(confirmPassword: event.value, clearMessage: true));
  }

  Future<void> _onSubmitted(
    ProfileEditSubmitted event,
    Emitter<ProfileEditState> emit,
  ) async {
    if (!state.canSubmit) {
      emit(state.copyWith(message: 'Chưa có thông tin cần cập nhật.'));
      return;
    }

    if (state.hasPasswordChange) {
      final current = state.currentPassword.trim();
      final next = state.newPassword.trim();
      final confirm = state.confirmPassword.trim();

      if (current.isEmpty || next.isEmpty || confirm.isEmpty) {
        emit(state.copyWith(message: 'Vui lòng nhập đủ thông tin mật khẩu.'));
        return;
      }
      if (next.length < 8) {
        emit(state.copyWith(message: 'Mật khẩu mới phải có ít nhất 8 ký tự.'));
        return;
      }
      if (next != confirm) {
        emit(state.copyWith(message: 'Xác nhận mật khẩu không khớp.'));
        return;
      }
      if (current == next) {
        emit(state.copyWith(message: 'Mật khẩu mới phải khác mật khẩu hiện tại.'));
        return;
      }
    }

    emit(
      state.copyWith(
        status: ProfileEditStatus.saving,
        clearMessage: true,
        interaction: ProfileEditInteraction.none,
      ),
    );

    try {
      var updatedUser = state.user;
      if (state.hasAvatarChange) {
        updatedUser = await _updateProfileEditUseCase.updateAvatar(
          state.avatarDataUrl,
        );
      }
      if (state.hasPasswordChange) {
        await _updateProfileEditUseCase.changePassword(
          currentPassword: state.currentPassword.trim(),
          newPassword: state.newPassword.trim(),
          confirmPassword: state.confirmPassword.trim(),
        );
      }

      emit(
        state.copyWith(
          status: ProfileEditStatus.ready,
          user: updatedUser,
          avatarDataUrl: updatedUser?.avatar ?? state.avatarDataUrl,
          message: 'Đã cập nhật hồ sơ.',
          interaction: ProfileEditInteraction.saved,
          clearPasswords: true,
        ),
      );
    } on Exception catch (error) {
      emit(
        state.copyWith(
          status: ProfileEditStatus.ready,
          message: error.toString().replaceFirst('Exception: ', ''),
        ),
      );
    }
  }

  void _onMessageConsumed(
    ProfileEditMessageConsumed event,
    Emitter<ProfileEditState> emit,
  ) {
    emit(
      state.copyWith(
        clearMessage: true,
        interaction: ProfileEditInteraction.none,
      ),
    );
  }
}
