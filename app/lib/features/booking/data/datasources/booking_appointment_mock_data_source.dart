import 'package:app/features/booking/domain/entities/appointment_day_option.dart';
import 'package:app/features/booking/domain/entities/appointment_page_content.dart';
import 'package:app/features/booking/domain/entities/appointment_pet_summary.dart';
import 'package:app/features/booking/domain/entities/appointment_time_period.dart';
import 'package:app/features/booking/domain/entities/appointment_time_slot.dart';
import 'package:injectable/injectable.dart';

@lazySingleton
class BookingAppointmentMockDataSource {
  AppointmentPageContent getPageContent({
    required String petId,
    required List<String> serviceIds,
  }) {
    final days = [
      AppointmentDayOption(
        date: DateTime(2023, 10, 16),
        weekdayLabel: 'Thứ 2',
        dayNumberLabel: '16',
      ),
      AppointmentDayOption(
        date: DateTime(2023, 10, 17),
        weekdayLabel: 'Thứ 3',
        dayNumberLabel: '17',
      ),
      AppointmentDayOption(
        date: DateTime(2023, 10, 18),
        weekdayLabel: 'Thứ 4',
        dayNumberLabel: '18',
      ),
      AppointmentDayOption(
        date: DateTime(2023, 10, 19),
        weekdayLabel: 'Thứ 5',
        dayNumberLabel: '19',
      ),
      AppointmentDayOption(
        date: DateTime(2023, 10, 20),
        weekdayLabel: 'Thứ 6',
        dayNumberLabel: '20',
      ),
    ];

    final slotsOct17 = [
      const AppointmentTimeSlot(
        id: 'slot-0930',
        label: '09:30',
        period: AppointmentTimePeriod.morning,
        availability: AppointmentSlotAvailability.available,
      ),
      const AppointmentTimeSlot(
        id: 'slot-1000',
        label: '10:00',
        period: AppointmentTimePeriod.morning,
        availability: AppointmentSlotAvailability.available,
      ),
      const AppointmentTimeSlot(
        id: 'slot-1030',
        label: '10:30',
        period: AppointmentTimePeriod.morning,
        availability: AppointmentSlotAvailability.full,
      ),
      const AppointmentTimeSlot(
        id: 'slot-1400',
        label: '14:00',
        period: AppointmentTimePeriod.afternoon,
        availability: AppointmentSlotAvailability.available,
      ),
      const AppointmentTimeSlot(
        id: 'slot-1430',
        label: '14:30',
        period: AppointmentTimePeriod.afternoon,
        availability: AppointmentSlotAvailability.available,
      ),
      const AppointmentTimeSlot(
        id: 'slot-1500',
        label: '15:00',
        period: AppointmentTimePeriod.afternoon,
        availability: AppointmentSlotAvailability.available,
      ),
      const AppointmentTimeSlot(
        id: 'slot-1530',
        label: '15:30',
        period: AppointmentTimePeriod.afternoon,
        availability: AppointmentSlotAvailability.full,
      ),
    ];

    return AppointmentPageContent(
      title: 'Lịch hẹn',
      monthLabel: 'Tháng 10, 2023',
      dateSectionTitle: 'Chọn ngày',
      timeSectionTitle: 'Chọn khung giờ',
      morningSectionTitle: 'Buổi sáng',
      afternoonSectionTitle: 'Buổi chiều',
      commitmentTitle: 'Cam kết chăm sóc 5 sao',
      commitmentBody:
          'Đội ngũ PawSitive Care sẽ chăm sóc thú cưng của bạn như người thân trong gia đình.',
      totalLabel: 'Tổng thanh toán dự kiến',
      confirmButtonLabel: 'Xác nhận đặt lịch',
      petSummary: AppointmentPetSummary(
        petId: petId,
        name: _petName(petId),
        imagePlaceholderColor: 0xFFE8D5C4,
        serviceTags: _serviceTags(serviceIds),
      ),
      days: days,
      slotsByDateKey: {
        _dateKey(DateTime(2023, 10, 16)): slotsOct17,
        _dateKey(DateTime(2023, 10, 17)): slotsOct17,
        _dateKey(DateTime(2023, 10, 18)): slotsOct17,
        _dateKey(DateTime(2023, 10, 19)): slotsOct17,
        _dateKey(DateTime(2023, 10, 20)): slotsOct17,
      },
    );
  }

  static String _dateKey(DateTime date) =>
      '${date.year}-${date.month}-${date.day}';

  static String _petName(String petId) {
    return switch (petId) {
      'pet-mochi' => 'Mochi',
      'pet-luna' => 'Luna',
      _ => 'Thú cưng',
    };
  }

  static List<String> _serviceTags(List<String> serviceIds) {
    final tags = <String>[];
    for (final id in serviceIds) {
      final tag = switch (id) {
        'booking-spa' => 'TẮM & SPA',
        'booking-grooming' => 'CẮT TỈA',
        'booking-boarding' => 'LƯU TRÚ',
        'booking-health' => 'KHÁM SK',
        'booking-walking' => 'DẮT ĐI DẠO',
        _ => null,
      };
      if (tag != null && !tags.contains(tag)) {
        tags.add(tag);
      }
    }
    if (serviceIds.contains('booking-spa') &&
        !tags.contains('CẮT TỈA') &&
        serviceIds.length == 1) {
      tags.add('CẮT TỈA');
    }
    return tags;
  }
}
