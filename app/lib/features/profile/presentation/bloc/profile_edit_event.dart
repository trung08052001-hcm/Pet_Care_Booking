import 'package:equatable/equatable.dart';

sealed class ProfileEditEvent extends Equatable {
  const ProfileEditEvent();

  @override
  List<Object?> get props => const [];
}

final class ProfileEditStarted extends ProfileEditEvent {
  const ProfileEditStarted();
}

final class ProfileEditAvatarChanged extends ProfileEditEvent {
  const ProfileEditAvatarChanged(this.avatarDataUrl);

  final String avatarDataUrl;

  @override
  List<Object?> get props => [avatarDataUrl];
}

final class ProfileEditCurrentPasswordChanged extends ProfileEditEvent {
  const ProfileEditCurrentPasswordChanged(this.value);

  final String value;

  @override
  List<Object?> get props => [value];
}

final class ProfileEditNewPasswordChanged extends ProfileEditEvent {
  const ProfileEditNewPasswordChanged(this.value);

  final String value;

  @override
  List<Object?> get props => [value];
}

final class ProfileEditConfirmPasswordChanged extends ProfileEditEvent {
  const ProfileEditConfirmPasswordChanged(this.value);

  final String value;

  @override
  List<Object?> get props => [value];
}

final class ProfileEditSubmitted extends ProfileEditEvent {
  const ProfileEditSubmitted();
}

final class ProfileEditMessageConsumed extends ProfileEditEvent {
  const ProfileEditMessageConsumed();
}
