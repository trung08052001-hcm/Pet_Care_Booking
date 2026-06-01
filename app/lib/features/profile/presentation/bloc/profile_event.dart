import 'package:app/features/profile/domain/entities/profile_menu_item_type.dart';
import 'package:equatable/equatable.dart';

sealed class ProfileEvent extends Equatable {
  const ProfileEvent();

  @override
  List<Object?> get props => const [];
}

final class ProfileStarted extends ProfileEvent {
  const ProfileStarted();
}

final class ProfileRefreshRequested extends ProfileEvent {
  const ProfileRefreshRequested();
}

final class ProfileEditPressed extends ProfileEvent {
  const ProfileEditPressed();
}

final class ProfileAvatarChangePressed extends ProfileEvent {
  const ProfileAvatarChangePressed();
}

final class ProfileMenuItemPressed extends ProfileEvent {
  const ProfileMenuItemPressed(this.type);

  final ProfileMenuItemType type;

  @override
  List<Object?> get props => [type];
}

final class ProfileLogoutPressed extends ProfileEvent {
  const ProfileLogoutPressed();
}

final class ProfileNotificationsPressed extends ProfileEvent {
  const ProfileNotificationsPressed();
}
