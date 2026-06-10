import 'package:app/features/profile/domain/entities/help_center_category.dart';
import 'package:app/features/profile/domain/entities/help_center_content.dart';
import 'package:flutter/material.dart';

class HelpCenterMockDataSource {
  const HelpCenterMockDataSource();

  HelpCenterContent getContent() {
    return const HelpCenterContent(
      categories: [
        HelpCenterCategory(
          id: 'pets',
          title: 'Thú cưng',
          subtitle: 'Chăm sóc, sức khỏe, hành vi...',
          icon: Icons.pets_rounded,
        ),
        HelpCenterCategory(
          id: 'booking',
          title: 'Đặt lịch & dịch vụ',
          subtitle: 'Đặt lịch, thay đổi, hủy lịch...',
          icon: Icons.calendar_month_outlined,
        ),
        HelpCenterCategory(
          id: 'payment',
          title: 'Thanh toán',
          subtitle: 'Ví Pawtitive, giao dịch, hoàn tiền...',
          icon: Icons.account_balance_wallet_outlined,
        ),
        HelpCenterCategory(
          id: 'account',
          title: 'Tài khoản & bảo mật',
          subtitle: 'Thông tin tài khoản, bảo mật...',
          icon: Icons.verified_user_outlined,
        ),
      ],
      faqs: [
        'Làm thế nào để đặt lịch dịch vụ?',
        'Phương thức thanh toán nào được chấp nhận?',
        'Tôi có thể hủy hoặc đổi lịch hẹn không?',
        'Làm thế nào để liên hệ với hỗ trợ?',
        'Làm sao để thêm thú cưng mới?',
      ],
    );
  }
}
