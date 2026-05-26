// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'sample_post_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SamplePostModel _$SamplePostModelFromJson(Map<String, dynamic> json) =>
    SamplePostModel(
      userId: (json['userId'] as num).toInt(),
      id: (json['id'] as num).toInt(),
      title: json['title'] as String,
      body: json['body'] as String,
    );

Map<String, dynamic> _$SamplePostModelToJson(SamplePostModel instance) =>
    <String, dynamic>{
      'userId': instance.userId,
      'id': instance.id,
      'title': instance.title,
      'body': instance.body,
    };
