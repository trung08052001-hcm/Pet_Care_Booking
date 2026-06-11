import 'package:app/features/profile/domain/entities/help_center_content.dart';
import 'package:equatable/equatable.dart';

enum HelpCenterStatus {
  initial,
  loading,
  ready,
  failure,
}

enum HelpCenterInteraction {
  none,
  category,
  faq,
  contact,
  request,
}

class HelpCenterState extends Equatable {
  const HelpCenterState({
    this.status = HelpCenterStatus.initial,
    this.content,
    this.message,
    this.interaction = HelpCenterInteraction.none,
  });

  final HelpCenterStatus status;
  final HelpCenterContent? content;
  final String? message;
  final HelpCenterInteraction interaction;

  bool get isLoading =>
      status == HelpCenterStatus.initial || status == HelpCenterStatus.loading;

  HelpCenterState copyWith({
    HelpCenterStatus? status,
    HelpCenterContent? content,
    String? message,
    HelpCenterInteraction? interaction,
    bool clearMessage = false,
  }) {
    return HelpCenterState(
      status: status ?? this.status,
      content: content ?? this.content,
      message: clearMessage ? null : (message ?? this.message),
      interaction: interaction ?? this.interaction,
    );
  }

  @override
  List<Object?> get props => [
        status,
        content,
        message,
        interaction,
      ];
}
