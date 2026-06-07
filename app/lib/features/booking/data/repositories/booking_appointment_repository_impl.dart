import 'dart:async';

import 'package:app/core/common/typedefs.dart';
import 'package:app/core/error/app_error.dart';
import 'package:app/core/network/api_service.dart';
import 'package:app/core/network/network_info.dart';
import 'package:app/features/booking/data/datasources/booking_local_data_source.dart';
import 'package:app/features/booking/data/datasources/booking_appointment_mock_data_source.dart';
import 'package:app/features/booking/data/models/booking_api_models.dart';
import 'package:app/features/booking/domain/entities/appointment_time_slot.dart';
import 'package:app/features/booking/domain/entities/appointment_page_content.dart';
import 'package:app/features/booking/domain/repositories/booking_appointment_repository.dart';
import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';

@LazySingleton(as: BookingAppointmentRepository)
class BookingAppointmentRepositoryImpl implements BookingAppointmentRepository {
  BookingAppointmentRepositoryImpl(
    this._mockDataSource, [
    this._apiService,
    this._networkInfo,
    this._localDataSource,
  ]);

  final BookingAppointmentMockDataSource _mockDataSource;
  final AppApiService? _apiService;
  final NetworkInfo? _networkInfo;
  final BookingLocalDataSource? _localDataSource;

  @override
  ResultFuture<AppointmentPageContent> getAppointmentPageContent({
    required String petId,
    required List<String> serviceIds,
  }) async {
    try {
      final content = _mockDataSource.getPageContent(
        petId: petId,
        serviceIds: serviceIds,
      );

      final from = content.days.first.date;
      final to = content.days.last.date;
      final fromKey = _dateKey(from);
      final toKey = _dateKey(to);
      final cachedSlots =
          _localDataSource?.getAvailability(from: fromKey, to: toKey) ??
          const <BookedSlotModel>[];

      return Right(_withBookedSlots(content, cachedSlots));
    } on Exception catch (exception, stackTrace) {
      return Left(
        FailureMapper.fromException(exception, stackTrace: stackTrace),
      );
    }
  }

  @override
  ResultFuture<AppointmentPageContent> refreshAppointmentAvailability({
    required String petId,
    required List<String> serviceIds,
  }) async {
    try {
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
      final fromKey = _dateKey(from);
      final toKey = _dateKey(to);
      final slots = await _bookedSlots(
        apiService: apiService,
        fromKey: fromKey,
        toKey: toKey,
      );

      return Right(_withBookedSlots(content, slots));
    } on Exception catch (exception, stackTrace) {
      return Left(
        FailureMapper.fromException(exception, stackTrace: stackTrace),
      );
    }
  }

  static String _dateKey(DateTime date) =>
      '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';

  AppointmentPageContent _withBookedSlots(
    AppointmentPageContent content,
    List<BookedSlotModel> slots,
  ) {
    final bookedSlotKeys = slots
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

    return AppointmentPageContent(
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
    );
  }

  Future<List<BookedSlotModel>> _bookedSlots({
    required AppApiService apiService,
    required String fromKey,
    required String toKey,
  }) async {
    final localDataSource = _localDataSource;
    final networkInfo = _networkInfo;
    if (networkInfo != null && !await networkInfo.isConnected) {
      return localDataSource?.getAvailability(from: fromKey, to: toKey) ??
          const [];
    }

    try {
      final response = await apiService
          .getBookingAvailability({'from': fromKey, 'to': toKey})
          .timeout(const Duration(seconds: 3));
      await localDataSource?.saveAvailability(
        from: fromKey,
        to: toKey,
        slots: response.slots,
      );
      return response.slots;
    } on Exception {
      return localDataSource?.getAvailability(from: fromKey, to: toKey) ??
          const [];
    }
  }
}
