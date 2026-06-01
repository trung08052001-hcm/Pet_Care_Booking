import 'package:equatable/equatable.dart';

class ProfileUser extends Equatable {
  const ProfileUser({
    required this.fullName,
    required this.memberSinceLabel,
    required this.editProfileLabel,
    this.avatarInitials,
    this.avatarUrl,
  });

  final String fullName;
  final String memberSinceLabel;
  final String editProfileLabel;
  final String? avatarInitials;
  final String? avatarUrl;

  @override
  List<Object?> get props => [
        fullName,
        memberSinceLabel,
        editProfileLabel,
        avatarInitials,
        avatarUrl,
      ];
}
