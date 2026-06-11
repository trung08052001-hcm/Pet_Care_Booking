import 'package:equatable/equatable.dart';

class ProfileEditUser extends Equatable {
  const ProfileEditUser({
    required this.id,
    required this.fullName,
    required this.email,
    this.phone,
    this.avatar,
  });

  final String id;
  final String fullName;
  final String email;
  final String? phone;
  final String? avatar;

  @override
  List<Object?> get props => [
        id,
        fullName,
        email,
        phone,
        avatar,
      ];
}
