import 'package:equatable/equatable.dart';

const kMainShellTabCount = 5;

class MainShellState extends Equatable {
  const MainShellState({this.currentIndex = 0});

  final int currentIndex;

  MainShellState copyWith({int? currentIndex}) {
    return MainShellState(
      currentIndex: currentIndex ?? this.currentIndex,
    );
  }

  @override
  List<Object?> get props => [currentIndex];
}
