import 'package:app/features/profile/domain/entities/help_center_category.dart';
import 'package:equatable/equatable.dart';

class HelpCenterContent extends Equatable {
  const HelpCenterContent({
    required this.categories,
    required this.faqs,
  });

  final List<HelpCenterCategory> categories;
  final List<String> faqs;

  HelpCenterContent filter(String query) {
    final normalizedQuery = query.trim().toLowerCase();
    if (normalizedQuery.isEmpty) {
      return this;
    }

    return HelpCenterContent(
      categories: categories
          .where(
            (category) =>
                category.title.toLowerCase().contains(normalizedQuery) ||
                category.subtitle.toLowerCase().contains(normalizedQuery),
          )
          .toList(),
      faqs: faqs
          .where((faq) => faq.toLowerCase().contains(normalizedQuery))
          .toList(),
    );
  }

  @override
  List<Object?> get props => [
        categories,
        faqs,
      ];
}
