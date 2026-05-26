import 'package:app/features/onboarding/presentation/bloc/onboarding_bloc.dart';
import 'package:equatable/equatable.dart';
class OnboardingState extends Equatable {
  const OnboardingState({
    this.currentPage = 0,
    this.isCompleted = false,
  });

  final int currentPage;
  final bool isCompleted;

  bool get isLastPage => currentPage == kOnboardingPageCount - 1;

  OnboardingState copyWith({
    int? currentPage,
    bool? isCompleted,
  }) {
    return OnboardingState(
      currentPage: currentPage ?? this.currentPage,
      isCompleted: isCompleted ?? this.isCompleted,
    );
  }

  @override
  List<Object?> get props => [currentPage, isCompleted];
}