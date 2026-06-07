import 'package:app/core/common/typedefs.dart';
import 'package:app/core/usecase/usecase.dart';
import 'package:app/features/booking/domain/entities/appointment_page_content.dart';
import 'package:app/features/booking/domain/repositories/booking_appointment_repository.dart';
import 'package:equatable/equatable.dart';
import 'package:injectable/injectable.dart';

class GetAppointmentPageContentParams extends Equatable {
  const GetAppointmentPageContentParams({
    required this.petId,
    required this.serviceIds,
  });

  final String petId;
  final List<String> serviceIds;

  @override
  List<Object?> get props => [petId, serviceIds];
}

@injectable
class GetAppointmentPageContentUseCase
    implements
        UseCase<AppointmentPageContent, GetAppointmentPageContentParams> {
  GetAppointmentPageContentUseCase(this._repository);

  final BookingAppointmentRepository _repository;

  @override
  ResultFuture<AppointmentPageContent> call(
    GetAppointmentPageContentParams params,
  ) {
    return _repository.getAppointmentPageContent(
      petId: params.petId,
      serviceIds: params.serviceIds,
    );
  }

  ResultFuture<AppointmentPageContent> refreshAvailability(
    GetAppointmentPageContentParams params,
  ) {
    return _repository.refreshAppointmentAvailability(
      petId: params.petId,
      serviceIds: params.serviceIds,
    );
  }
}
