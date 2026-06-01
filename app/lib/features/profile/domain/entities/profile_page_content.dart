import 'package:app/features/profile/domain/entities/profile_menu_item.dart';
import 'package:app/features/profile/domain/entities/profile_user.dart';
import 'package:equatable/equatable.dart';

class ProfilePageContent extends Equatable {
  const ProfilePageContent({
    required this.user,
    required this.mainMenuItems,
    required this.supportSectionTitle,
    required this.supportMenuItems,
    required this.logoutLabel,
    required this.appVersionLabel,
  });

  final ProfileUser user;
  final List<ProfileMenuItem> mainMenuItems;
  final String supportSectionTitle;
  final List<ProfileMenuItem> supportMenuItems;
  final String logoutLabel;
  final String appVersionLabel;

  @override
  List<Object?> get props => [
        user,
        mainMenuItems,
        supportSectionTitle,
        supportMenuItems,
        logoutLabel,
        appVersionLabel,
      ];
}
