import 'package:equatable/equatable.dart';

sealed class ProfileAddressEvent extends Equatable {
  const ProfileAddressEvent();

  @override
  List<Object?> get props => const [];
}

final class ProfileAddressStarted extends ProfileAddressEvent {
  const ProfileAddressStarted();
}

final class ProfileAddressDetailChanged extends ProfileAddressEvent {
  const ProfileAddressDetailChanged(this.detail);

  final String detail;

  @override
  List<Object?> get props => [detail];
}

final class ProfileAddressLabelChanged extends ProfileAddressEvent {
  const ProfileAddressLabelChanged(this.label);

  final String label;

  @override
  List<Object?> get props => [label];
}

final class ProfileAddressLocatePressed extends ProfileAddressEvent {
  const ProfileAddressLocatePressed();
}

final class ProfileAddressSavePressed extends ProfileAddressEvent {
  const ProfileAddressSavePressed();
}

final class ProfileAddressMessageConsumed extends ProfileAddressEvent {
  const ProfileAddressMessageConsumed();
}
