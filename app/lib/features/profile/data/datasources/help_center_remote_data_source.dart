import 'package:app/core/network/api_config.dart';
import 'package:app/features/profile/domain/entities/help_center_category.dart';
import 'package:app/features/profile/domain/entities/help_center_content.dart';
import 'package:dio/dio.dart';

class HelpCenterRemoteDataSource {
  const HelpCenterRemoteDataSource(this._dio);

  final Dio _dio;

  Future<HelpCenterContent> getContent() async {
    final response = await _dio.get<Map<String, dynamic>>(
      ApiEndpoints.helpCenter,
    );
    final data = Map<String, dynamic>.from(response.data?['data'] as Map);
    final topics = data['topics'] as List? ?? const [];
    final faqs = data['faqs'] as List? ?? const [];

    return HelpCenterContent(
      contactPhone: data['contactPhone'] as String? ?? '0903972116',
      categories: topics
          .whereType<Map<dynamic, dynamic>>()
          .map((topic) {
            final json = Map<String, dynamic>.from(topic);
            return HelpCenterCategory(
              name: json['name'] as String? ?? '',
              detail: json['detail'] as String? ?? '',
              icon: json['icon'] as String? ?? 'help',
              imageUrl: json['imageUrl'] as String? ?? '',
              supportInfo: _parseSupportInfo(json['supportInfo']),
              programDescription:
                  json['programDescription'] as String? ?? '',
              actionLabel: json['actionLabel'] as String? ?? 'Đăng ký hỗ trợ',
            );
          })
          .where((topic) => topic.name.isNotEmpty)
          .toList(),
      faqs: faqs
          .whereType<Map<dynamic, dynamic>>()
          .map((faq) {
            final json = Map<String, dynamic>.from(faq);
            return HelpCenterFaq(
              id: json['id'] as String? ?? '',
              title: json['title'] as String? ?? '',
              imageUrl: json['imageUrl'] as String? ?? '',
              description: json['description'] as String? ?? '',
              detail: json['detail'] as String? ?? '',
            );
          })
          .where((faq) => faq.id.isNotEmpty && faq.title.isNotEmpty)
          .toList(),
    );
  }

  Future<void> submitFeedback(String message) async {
    await _dio.post<Map<String, dynamic>>(
      ApiEndpoints.helpCenterFeedback,
      data: {'message': message},
    );
  }

  List<HelpCenterSupportInfo> _parseSupportInfo(Object? value) {
    final items = value is List ? value : const <Object?>[];
    return items.whereType<Map<dynamic, dynamic>>().map((item) {
      final json = Map<String, dynamic>.from(item);
      return HelpCenterSupportInfo(
        label: json['label'] as String? ?? '',
        value: json['value'] as String? ?? '',
      );
    }).where((item) => item.label.isNotEmpty || item.value.isNotEmpty).toList();
  }
}
