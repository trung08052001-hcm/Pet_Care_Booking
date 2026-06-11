import 'package:app/features/profile/domain/entities/profile_menu_item_type.dart';
import 'package:flutter/material.dart';

abstract final class ProfileUiMapper {
  static IconData menuIcon(ProfileMenuItemType type) {
    return switch (type) {
      ProfileMenuItemType.myPets => Icons.pets_rounded,
      ProfileMenuItemType.bookingHistory => Icons.event_note_outlined,
      ProfileMenuItemType.wallet => Icons.account_balance_wallet_outlined,
      ProfileMenuItemType.addresses => Icons.location_on_outlined,
      ProfileMenuItemType.helpCenter => Icons.help_outline_rounded,
      ProfileMenuItemType.rateApp => Icons.star_outline_rounded,
      ProfileMenuItemType.language => Icons.language_rounded,
    };
  }
}
