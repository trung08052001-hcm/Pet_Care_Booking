import 'package:equatable/equatable.dart';
class HelpCenterCategory extends Equatable {
  const HelpCenterCategory({
    required this.name,
    required this.detail,
    required this.icon,
    required this.imageUrl,
    required this.supportInfo,
    required this.programDescription,
    required this.actionLabel,
  });

  final String name;
  final String detail;
  final String icon;
  final String imageUrl;
  final List<HelpCenterSupportInfo> supportInfo;
  final String programDescription;
  final String actionLabel;

  @override
  List<Object?> get props => [
        name,
        detail,
        icon,
        imageUrl,
        supportInfo,
        programDescription,
        actionLabel,
      ];
}

class HelpCenterSupportInfo extends Equatable {
  const HelpCenterSupportInfo({
    required this.label,
    required this.value,
  });

  final String label;
  final String value;

  @override
  List<Object?> get props => [label, value];
}
