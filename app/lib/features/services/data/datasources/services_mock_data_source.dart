import 'package:app/features/services/domain/entities/pet_care_service.dart';
import 'package:app/features/services/domain/entities/service_pet_type.dart';
import 'package:app/features/services/domain/entities/services_page_content.dart';
import 'package:injectable/injectable.dart';

@lazySingleton
class ServicesMockDataSource {
  ServicesPageContent getPageContent() {
    return const ServicesPageContent(
      title: 'Dịch vụ chăm sóc',
      subtitle: 'Tận tâm nâng niu thú cưng của bạn mỗi ngày',
      services: const [
        PetCareService(
          id: 'grooming-cleaning',
          title: 'Cắt tỉa & Vệ sinh',
          description:
              'Tắm gội, cắt tỉa lông, vệ sinh tai và móng chuyên nghiệp, '
              'giúp thú cưng luôn sạch sẽ và thơm tho.',
          priceFromVnd: 250000,
          petTypes: [ServicePetType.dog, ServicePetType.cat],
          imagePlaceholderColor: 0xFFE8D5C4,
          isPopular: true,
        ),
        PetCareService(
          id: 'pet-hotel',
          title: 'Khách sạn thú cưng',
          description:
              'Phòng riêng tiện nghi, camera giám sát 24/7 và chế độ '
              'chăm sóc tận tình khi bạn vắng nhà.',
          priceFromVnd: 400000,
          petTypes: [ServicePetType.dog, ServicePetType.cat],
          imagePlaceholderColor: 0xFFD4E4E8,
        ),
        PetCareService(
          id: 'spa-relax',
          title: 'Spa & Thư giãn',
          description:
              'Massage thư giãn, liệu trình da lông và tắm bùn khoáng '
              'dành cho thú cưng cần nghỉ ngơi.',
          priceFromVnd: 350000,
          petTypes: [ServicePetType.dog, ServicePetType.cat],
          imagePlaceholderColor: 0xFFF5E6D3,
        ),
        PetCareService(
          id: 'medical-care',
          title: 'Chăm sóc Y tế',
          description:
              'Khám sức khỏe định kỳ, tiêm phòng và tư vấn dinh dưỡng '
              'cùng đội ngũ bác sĩ thú y.',
          priceFromVnd: 500000,
          petTypes: [ServicePetType.dog, ServicePetType.cat],
          imagePlaceholderColor: 0xFFE0E8F0,
        ),
      ],
    );
  }
}
