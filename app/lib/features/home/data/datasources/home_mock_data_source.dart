import 'package:app/features/home/domain/entities/home_dashboard.dart';
import 'package:app/features/home/domain/entities/home_featured_service.dart';
import 'package:app/features/home/domain/entities/home_pet_tip.dart';
import 'package:app/features/home/domain/entities/home_promo.dart';
import 'package:app/features/home/domain/entities/home_welcome.dart';
import 'package:injectable/injectable.dart';

@lazySingleton
class HomeMockDataSource {
  HomeDashboard getDashboard({String petName = 'Luna'}) {
    return HomeDashboard(
      welcome: HomeWelcome(
        greeting: _greetingForHour(DateTime.now().hour),
        title: 'Chào mừng $petName\nvà bạn!',
        bookCtaLabel: 'Đặt lịch ngay',
        petName: petName,
      ),
      featuredServices: const [
        HomeFeaturedService(
          id: 'grooming',
          type: HomeFeaturedServiceType.grooming,
          label: 'Grooming',
        ),
        HomeFeaturedService(
          id: 'pet-hotel',
          type: HomeFeaturedServiceType.petHotel,
          label: 'Pet Hotel',
        ),
        HomeFeaturedService(
          id: 'vet',
          type: HomeFeaturedServiceType.veterinarian,
          label: 'Bác sĩ thú y',
        ),
      ],
      promo: const HomePromo(
        badgeLabel: 'ƯU ĐÃI ĐỘC QUYỀN',
        title: 'Giảm 20% cho lần\nghé thăm đầu tiên',
        subtitle: 'Dành cho dịch vụ Spa & Hotel',
        ctaLabel: 'Nhận mã ngay',
      ),
      petTips: const [
        HomePetTip(
          id: 'tip-health-1',
          category: 'SỨC KHỎE',
          title:
              '5 dấu hiệu cho thấy thú cưng của bạn đang cần được nghỉ ngơi',
          imagePlaceholderColor: 0xFFE8D5C4,
        ),
        HomePetTip(
          id: 'tip-nutrition-1',
          category: 'DINH DƯỠNG',
          title: 'Chế độ ăn cân bằng cho chó con trong 6 tháng đầu',
          imagePlaceholderColor: 0xFFD4E4E8,
        ),
      ],
    );
  }

  String _greetingForHour(int hour) {
    if (hour < 12) {
      return 'Chào buổi sáng,';
    }
    if (hour < 18) {
      return 'Chào buổi chiều,';
    }
    return 'Chào buổi tối,';
  }
}
