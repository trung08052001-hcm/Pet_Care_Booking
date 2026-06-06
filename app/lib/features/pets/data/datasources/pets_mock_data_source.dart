import 'package:app/features/pets/domain/entities/my_pets_page_content.dart';

import 'package:app/features/pets/domain/entities/pet.dart';

import 'package:app/features/pets/domain/entities/pet_gender.dart';

import 'package:app/features/pets/domain/entities/pet_health_status.dart';

import 'package:app/features/pets/domain/entities/pet_promo_banner.dart';

import 'package:injectable/injectable.dart';



@lazySingleton

class PetsMockDataSource {

  MyPetsPageContent getPageContent({List<Pet>? pets}) {

    return MyPetsPageContent(

      title: 'Thú cưng của tôi',

      subtitle: 'Chọn thú cưng để tiếp tục đặt lịch hẹn.',

      pets: pets ?? const [

        Pet(

          id: 'pet-mochi',

          name: 'Mochi',

          breed: 'Poodle',

          ageLabel: '2 tuổi',

          weightLabel: '4.5kg',

          gender: PetGender.female,

          healthStatus: PetHealthStatus.good,

          reminderLabel: 'Tiêm chủng 15/10',

          imagePlaceholderColor: 0xFFE8D5C4,

        ),

        Pet(

          id: 'pet-lulu',

          name: 'LuLu',

          breed: 'Corgi',

          ageLabel: '3 tuổi',

          weightLabel: '12kg',

          gender: PetGender.male,

          healthStatus: PetHealthStatus.needsRevisit,

          reminderLabel: 'Tái khám 20/10',

          imagePlaceholderColor: 0xFFD4E4E8,

        ),

      ],

      addPetLabel: 'Thêm thú cưng khác?',

      promoBanner: const PetPromoBanner(

        title: 'Chăm sóc tốt nhất',

        description:

            'Chúng tôi luôn đồng hành cùng sức khỏe thú cưng của bạn.',

        ctaLabel: 'Khám phá ngay',

      ),

    );

  }

}

