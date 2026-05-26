import 'package:app/features/sample_posts/domain/entities/sample_post.dart';
import 'package:json_annotation/json_annotation.dart';

part 'sample_post_model.g.dart';

@JsonSerializable()
class SamplePostModel {
  const SamplePostModel({
    required this.userId,
    required this.id,
    required this.title,
    required this.body,
  });

  factory SamplePostModel.fromJson(Map<String, dynamic> json) {
    return _$SamplePostModelFromJson(json);
  }

  final int userId;
  final int id;
  final String title;
  final String body;

  Map<String, dynamic> toJson() => _$SamplePostModelToJson(this);
}

extension SamplePostModelX on SamplePostModel {
  SamplePost toEntity() {
    return SamplePost(
      userId: userId,
      id: id,
      title: title,
      body: body,
    );
  }
}
