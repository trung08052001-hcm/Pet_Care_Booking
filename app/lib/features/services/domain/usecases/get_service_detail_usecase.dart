import 'package:app/core/common/typedefs.dart';
import 'package:app/core/usecase/usecase.dart';
import 'package:app/features/services/domain/entities/pet_care_service.dart';
import 'package:app/features/services/domain/repositories/services_repository.dart';
import 'package:equatable/equatable.dart';

class GetServiceDetailParams extends Equatable {
  const GetServiceDetailParams(this.serviceId);

  final String serviceId;

  @override
  List<Object?> get props => [serviceId];
}

class GetServiceDetailUseCase
    implements UseCase<PetCareService, GetServiceDetailParams> {
  const GetServiceDetailUseCase(this._repository);

  final ServicesRepository _repository;

  @override
  ResultFuture<PetCareService> call(GetServiceDetailParams params) {
    return _repository.getServiceDetail(params.serviceId);
  }
}
