import 'package:equatable/equatable.dart';

class BookingPaymentMethod extends Equatable {
  const BookingPaymentMethod({
    required this.name,
    required this.balanceLabel,
    required this.changeLabel,
  });

  final String name;
  final String balanceLabel;
  final String changeLabel;

  @override
  List<Object?> get props => [name, balanceLabel, changeLabel];
}
