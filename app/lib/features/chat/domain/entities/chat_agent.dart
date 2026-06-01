import 'package:equatable/equatable.dart';

class ChatAgent extends Equatable {
  const ChatAgent({
    required this.name,
    required this.role,
    this.avatarInitials,
  });

  final String name;
  final String role;
  final String? avatarInitials;

  @override
  List<Object?> get props => [name, role, avatarInitials];
}
