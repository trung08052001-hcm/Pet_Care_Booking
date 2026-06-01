import 'package:app/features/profile/domain/entities/profile_page_content.dart';
import 'package:equatable/equatable.dart';

enum ProfileStatus {
  initial,
  loading,
  success,
  failure,
  loggingOut,
}

enum ProfileInteraction {
  none,
  notifications,
  editProfile,
  changeAvatar,
  menuItem,
  logoutCompleted,
}

class ProfileState extends Equatable {
  const ProfileState({
    this.status = ProfileStatus.initial,
    this.content,
    this.message,
    this.interaction = ProfileInteraction.none,
    this.selectedMenuItemId,
  });

  final ProfileStatus status;
  final ProfilePageContent? content;
  final String? message;
  final ProfileInteraction interaction;
  final String? selectedMenuItemId;

  bool get isLoading =>
      status == ProfileStatus.loading || status == ProfileStatus.initial;

  bool get isLoggingOut => status == ProfileStatus.loggingOut;

  ProfileState copyWith({
    ProfileStatus? status,
    ProfilePageContent? content,
    String? message,
    ProfileInteraction? interaction,
    String? selectedMenuItemId,
    bool clearMessage = false,
    bool clearMenuSelection = false,
  }) {
    return ProfileState(
      status: status ?? this.status,
      content: content ?? this.content,
      message: clearMessage ? null : (message ?? this.message),
      interaction: interaction ?? this.interaction,
      selectedMenuItemId: clearMenuSelection
          ? null
          : (selectedMenuItemId ?? this.selectedMenuItemId),
    );
  }

  @override
  List<Object?> get props => [
        status,
        content,
        message,
        interaction,
        selectedMenuItemId,
      ];
}
