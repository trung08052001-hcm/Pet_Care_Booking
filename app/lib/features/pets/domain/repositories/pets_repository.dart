import 'package:app/core/common/typedefs.dart';
import 'package:app/features/pets/domain/entities/my_pets_page_content.dart';

abstract interface class PetsRepository {
  ResultFuture<MyPetsPageContent> getMyPetsPageContent();
}
