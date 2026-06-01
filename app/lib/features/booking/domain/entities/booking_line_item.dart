import 'package:equatable/equatable.dart';

class BookingLineItem extends Equatable {
  const BookingLineItem({
    required this.label,
    required this.amountVnd,
  });

  final String label;
  final int amountVnd;

  @override
  List<Object?> get props => [label, amountVnd];
}
