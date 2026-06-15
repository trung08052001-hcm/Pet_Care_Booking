import 'package:app/features/services/domain/entities/pet_care_service.dart';
import 'package:app/features/services/domain/entities/service_category_filter.dart';
import 'package:app/features/services/domain/entities/services_page_content.dart';
import 'package:injectable/injectable.dart';

@lazySingleton
class ServicesMockDataSource {
  ServicesPageContent getPageContent() {
    return const ServicesPageContent(
      title: 'Dịch vụ chăm sóc',
      subtitle: 'Tận tâm nâng niu thú cưng của bạn mỗi ngày',
      services: [
        PetCareService(
          id: 'grooming',
          slug: 'grooming',
          title: 'Grooming',
          description: 'Tắm, sấy, cắt tỉa và vệ sinh cơ bản cho thú cưng',
          detail:
              'Gói grooming giúp thú cưng sạch sẽ, thơm hơn và thoải mái hơn sau mỗi lần chăm sóc.',
          priceText: 'Từ 150.000đ',
          image:
              'https://images.unsplash.com/photo-1516734212186-a967f81ad0d7?auto=format&fit=crop&w=900&q=80',
          category: ServiceCategoryFilter.all,
          badge: 'FEATURED',
          isFeatured: true,
          icon: 'scissors',
          ratingText: '4.8 (1.2k)',
          usageText: '1.2k lượt đặt',
          durationText: '60 phút',
          promoTitle: 'Ưu đãi độc quyền',
          promoDescription: 'Giảm 20% cho lần đặt Grooming đầu tiên',
          promoDiscountText: '-20%',
          includedItems: [
            'Tắm bằng sữa tắm chuyên dụng',
            'Sấy khô và chải lông',
            'Cắt tỉa lông cơ bản',
            'Vệ sinh tai, mắt',
            'Cắt móng an toàn',
            'Xịt thơm nhẹ sau khi hoàn tất',
          ],
          benefits: [
            'Giúp thú cưng sạch sẽ và thơm hơn',
            'Lông mềm mượt, hạn chế rối lông',
            'Hạn chế vi khuẩn và mùi hôi trên da',
            'Giúp bé cưng thoải mái, dễ chịu hơn',
            'Tăng tính thẩm mỹ cho thú cưng',
          ],
          noticeText:
              'Nên đặt lịch trước ít nhất 2 tiếng để trung tâm chuẩn bị tốt nhất.',
        ),
        PetCareService(
          id: 'pet-hotel',
          slug: 'pet-hotel',
          title: 'Pet Hotel',
          description: 'Khách sạn thú cưng an toàn, sạch sẽ khi bạn đi xa',
          detail:
              'Pet Hotel cung cấp không gian lưu trú riêng tư, sạch sẽ và được chăm sóc theo lịch.',
          priceText: 'Từ 250.000đ',
          image:
              'https://images.unsplash.com/photo-1560743641-3914f2c45636?auto=format&fit=crop&w=900&q=80',
          category: ServiceCategoryFilter.all,
          badge: 'HOTEL',
          isFeatured: true,
          icon: 'hotel',
          ratingText: '4.9 (896)',
          usageText: '896 lượt đặt',
          durationText: 'Theo ngày',
          promoTitle: 'Ưu đãi đặc biệt',
          promoDescription: 'Giảm 15% khi đặt từ 2 ngày trở lên',
          promoDiscountText: '-15%',
          includedItems: [
            'Không gian lưu trú riêng cho thú cưng',
            'Cho ăn theo lịch của chủ',
            'Thay nước sạch mỗi ngày',
            'Dọn vệ sinh khu vực ở',
            'Theo dõi tình trạng sức khỏe cơ bản',
            'Cập nhật hình ảnh thú cưng cho chủ',
          ],
          benefits: [
            'An toàn, sạch sẽ, thoải mái như ở nhà',
            'Được chăm sóc và chơi đùa mỗi ngày',
            'Chủ nhận ảnh/video cập nhật mỗi ngày',
            'Giảm stress khi có người chăm sóc',
            'Có không gian riêng để nghỉ ngơi',
          ],
          noticeText:
              'Nên đặt trước ít nhất 6 tiếng để chúng tôi chuẩn bị phòng cho bé.',
        ),
        PetCareService(
          id: 'veterinarian',
          slug: 'veterinarian',
          title: 'Bác sĩ thú y',
          description:
              'Khám sức khỏe, tư vấn điều trị và theo dõi tình trạng thú cưng',
          detail:
              'Dịch vụ bác sĩ thú y giúp kiểm tra sức khỏe tổng quát, tư vấn dinh dưỡng và đề xuất lịch tái khám phù hợp.',
          priceText: 'Từ 200.000đ',
          image:
              'https://images.unsplash.com/photo-1628009368231-7bb7cfcb0def?auto=format&fit=crop&w=900&q=80',
          category: ServiceCategoryFilter.all,
          badge: 'HEALTH',
          isFeatured: true,
          icon: 'medical',
          ratingText: '4.9 (1.5k)',
          usageText: '1.5k lượt đặt',
          durationText: '30 phút',
          promoTitle: 'Ưu đãi cho khách mới',
          promoDescription: 'Miễn phí tư vấn nhanh 10 phút qua chat hoặc gọi',
          promoDiscountText: '0đ',
          promoTone: 'green',
          includedItems: [
            'Khám sức khỏe tổng quát',
            'Kiểm tra da, lông, mắt, tai',
            'Tư vấn tình trạng ăn uống',
            'Tư vấn điều trị cơ bản',
            'Đề xuất lịch tiêm phòng/tái khám',
            'Lưu hồ sơ sức khỏe thú cưng',
          ],
          benefits: [
            'Phát hiện sớm vấn đề sức khỏe',
            'Điều trị và chăm sóc kịp thời',
            'Cách chăm sóc và dinh dưỡng phù hợp',
            'Theo dõi hồ sơ sức khỏe dễ dàng',
            'Giảm rủi ro bệnh nặng do phát hiện trễ',
          ],
          noticeText:
              'Nếu bé có dấu hiệu bất thường, vui lòng đặt lịch sớm để được hỗ trợ kịp thời.',
        ),
        PetCareService(
          id: 'dog-grooming-cleaning',
          title: 'Cắt tỉa & Vệ sinh chó',
          description:
              'Tắm gội, vệ sinh tai, cắt móng, chải lông và khử mùi cho chó.',
          detail:
              'Phù hợp với chó nhỏ, chó vừa và chó lớn. Có thể chọn gói tắm thường, tắm khử mùi hoặc tắm trị ve rận.',
          priceText: 'Từ 250.000đ',
          image:
              'https://images.unsplash.com/photo-1516734212186-a967f81ad0d7?auto=format&fit=crop&w=900&q=80',
          category: ServiceCategoryFilter.dog,
          badge: 'POPULAR',
        ),
        PetCareService(
          id: 'dog-spa-relax',
          title: 'Spa & Thư giãn cho chó',
          description:
              'Massage thư giãn, dưỡng lông và chăm sóc da cho chó sau thời gian vận động.',
          detail:
              'Dành cho chó bị rụng lông, khô da, mệt mỏi hoặc cần chăm sóc ngoại hình.',
          priceText: 'Từ 350.000đ',
          image:
              'https://images.unsplash.com/photo-1583337130417-3346a1be7dee?auto=format&fit=crop&w=900&q=80',
          category: ServiceCategoryFilter.dog,
          badge: 'SPA',
        ),
        PetCareService(
          id: 'dog-hotel',
          title: 'Khách sạn chó',
          description:
              'Nơi lưu trú an toàn khi chủ bận, đi công tác hoặc du lịch.',
          detail:
              'Có khu vực nghỉ riêng, cho ăn theo lịch, vệ sinh hằng ngày và cập nhật hình ảnh cho chủ nuôi.',
          priceText: 'Từ 400.000đ / ngày',
          image:
              'https://images.unsplash.com/photo-1560743641-3914f2c45636?auto=format&fit=crop&w=900&q=80',
          category: ServiceCategoryFilter.dog,
          badge: 'HOTEL',
        ),
        PetCareService(
          id: 'dog-health-care',
          title: 'Chăm sóc Y tế cho chó',
          description:
              'Khám sức khỏe, tư vấn dinh dưỡng, tiêm phòng và kiểm tra định kỳ.',
          detail:
              'Phù hợp với chó con, chó trưởng thành hoặc chó lớn tuổi cần theo dõi sức khỏe thường xuyên.',
          priceText: 'Từ 500.000đ',
          image:
              'https://images.unsplash.com/photo-1628009368231-7bb7cfcb0def?auto=format&fit=crop&w=900&q=80',
          category: ServiceCategoryFilter.dog,
          badge: 'HEALTH',
        ),
        PetCareService(
          id: 'cat-bath-cleaning',
          title: 'Tắm & Vệ sinh mèo',
          description:
              'Tắm nhẹ nhàng, vệ sinh tai, cắt móng và làm sạch lông cho mèo.',
          detail:
              'Phù hợp với mèo lông ngắn, mèo lông dài hoặc mèo ít được tắm. Quy trình nhẹ nhàng để giảm căng thẳng.',
          priceText: 'Từ 220.000đ',
          image:
              'https://images.unsplash.com/photo-1518791841217-8f162f1e1131?auto=format&fit=crop&w=900&q=80',
          category: ServiceCategoryFilter.cat,
          badge: 'CARE',
        ),
        PetCareService(
          id: 'cat-grooming',
          title: 'Chải lông & Gỡ rối',
          description:
              'Chăm sóc lông, gỡ rối, giảm rụng lông và làm sạch lớp lông chết.',
          detail:
              'Đặc biệt phù hợp với mèo Anh lông dài, Ba Tư, Ragdoll hoặc các bé mèo hay rụng lông.',
          priceText: 'Từ 280.000đ',
          image:
              'https://images.unsplash.com/photo-1573865526739-10659fec78a5?auto=format&fit=crop&w=900&q=80',
          category: ServiceCategoryFilter.cat,
          badge: 'GROOMING',
        ),
        PetCareService(
          id: 'cat-spa',
          title: 'Spa thư giãn cho mèo',
          description:
              'Massage nhẹ, dưỡng lông và chăm sóc da dành riêng cho mèo.',
          detail:
              'Giúp mèo thư giãn, giảm căng thẳng, lông mềm hơn và hạn chế mùi khó chịu.',
          priceText: 'Từ 320.000đ',
          image:
              'https://images.unsplash.com/photo-1543852786-1cf6624b9987?auto=format&fit=crop&w=900&q=80',
          category: ServiceCategoryFilter.cat,
          badge: 'SPA',
        ),
        PetCareService(
          id: 'cat-hotel',
          title: 'Khách sạn mèo',
          description:
              'Không gian lưu trú riêng tư, yên tĩnh và sạch sẽ cho mèo.',
          detail:
              'Mỗi bé có khu vực nghỉ riêng, được cho ăn đúng giờ, vệ sinh cát và cập nhật tình trạng hằng ngày.',
          priceText: 'Từ 350.000đ / ngày',
          image:
              'https://images.unsplash.com/photo-1514888286974-6c03e2ca1dba?auto=format&fit=crop&w=900&q=80',
          category: ServiceCategoryFilter.cat,
          badge: 'HOTEL',
        ),
      ],
    );
  }
}
