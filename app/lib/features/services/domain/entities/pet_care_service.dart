import 'package:app/features/services/domain/entities/service_category_filter.dart';
import 'package:equatable/equatable.dart';

class PetCareService extends Equatable {
  const PetCareService({
    required this.id,
    required this.title,
    required this.description,
    required this.detail,
    required this.priceText,
    required this.image,
    required this.category,
    required this.badge,
    this.isActive = true,
    this.slug = '',
    this.isFeatured = false,
    this.icon = '',
    this.ratingText = '',
    this.reviewText = '',
    this.usageText = '',
    this.durationText = '',
    this.promoTitle = '',
    this.promoDescription = '',
    this.promoDiscountText = '',
    this.promoTone = 'orange',
    this.includedItems = const [],
    this.benefits = const [],
    this.noticeText = '',
  });

  factory PetCareService.fromJson(Map<String, dynamic> json) {
    final promo = json['promo'];
    final promoMap =
        promo is Map ? Map<String, dynamic>.from(promo) : const <String, dynamic>{};
    return PetCareService(
      id: (json['id'] ?? json['_id'] ?? '').toString(),
      slug: (json['slug'] ?? '').toString(),
      title: (json['title'] ?? '').toString(),
      description: (json['description'] ?? '').toString(),
      detail: (json['detail'] ?? '').toString(),
      priceText: (json['priceText'] ?? '').toString(),
      image: (json['image'] ?? '').toString(),
      category: switch (json['category']?.toString()) {
        'dog' => ServiceCategoryFilter.dog,
        'cat' => ServiceCategoryFilter.cat,
        _ => ServiceCategoryFilter.all,
      },
      badge: (json['badge'] ?? '').toString(),
      isActive: json['isActive'] != false,
      isFeatured: json['isFeatured'] == true,
      icon: (json['icon'] ?? '').toString(),
      ratingText: (json['ratingText'] ?? '').toString(),
      reviewText: (json['reviewText'] ?? '').toString(),
      usageText: (json['usageText'] ?? '').toString(),
      durationText: (json['durationText'] ?? '').toString(),
      promoTitle: (promoMap['title'] ?? '').toString(),
      promoDescription: (promoMap['description'] ?? '').toString(),
      promoDiscountText: (promoMap['discountText'] ?? '').toString(),
      promoTone: (promoMap['tone'] ?? 'orange').toString(),
      includedItems: _stringListFromJson(json['includedItems']),
      benefits: _stringListFromJson(json['benefits']),
      noticeText: (json['noticeText'] ?? '').toString(),
    );
  }

  final String id;
  final String slug;
  final String title;
  final String description;
  final String detail;
  final String priceText;
  final String image;
  final ServiceCategoryFilter category;
  final String badge;
  final bool isActive;
  final bool isFeatured;
  final String icon;
  final String ratingText;
  final String reviewText;
  final String usageText;
  final String durationText;
  final String promoTitle;
  final String promoDescription;
  final String promoDiscountText;
  final String promoTone;
  final List<String> includedItems;
  final List<String> benefits;
  final String noticeText;

  bool get isDog => category == ServiceCategoryFilter.dog;

  bool get isCat => category == ServiceCategoryFilter.cat;

  String get routeId => slug.isNotEmpty ? slug : id;

  Map<String, dynamic> toJson() => {
        'id': id,
        'slug': slug,
        'title': title,
        'description': description,
        'detail': detail,
        'priceText': priceText,
        'image': image,
        'category': category.name,
        'badge': badge,
        'isActive': isActive,
        'isFeatured': isFeatured,
        'icon': icon,
        'ratingText': ratingText,
        'reviewText': reviewText,
        'usageText': usageText,
        'durationText': durationText,
        'promo': {
          'title': promoTitle,
          'description': promoDescription,
          'discountText': promoDiscountText,
          'tone': promoTone,
        },
        'includedItems': includedItems,
        'benefits': benefits,
        'noticeText': noticeText,
      };

  @override
  List<Object?> get props => [
        id,
        slug,
        title,
        description,
        detail,
        priceText,
        image,
        category,
        badge,
        isActive,
        isFeatured,
        icon,
        ratingText,
        reviewText,
        usageText,
        durationText,
        promoTitle,
        promoDescription,
        promoDiscountText,
        promoTone,
        includedItems,
        benefits,
        noticeText,
      ];
}

List<String> _stringListFromJson(Object? value) {
  if (value is! List) {
    return const [];
  }

  return value.map((item) => item.toString()).toList(growable: false);
}
