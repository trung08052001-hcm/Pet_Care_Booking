import 'package:equatable/equatable.dart';

sealed class HelpCenterEvent extends Equatable {
  const HelpCenterEvent();

  @override
  List<Object?> get props => const [];
}

final class HelpCenterStarted extends HelpCenterEvent {
  const HelpCenterStarted();
}

final class HelpCenterSearchChanged extends HelpCenterEvent {
  const HelpCenterSearchChanged(this.query);

  final String query;

  @override
  List<Object?> get props => [query];
}

final class HelpCenterCategoryPressed extends HelpCenterEvent {
  const HelpCenterCategoryPressed(this.categoryId);

  final String categoryId;

  @override
  List<Object?> get props => [categoryId];
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

final class HelpCenterFeedbackConsumed extends HelpCenterEvent {
  const HelpCenterFeedbackConsumed();
}
