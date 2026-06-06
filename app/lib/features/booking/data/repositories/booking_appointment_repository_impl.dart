import 'package:app/core/common/typedefs.dart';
import 'package:app/core/error/app_error.dart';
import 'package:app/core/network/api_service.dart';
import 'package:app/features/booking/data/datasources/booking_appointment_mock_data_source.dart';
import 'package:app/features/booking/domain/entities/appointment_time_slot.dart';
import 'package:app/features/booking/domain/entities/appointment_page_content.dart';
import 'package:app/features/booking/domain/repositories/booking_appointment_repository.dart';
import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';

@LazySingleton(as: BookingAppointmentRepository)
class BookingAppointmentRepositoryImpl implements BookingAppointmentRepository {
  BookingAppointmentRepositoryImpl(this._mockDataSource, [this._apiService]);

  final BookingAppointmentMockDataSource _mockDataSource;
  final AppApiService? _apiService;

  @override
  ResultFuture<AppointmentPageContent> getAppointmentPageContent({
    required String petId,
    required List<String> serviceIds,
  }) async {
    try {
      await Future<void>.delayed(const Duration(milliseconds: 200));
      final content = _mockDataSource.getPageContent(
        petId: petId,
        serviceIds: serviceIds,
      );
      final apiService = _apiService;
      if (apiService == null) {
        return Right(content);
      }

      final from = content.days.first.date;
      final to = content.days.last.date;
      final response = await apiService.getBookingAvailability({
        'from': _dateKey(from),
        'to': _dateKey(to),
      });
      final bookedSlotKeys = response.slots
          .map((slot) => '${slot.dateKey}:${slot.timeSlotId}')
          .toSet();
      final updatedSlots = content.slotsByDateKey.map((dateKey, slots) {
        return MapEntry(
          dateKey,
          slots
              .map(
                (slot) => bookedSlotKeys.contains('$dateKey:${slot.id}')
                    ? AppointmentTimeSlot(
                        id: slot.id,
                        label: slot.label,
                        period: slot.period,
                        availability: AppointmentSlotAvailability.full,
                      )
                    : slot,
              )
              .toList(),
        );
      });

      return Right(
        AppointmentPageContent(
          title: content.title,
          monthLabel: content.monthLabel,
          dateSectionTitle: content.dateSectionTitle,
          timeSectionTitle: content.timeSectionTitle,
          morningSectionTitle: content.morningSectionTitle,
          afternoonSectionTitle: content.afternoonSectionTitle,
          commitmentTitle: content.commitmentTitle,
          commitmentBody: content.commitmentBody,
          totalLabel: content.totalLabel,
          confirmButtonLabel: content.confirmButtonLabel,
          petSummary: content.petSummary,
          days: content.days,
          slotsByDateKey: updatedSlots,
        ),
      );
    } on Exception catch (exception, stackTrace) {
      return Left(
        FailureMapper.fromException(
          exception,
          stackTrace: stackTrace,
        ),
      );
    }
  }

  static String _dateKey(DateTime date) =>
      '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
}
