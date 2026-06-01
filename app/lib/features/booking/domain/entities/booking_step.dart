enum BookingStep {
  pet(1, 'Thú cưng'),
  service(2, 'Dịch vụ'),
  appointment(3, 'Lịch hẹn'),
  confirmation(4, 'Xác nhận');

  const BookingStep(this.stepIndex, this.label);

  final int stepIndex;
  final String label;

  static const List<BookingStep> flow = [
    BookingStep.pet,
    BookingStep.service,
    BookingStep.appointment,
    BookingStep.confirmation,
  ];
}
