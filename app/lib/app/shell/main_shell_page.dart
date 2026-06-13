import 'package:app/app/shell/presentation/bloc/main_shell_bloc.dart';
import 'package:app/app/shell/presentation/bloc/main_shell_event.dart';
import 'package:app/app/shell/presentation/bloc/main_shell_state.dart';
import 'package:app/app/shell/widgets/pawsitive_bottom_nav_bar.dart';
import 'package:app/app/theme/app_colors.dart';
import 'package:app/core/app_localizations.dart';
import 'package:app/features/blog/presentation/pages/blog_page.dart';
import 'package:app/features/chat/presentation/pages/chat_page.dart';
import 'package:app/features/home/presentation/pages/home_page.dart';
import 'package:app/features/profile/presentation/pages/profile_page.dart';
import 'package:app/features/services/presentation/pages/services_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class MainShellPage extends StatelessWidget {
  const MainShellPage({super.key});

  static const routeName = 'main-shell';
  static const routePath = '/home';
  static const chatTabIndex = 3;

  static const _pages = [
    HomePage(),
    ServicesPage(),
    BlogPage(),
    ChatPage(),
    ProfilePage(),
  ];

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final navItems = [
      PawsitiveNavItem(icon: Icons.home_rounded, label: l10n.navHome),
      PawsitiveNavItem(
        icon: Icons.medical_services_outlined,
        label: l10n.navServices,
      ),
      PawsitiveNavItem(icon: Icons.article_outlined, label: l10n.navBlog),
      PawsitiveNavItem(
        icon: Icons.chat_bubble_outline_rounded,
        label: l10n.navChat,
      ),
      PawsitiveNavItem(
        icon: Icons.person_outline_rounded,
        label: l10n.navProfile,
      ),
    ];

    return BlocBuilder<MainShellBloc, MainShellState>(
      builder: (context, state) {
        return Scaffold(
          backgroundColor: AppColors.scaffoldBg,
          body: IndexedStack(
            index: state.currentIndex,
            children: _pages,
          ),
          bottomNavigationBar: PawsitiveBottomNavBar(
            currentIndex: state.currentIndex,
            items: navItems,
            onTap: (index) => context.read<MainShellBloc>().add(
                  MainShellTabChanged(index),
                ),
          ),
        );
      },
    );
  }
}
