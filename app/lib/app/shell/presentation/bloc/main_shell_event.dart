import 'package:equatable/equatable.dart';

sealed class MainShellEvent extends Equatable {
  const MainShellEvent();

  @override
  List<Object?> get props => const [];
}

final class MainShellTabChanged extends MainShellEvent {
  const MainShellTabChanged(this.index);

  final int index;

  @override
  List<Object?> get props => [index];
}
