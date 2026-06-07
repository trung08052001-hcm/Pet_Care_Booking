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
    final start = DateTime.now().year == 2026
        ? DateTime.now()
        : DateTime(2026, 6, 6);
    final firstDay = DateTime(start.year, start.month, start.day);
    final days = List.generate(7, (index) {
      final date = firstDay.add(Duration(days: index));
      return AppointmentDayOption(
        date: date,
        weekdayLabel: _weekdayLabel(date.weekday),
        dayNumberLabel: '${date.day}',
      );
    });

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
        availability: AppointmentSlotAvailability.available,
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
        availability: AppointmentSlotAvailability.available,
      ),
    ];

    return AppointmentPageContent(
      title: 'Lịch hẹn',
      monthLabel: 'Tháng ${firstDay.month}, 2026',
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
        for (final day in days) _dateKey(day.date): slotsOct17,
      },
    );
  }

  static String _dateKey(DateTime date) =>
      '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';

  static String _weekdayLabel(int weekday) {
    return switch (weekday) {
      DateTime.monday => 'Thứ 2',
      DateTime.tuesday => 'Thứ 3',
      DateTime.wednesday => 'Thứ 4',
      DateTime.thursday => 'Thứ 5',
      DateTime.friday => 'Thứ 6',
      DateTime.saturday => 'Thứ 7',
      DateTime.sunday => 'CN',
      _ => 'Thứ',
    };
  }

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
