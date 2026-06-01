import 'package:app/features/profile/domain/entities/profile_menu_item.dart';
import 'package:app/features/profile/domain/entities/profile_menu_item_type.dart';
import 'package:app/features/profile/domain/entities/profile_page_content.dart';
import 'package:app/features/profile/domain/entities/profile_user.dart';
import 'package:injectable/injectable.dart';

@lazySingleton
class ProfileMockDataSource {
  ProfilePageContent getPageContent() {
    return const ProfilePageContent(
      user: ProfileUser(
        fullName: 'Nguyễn Minh',
        memberSinceLabel: 'Thành viên từ 2023',
        editProfileLabel: 'Chỉnh sửa hồ sơ',
        avatarInitials: 'NM',
      ),
      mainMenuItems: [
        ProfileMenuItem(
          id: 'menu-pets',
          type: ProfileMenuItemType.myPets,
          title: 'Thú cưng của tôi',
        ),
        ProfileMenuItem(
          id: 'menu-bookings',
          type: ProfileMenuItemType.bookingHistory,
          title: 'Lịch sử đặt chỗ',
        ),
        ProfileMenuItem(
          id: 'menu-wallet',
          type: ProfileMenuItemType.wallet,
          title: 'Ví Pawitive',
          badgeLabel: '800k',
        ),
        ProfileMenuItem(
          id: 'menu-addresses',
          type: ProfileMenuItemType.addresses,
          title: 'Địa chỉ của tôi',
        ),
      ],
      supportSectionTitle: 'HỖ TRỢ & ỨNG DỤNG',
      supportMenuItems: [
        ProfileMenuItem(
          id: 'menu-help',
          type: ProfileMenuItemType.helpCenter,
          title: 'Trung tâm trợ giúp',
        ),
        ProfileMenuItem(
          id: 'menu-rate',
          type: ProfileMenuItemType.rateApp,
          title: 'Đánh giá ứng dụng',
        ),
      ],
      logoutLabel: 'Đăng xuất',
      appVersionLabel: 'Phiên bản 2.4.0 (2024)',
    );
  }
}
