import 'package:equatable/equatable.dart';
sealed class OnboardingEvent extends Equatable {
  const OnboardingEvent();

  @override
  List<Object?> get props => const [];
}

final class OnboardingPageChanged extends OnboardingEvent {
  const OnboardingPageChanged(this.pageIndex);

  final int pageIndex;

  @override
  List<Object?> get props => [pageIndex];
}

final class OnboardingFinishedRequested extends OnboardingEvent {
  const OnboardingFinishedRequested();
}