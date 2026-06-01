import 'package:app/core/common/typedefs.dart';
import 'package:app/core/usecase/usecase.dart';
import 'package:app/features/pets/domain/entities/my_pets_page_content.dart';
import 'package:app/features/pets/domain/repositories/pets_repository.dart';
import 'package:injectable/injectable.dart';

@injectable
class GetMyPetsPageContentUseCase
    implements UseCase<MyPetsPageContent, NoParams> {
  GetMyPetsPageContentUseCase(this._repository);

  final PetsRepository _repository;

  @override
  ResultFuture<MyPetsPageContent> call(NoParams params) {
    return _repository.getMyPetsPageContent();
  }
}
