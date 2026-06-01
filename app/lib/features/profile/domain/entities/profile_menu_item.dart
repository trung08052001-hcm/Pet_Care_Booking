import 'package:app/features/profile/domain/entities/profile_menu_item_type.dart';
import 'package:equatable/equatable.dart';

class ProfileMenuItem extends Equatable {
  const ProfileMenuItem({
    required this.id,
    required this.type,
    required this.title,
    this.badgeLabel,
  });

  final String id;
  final ProfileMenuItemType type;
  final String title;
  final String? badgeLabel;

  @override
  List<Object?> get props => [id, type, title, badgeLabel];
}
