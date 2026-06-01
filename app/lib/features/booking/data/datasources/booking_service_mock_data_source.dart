import 'package:app/features/booking/domain/entities/bookable_service.dart';
import 'package:app/features/booking/domain/entities/bookable_service_icon.dart';
import 'package:app/features/booking/domain/entities/booking_service_page_content.dart';
import 'package:injectable/injectable.dart';

@lazySingleton
class BookingServiceMockDataSource {
  BookingServicePageContent getPageContent() {
    return const BookingServicePageContent(
      title: 'Bạn cần dịch vụ gì?',
      subtitle:
          'Hãy chọn một hoặc nhiều dịch vụ chăm sóc tốt nhất cho người bạn nhỏ của bạn.',
      services: [
        BookableService(
          id: 'booking-grooming',
          title: 'Cắt tỉa',
          description: 'Cắt tỉa lông, tạo kiểu và vệ sinh tai móng.',
          priceVnd: 200000,
          icon: BookableServiceIcon.spa,
          iconBackgroundColor: 0xFFFFE8D6,
          tagLabel: '45-60 phút',
        ),
        BookableService(
          id: 'booking-spa',
          title: 'Tắm & Spa',
          description:
              'Tắm gội, sấy khô, cắt móng và massage thư giãn cho thú cưng.',
          priceVnd: 250000,
          icon: BookableServiceIcon.spa,
          iconBackgroundColor: 0xFFFFE8D6,
          tagLabel: '60-90 phút',
        ),
        BookableService(
          id: 'booking-boarding',
          title: 'Lưu trú',
          description:
              'Phòng riêng, camera 24/7 và chăm sóc tận tình khi bạn vắng nhà.',
          priceVnd: 150000,
          priceUnitSuffix: '/ngày',
          icon: BookableServiceIcon.boarding,
          iconBackgroundColor: 0xFFE8EEF2,
          tagLabel: 'Tiêu chuẩn 5 sao',
        ),
        BookableService(
          id: 'booking-health',
          title: 'Khám sức khỏe',
          description:
              'Khám tổng quát, tư vấn dinh dưỡng và theo dõi sức khỏe định kỳ.',
          priceVnd: 300000,
          icon: BookableServiceIcon.healthCheck,
          iconBackgroundColor: 0xFFE8EEF2,
          tagLabel: 'Bác sĩ riêng',
        ),
        BookableService(
          id: 'booking-walking',
          title: 'Dắt pet đi dạo',
          description:
              'Vận động ngoài trời, social hóa và tiêu hao năng lượng an toàn.',
          priceVnd: 100000,
          priceUnitSuffix: '/giờ',
          icon: BookableServiceIcon.walking,
          iconBackgroundColor: 0xFFFFE8D6,
          tagLabel: 'Công viên xanh',
        ),
      ],
      tipTitle: 'MẸO NHỎ',
      tipBody:
          'Bạn có thể chọn nhiều dịch vụ cùng lúc để tiết kiệm thời gian khi đến cửa hàng.',
      totalLabel: 'Tổng thanh toán',
      continueLabel: 'Tiếp tục',
    );
  }

  static String? mapCatalogServiceId(String? catalogId) {
    if (catalogId == null) {
      return null;
    }
    return switch (catalogId) {
      'grooming-cleaning' => 'booking-grooming',
      'pet-hotel' => 'booking-boarding',
      'spa-relax' => 'booking-spa',
      'medical-care' => 'booking-health',
      _ => catalogId,
    };
  }
}
