import 'package:app/app/shell/presentation/bloc/main_shell_bloc.dart';
import 'package:app/app/shell/presentation/bloc/main_shell_event.dart';
import 'package:app/app/shell/presentation/bloc/main_shell_state.dart';
import 'package:app/app/shell/widgets/pawsitive_bottom_nav_bar.dart';
import 'package:app/app/theme/app_colors.dart';
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

  static const _navItems = [
    PawsitiveNavItem(icon: Icons.home_rounded, label: 'Trang chủ'),
    PawsitiveNavItem(icon: Icons.medical_services_outlined, label: 'Dịch vụ'),
    PawsitiveNavItem(icon: Icons.article_outlined, label: 'Blog'),
    PawsitiveNavItem(icon: Icons.chat_bubble_outline_rounded, label: 'Chat'),
    PawsitiveNavItem(icon: Icons.person_outline_rounded, label: 'Profile'),
  ];

  static const _pages = [
    HomePage(),
    ServicesPage(),
    BlogPage(),
    ChatPage(),
    ProfilePage(),
  ];

  @override
  Widget build(BuildContext context) {
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
            items: _navItems,
            onTap: (index) => context.read<MainShellBloc>().add(
                  MainShellTabChanged(index),
                ),
          ),
        );
      },
    );
  }
}
