import 'package:app/features/booking/data/datasources/booking_detail_local_data_source.dart';
import 'package:app/features/booking/data/datasources/booking_service_mock_data_source.dart';
import 'package:app/features/booking/data/mappers/booking_detail_mapper.dart';
import 'package:app/features/booking/domain/entities/booking_confirmation_content.dart';
import 'package:app/features/booking/domain/entities/booking_confirmation_request.dart';
import 'package:app/features/booking/domain/entities/booking_line_item.dart';
import 'package:app/features/booking/domain/entities/booking_payment_method.dart';
import 'package:injectable/injectable.dart';

@lazySingleton
class BookingConfirmationMockDataSource {
  BookingConfirmationMockDataSource(
    this._servicesDataSource,
    this._bookingDetailStore,
  );

  final BookingServiceMockDataSource _servicesDataSource;
  final BookingDetailLocalDataSource _bookingDetailStore;

  BookingConfirmationContent buildContent(BookingConfirmationRequest request) {
    final catalog = _servicesDataSource.getPageContent().services;
    final lineItems = <BookingLineItem>[];

    for (final serviceId in request.serviceIds) {
      for (final service in catalog) {
        if (service.id == serviceId) {
          lineItems.add(
            BookingLineItem(label: service.title, amountVnd: service.priceVnd),
          );
          break;
        }
      }
    }

    if (request.serviceIds.length == 1 &&
        request.serviceIds.contains('booking-spa')) {
      lineItems.add(const BookingLineItem(label: 'Cắt tỉa', amountVnd: 200000));
    }

    final computedTotal =
        lineItems.fold<int>(0, (sum, item) => sum + item.amountVnd);
    final totalVnd =
        request.totalVnd > 0 ? request.totalVnd : computedTotal;

    final weekday = _weekdayLabel(request.appointmentDate.weekday);
    final month = request.appointmentDate.month;
    final day = request.appointmentDate.day;
    final timeValue =
        '$weekday, $day Tháng $month, 2023, ${request.timeSlotLabel}';

    return BookingConfirmationContent(
      title: 'Xác nhận',
      petName: _petName(request.petId),
      petSubtitle: _petSubtitle(request.petId),
      serviceLabel: 'Dịch vụ',
      serviceValue: lineItems.map((item) => item.label).join(', '),
      timeLabel: 'Thời gian',
      timeValue: timeValue,
      locationLabel: 'Địa điểm',
      locationValue: 'Tại cửa hàng (PawSitive Sanctuary)',
      paymentSectionTitle: 'Chi tiết thanh toán',
      lineItems: lineItems,
      discountLabel: 'Giảm giá',
      discountVnd: 0,
      totalLabel: 'Tổng cộng',
      totalVnd: totalVnd,
      paymentMethod: const BookingPaymentMethod(
        name: 'Ví PawSitive',
        balanceLabel: 'Số dư: 500.000đ',
        changeLabel: 'Thay đổi',
      ),
      cancellationNote:
          'Bạn có thể hủy lịch miễn phí trước 2 tiếng',
      completeButtonLabel: 'Hoàn tất đặt lịch',
      petImagePlaceholderColor: 0xFFE8D5C4,
    );
  }

  Future<String> submitBooking(BookingConfirmationRequest request) async {
    await Future<void>.delayed(const Duration(milliseconds: 800));
    final content = buildContent(request);
    final bookingId = 'PS${DateTime.now().millisecondsSinceEpoch % 100000}';
    final detail = BookingDetailMapper.fromConfirmation(
      bookingId: bookingId,
      request: request,
      content: content,
      servicesDataSource: _servicesDataSource,
    );
    _bookingDetailStore.save(detail);
    return bookingId;
  }

  String _petName(String petId) {
    return switch (petId) {
      'pet-mochi' => 'Mochi',
      'pet-luna' => 'Luna',
      _ => 'Thú cưng',
    };
  }

  String _petSubtitle(String petId) {
    return switch (petId) {
      'pet-mochi' => 'Corgi • 2 tuổi',
      'pet-luna' => 'Golden Retriever • 2 tuổi',
      _ => 'Thú cưng yêu quý',
    };
  }

  String _weekdayLabel(int weekday) {
    return switch (weekday) {
      DateTime.monday => 'Thứ 2',
      DateTime.tuesday => 'Thứ 3',
      DateTime.wednesday => 'Thứ 4',
      DateTime.thursday => 'Thứ 5',
      DateTime.friday => 'Thứ 6',
      DateTime.saturday => 'Thứ 7',
      DateTime.sunday => 'Chủ nhật',
      _ => 'Thứ',
    };
  }
}
