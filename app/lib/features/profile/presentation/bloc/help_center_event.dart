import 'package:equatable/equatable.dart';

sealed class HelpCenterEvent extends Equatable {
  const HelpCenterEvent();

  @override
  List<Object?> get props => const [];
}

final class HelpCenterStarted extends HelpCenterEvent {
  const HelpCenterStarted();
}

final class HelpCenterCategoryPressed extends HelpCenterEvent {
  const HelpCenterCategoryPressed(this.name);

  final String name;

  @override
  List<Object?> get props => [name];
}

final class HelpCenterFaqPressed extends HelpCenterEvent {
  const HelpCenterFaqPressed(this.question);

  final String question;

  @override
  List<Object?> get props => [question];
}

final class HelpCenterContactPressed extends HelpCenterEvent {
  const HelpCenterContactPressed();
}

final class HelpCenterRequestPressed extends HelpCenterEvent {
  const HelpCenterRequestPressed();
}

final class HelpCenterFeedbackSubmitted extends HelpCenterEvent {
  const HelpCenterFeedbackSubmitted(this.message);

  final String message;

  @override
  List<Object?> get props => [message];
}

final class HelpCenterFeedbackConsumed extends HelpCenterEvent {
  const HelpCenterFeedbackConsumed();
}
