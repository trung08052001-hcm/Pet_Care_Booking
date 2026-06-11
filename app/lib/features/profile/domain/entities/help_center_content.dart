import 'package:app/features/profile/domain/entities/help_center_category.dart';
import 'package:equatable/equatable.dart';

class HelpCenterContent extends Equatable {
  const HelpCenterContent({
    required this.categories,
    required this.faqs,
    required this.contactPhone,
  });

  final List<HelpCenterCategory> categories;
  final List<HelpCenterFaq> faqs;
  final String contactPhone;

  @override
  List<Object?> get props => [
        categories,
        faqs,
        contactPhone,
      ];
}

class HelpCenterFaq extends Equatable {
  const HelpCenterFaq({
    required this.id,
    required this.title,
    required this.imageUrl,
    required this.description,
    required this.detail,
  });

  final String id;
  final String title;
  final String imageUrl;
  final String description;
  final String detail;

  @override
  List<Object?> get props => [
        id,
        title,
        imageUrl,
        description,
        detail,
      ];
}
