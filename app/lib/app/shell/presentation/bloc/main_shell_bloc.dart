import 'package:app/app/shell/presentation/bloc/main_shell_event.dart';
import 'package:app/app/shell/presentation/bloc/main_shell_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class MainShellBloc extends Bloc<MainShellEvent, MainShellState> {
  MainShellBloc({int initialIndex = 0})
      : super(MainShellState(currentIndex: initialIndex)) {
    on<MainShellTabChanged>(_onTabChanged);
  }

  void _onTabChanged(
    MainShellTabChanged event,
    Emitter<MainShellState> emit,
  ) {
    if (event.index < 0 || event.index >= kMainShellTabCount) {
      return;
    }
    emit(state.copyWith(currentIndex: event.index));
  }
}
