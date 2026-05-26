import 'package:app/core/storage/storage_service.dart';
import 'package:app/features/onboarding/presentation/bloc/onboarding_event.dart';
import 'package:app/features/onboarding/presentation/bloc/onboarding_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

const kOnboardingPageCount = 3;

class OnboardingBloc extends Bloc<OnboardingEvent, OnboardingState> {
  OnboardingBloc(this._preferences) : super(const OnboardingState()) {
    on<OnboardingPageChanged>(_onPageChanged);
    on<OnboardingFinishedRequested>(_onFinishedRequested);
  }

  final AppPreferences _preferences;

  void _onPageChanged(
    OnboardingPageChanged event,
    Emitter<OnboardingState> emit,
  ) {
    emit(
      state.copyWith(
        currentPage: event.pageIndex,
      ),
    );
  }

  Future<void> _onFinishedRequested(
    OnboardingFinishedRequested event,
    Emitter<OnboardingState> emit,
  ) async {
    await _preferences.writeBool(
      key: StorageKeys.hasCompletedOnboarding,
      value: true,
    );

    emit(
      state.copyWith(
        isCompleted: true,
      ),
    );
  }
}
