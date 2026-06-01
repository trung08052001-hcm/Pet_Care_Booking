import 'package:app/core/common/typedefs.dart';
import 'package:app/core/usecase/usecase.dart';
import 'package:app/features/home/domain/entities/home_dashboard.dart';
import 'package:app/features/home/domain/repositories/home_repository.dart';
import 'package:injectable/injectable.dart';

@injectable
class GetHomeDashboardUseCase implements UseCase<HomeDashboard, NoParams> {
  GetHomeDashboardUseCase(this._repository);

  final HomeRepository _repository;

  @override
  ResultFuture<HomeDashboard> call(NoParams params) {
    return _repository.getHomeDashboard();
  }
}
