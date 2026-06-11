import 'package:app/features/profile/domain/entities/profile_edit_user.dart';
import 'package:equatable/equatable.dart';

enum ProfileEditStatus {
  initial,
  loading,
  ready,
  saving,
  failure,
}

enum ProfileEditInteraction {
  none,
  saved,
}

class ProfileEditState extends Equatable {
  const ProfileEditState({
    this.status = ProfileEditStatus.initial,
    this.user,
    this.avatarDataUrl,
    this.currentPassword = '',
    this.newPassword = '',
    this.confirmPassword = '',
    this.message,
    this.interaction = ProfileEditInteraction.none,
  });

  final ProfileEditStatus status;
  final ProfileEditUser? user;
  final String? avatarDataUrl;
  final String currentPassword;
  final String newPassword;
  final String confirmPassword;
  final String? message;
  final ProfileEditInteraction interaction;

  bool get isLoading =>
      status == ProfileEditStatus.initial || status == ProfileEditStatus.loading;

  bool get isSaving => status == ProfileEditStatus.saving;

  bool get hasAvatarChange =>
      avatarDataUrl != null && avatarDataUrl != user?.avatar;

  bool get hasPasswordChange =>
      currentPassword.trim().isNotEmpty ||
      newPassword.trim().isNotEmpty ||
      confirmPassword.trim().isNotEmpty;

  bool get canSubmit => !isSaving && (hasAvatarChange || hasPasswordChange);

  ProfileEditState copyWith({
    ProfileEditStatus? status,
    ProfileEditUser? user,
    String? avatarDataUrl,
    String? currentPassword,
    String? newPassword,
    String? confirmPassword,
    String? message,
    ProfileEditInteraction? interaction,
    bool clearMessage = false,
    bool clearPasswords = false,
  }) {
    return ProfileEditState(
      status: status ?? this.status,
      user: user ?? this.user,
      avatarDataUrl: avatarDataUrl ?? this.avatarDataUrl,
      currentPassword:
          clearPasswords ? '' : (currentPassword ?? this.currentPassword),
      newPassword: clearPasswords ? '' : (newPassword ?? this.newPassword),
      confirmPassword:
          clearPasswords ? '' : (confirmPassword ?? this.confirmPassword),
      message: clearMessage ? null : (message ?? this.message),
      interaction: interaction ?? this.interaction,
    );
  }

  @override
  List<Object?> get props => [
        status,
        user,
        avatarDataUrl,
        currentPassword,
        newPassword,
        confirmPassword,
        message,
        interaction,
      ];
}
