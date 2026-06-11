import 'package:app/app/theme/app_colors.dart';
import 'package:app/core/app_localizations.dart';
import 'package:app/features/authentication/presentation/pages/sign_in_page.dart';
import 'package:app/features/booking/presentation/pages/booking_history_page.dart';
import 'package:app/features/pets/presentation/pages/profile_my_pets_page.dart';
import 'package:app/features/profile/domain/entities/profile_menu_item.dart';
import 'package:app/features/profile/domain/entities/profile_menu_item_type.dart';
import 'package:app/features/profile/domain/entities/profile_page_content.dart';
import 'package:app/features/profile/domain/entities/profile_user.dart';
import 'package:app/features/profile/presentation/bloc/profile_bloc.dart';
import 'package:app/features/profile/presentation/bloc/profile_event.dart';
import 'package:app/features/profile/presentation/bloc/profile_state.dart';
import 'package:app/features/profile/presentation/mappers/profile_ui_mapper.dart';
import 'package:app/features/profile/presentation/pages/app_review_page.dart';
import 'package:app/features/profile/presentation/pages/help_center_page.dart';
import 'package:app/features/profile/presentation/pages/language_settings_page.dart';
import 'package:app/features/profile/presentation/pages/profile_address_page.dart';
import 'package:app/features/profile/presentation/pages/profile_edit_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ProfileBloc, ProfileState>(
      listenWhen: (previous, current) =>
          current.interaction == ProfileInteraction.logoutCompleted,
      listener: (context, state) {
        context.goNamed(SignInPage.routeName);
      },
      builder: (context, state) {
        if (state.status == ProfileStatus.failure) {
          return _ProfileErrorView(
            message: state.message ?? 'Không tải được hồ sơ.',
            onRetry: () =>
                context.read<ProfileBloc>().add(const ProfileRefreshRequested()),
          );
        }

        if (state.isLoading || state.content == null) {
          return const Center(
            child: CircularProgressIndicator(color: AppColors.primary),
          );
        }

        return Stack(
          children: [
            _ProfileContent(content: state.content!),
            if (state.isLoggingOut)
              const ColoredBox(
                color: Color(0x55FFFFFF),
                child: Center(
                  child: CircularProgressIndicator(color: AppColors.primary),
                ),
              ),
          ],
        );
      },
    );
  }
}

class _ProfileErrorView extends StatelessWidget {
  const _ProfileErrorView({
    required this.message,
    required this.onRetry,
  });

  final String message;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              message,
              textAlign: TextAlign.center,
              style: const TextStyle(color: AppColors.mutedText),
            ),
            const SizedBox(height: 16),
            FilledButton(
              onPressed: onRetry,
              child: const Text('Thử lại'),
            ),
          ],
        ),
      ),
    );
  }
}

class _ProfileContent extends StatelessWidget {
  const _ProfileContent({required this.content});

  final ProfilePageContent content;

  @override
  Widget build(BuildContext context) {
    final bloc = context.read<ProfileBloc>();
    final l10n = AppLocalizations.of(context);

    return RefreshIndicator(
      color: AppColors.primary,
      onRefresh: () async {
        bloc.add(const ProfileRefreshRequested());
        await bloc.stream.firstWhere(
          (state) =>
              state.status == ProfileStatus.success ||
              state.status == ProfileStatus.failure,
        );
      },
      child: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(
            child: _ProfileAppBar(
              onNotificationsPressed: () =>
                  bloc.add(const ProfileNotificationsPressed()),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
              child: Column(
                children: [
                  _ProfileHeader(
                    user: content.user,
                    memberSinceLabel: l10n.profileMemberSince,
                    editProfileLabel: l10n.profileEditLabel,
                    onEditProfile: () =>
                        context.pushNamed(ProfileEditPage.routeName),
                    onChangeAvatar: () =>
                        bloc.add(const ProfileAvatarChangePressed()),
                  ),
                  const SizedBox(height: 20),
                  _MenuCard(
                    items: content.mainMenuItems,
                    onItemTap: (type) {
                      if (type == ProfileMenuItemType.myPets) {
                        context.pushNamed(ProfileMyPetsPage.routeName);
                        return;
                      }
                      if (type == ProfileMenuItemType.bookingHistory) {
                        context.pushNamed(BookingHistoryPage.routeName);
                        return;
                      }
                      if (type == ProfileMenuItemType.addresses) {
                        context.pushNamed(ProfileAddressPage.routeName);
                        return;
                      }
                      bloc.add(ProfileMenuItemPressed(type));
                    },
                  ),
                  const SizedBox(height: 24),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      l10n.profileSupportTitle,
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        letterSpacing: 0.6,
                        color: AppColors.mutedText.withValues(alpha: 0.95),
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  _MenuCard(
                    items: content.supportMenuItems,
                    onItemTap: (type) {
                      if (type == ProfileMenuItemType.helpCenter) {
                        context.pushNamed(HelpCenterPage.routeName);
                        return;
                      }
                      if (type == ProfileMenuItemType.rateApp) {
                        context.pushNamed(AppReviewPage.routeName);
                        return;
                      }
                      if (type == ProfileMenuItemType.language) {
                        context.pushNamed(LanguageSettingsPage.routeName);
                        return;
                      }
                      bloc.add(ProfileMenuItemPressed(type));
                    },
                  ),
                  const SizedBox(height: 28),
                  _LogoutButton(
                    label: l10n.profileLogout,
                    onPressed: () => bloc.add(const ProfileLogoutPressed()),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    l10n.profileVersion,
                    style: const TextStyle(
                      fontSize: 12,
                      color: AppColors.mutedText,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _ProfileAppBar extends StatelessWidget {
  const _ProfileAppBar({required this.onNotificationsPressed});

  final VoidCallback onNotificationsPressed;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      bottom: false,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 8, 8, 4),
        child: Row(
          children: [
            Container(
              width: 32,
              height: 32,
              decoration: BoxDecoration(
                color: AppColors.primary.withValues(alpha: 0.15),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.pets_rounded,
                size: 18,
                color: AppColors.primary,
              ),
            ),
            const SizedBox(width: 8),
            const Text(
              'PawSitive Care',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w700,
                color: AppColors.brown,
                letterSpacing: -0.3,
              ),
            ),
            const Spacer(),
            IconButton(
              onPressed: onNotificationsPressed,
              icon: const Icon(
                Icons.notifications_none_rounded,
                color: AppColors.brownText,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ProfileHeader extends StatelessWidget {
  const _ProfileHeader({
    required this.user,
    required this.memberSinceLabel,
    required this.editProfileLabel,
    required this.onEditProfile,
    required this.onChangeAvatar,
  });

  final ProfileUser user;
  final String memberSinceLabel;
  final String editProfileLabel;
  final VoidCallback onEditProfile;
  final VoidCallback onChangeAvatar;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Stack(
          children: [
            CircleAvatar(
              radius: 48,
              backgroundColor: AppColors.heroBg,
              child: Text(
                user.avatarInitials ??
                    (user.fullName.isNotEmpty ? user.fullName[0] : '?'),
                style: const TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.w700,
                  color: AppColors.brown,
                ),
              ),
            ),
            Positioned(
              right: 0,
              bottom: 0,
              child: GestureDetector(
                onTap: onChangeAvatar,
                child: Container(
                  width: 32,
                  height: 32,
                  decoration: const BoxDecoration(
                    color: AppColors.brown,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.photo_camera_outlined,
                    color: Colors.white,
                    size: 16,
                  ),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 14),
        Text(
          user.fullName,
          style: const TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.w800,
            color: AppColors.brownText,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          memberSinceLabel,
          style: TextStyle(
            fontSize: 14,
            color: AppColors.brownText.withValues(alpha: 0.65),
          ),
        ),
        const SizedBox(height: 18),
        SizedBox(
          width: double.infinity,
          child: FilledButton(
            onPressed: onEditProfile,
            style: FilledButton.styleFrom(
              backgroundColor: AppColors.brown,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 14),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(28),
              ),
              elevation: 0,
            ),
            child: Text(
              editProfileLabel,
              style: const TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _MenuCard extends StatelessWidget {
  const _MenuCard({
    required this.items,
    required this.onItemTap,
  });

  final List<ProfileMenuItem> items;
  final void Function(ProfileMenuItemType type) onItemTap;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.cardBg,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: List.generate(items.length, (index) {
          final item = items[index];
          final isLast = index == items.length - 1;

          return Column(
            children: [
              _MenuTile(
                item: item,
                onTap: () => onItemTap(item.type),
              ),
              if (!isLast)
                Divider(
                  height: 1,
                  indent: 56,
                  color: AppColors.divider.withValues(alpha: 0.7),
                ),
            ],
          );
        }),
      ),
    );
  }
}

class _MenuTile extends StatelessWidget {
  const _MenuTile({
    required this.item,
    required this.onTap,
  });

  final ProfileMenuItem item;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: onTap,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      leading: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          color: AppColors.primary.withValues(alpha: 0.12),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Icon(
          ProfileUiMapper.menuIcon(item.type),
          color: AppColors.primary,
          size: 22,
        ),
      ),
      title: Text(
        _titleFor(AppLocalizations.of(context), item.type),
        style: const TextStyle(
          fontSize: 15,
          fontWeight: FontWeight.w600,
          color: AppColors.brownText,
        ),
      ),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (item.badgeLabel != null)
            Container(
              margin: const EdgeInsets.only(right: 8),
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: AppColors.primary.withValues(alpha: 0.15),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Text(
                item.badgeLabel!,
                style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                  color: AppColors.primary,
                ),
              ),
            ),
          Icon(
            Icons.chevron_right_rounded,
            color: AppColors.mutedText.withValues(alpha: 0.8),
          ),
        ],
      ),
    );
  }

  String _titleFor(AppLocalizations l10n, ProfileMenuItemType type) {
    return switch (type) {
      ProfileMenuItemType.myPets => l10n.profileMyPets,
      ProfileMenuItemType.bookingHistory => l10n.profileBookingHistory,
      ProfileMenuItemType.wallet => l10n.profileWallet,
      ProfileMenuItemType.addresses => l10n.profileAddresses,
      ProfileMenuItemType.helpCenter => l10n.profileHelpCenter,
      ProfileMenuItemType.rateApp => l10n.profileRateApp,
      ProfileMenuItemType.language => l10n.profileLanguage,
    };
  }
}

class _LogoutButton extends StatelessWidget {
  const _LogoutButton({
    required this.label,
    required this.onPressed,
  });

  final String label;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return TextButton.icon(
      onPressed: onPressed,
      icon: const Icon(
        Icons.logout_rounded,
        color: Color(0xFFE53935),
        size: 22,
      ),
      label: Text(
        label,
        style: const TextStyle(
          fontSize: 15,
          fontWeight: FontWeight.w600,
          color: Color(0xFFE53935),
        ),
      ),
    );
  }
}
