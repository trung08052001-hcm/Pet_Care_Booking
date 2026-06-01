import 'package:app/core/common/typedefs.dart';
import 'package:app/core/usecase/usecase.dart';
import 'package:app/features/services/domain/entities/services_page_content.dart';
import 'package:app/features/services/domain/repositories/services_repository.dart';
import 'package:injectable/injectable.dart';

@injectable
class GetServicesPageContentUseCase
    implements UseCase<ServicesPageContent, NoParams> {
  GetServicesPageContentUseCase(this._repository);

  final ServicesRepository _repository;

  @override
  ResultFuture<ServicesPageContent> call(NoParams params) {
    return _repository.getServicesPageContent();
  }
}
