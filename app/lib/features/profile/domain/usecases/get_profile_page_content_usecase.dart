import 'package:app/core/common/typedefs.dart';
import 'package:app/core/usecase/usecase.dart';
import 'package:app/features/profile/domain/entities/profile_page_content.dart';
import 'package:app/features/profile/domain/repositories/profile_repository.dart';
import 'package:injectable/injectable.dart';

@injectable
class GetProfilePageContentUseCase
    implements UseCase<ProfilePageContent, NoParams> {
  GetProfilePageContentUseCase(this._repository);

  final ProfileRepository _repository;

  @override
  ResultFuture<ProfilePageContent> call(NoParams params) {
    return _repository.getProfilePageContent();
  }
}
