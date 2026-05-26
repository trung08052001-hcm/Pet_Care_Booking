import 'package:equatable/equatable.dart';

class SamplePost extends Equatable {
  const SamplePost({
    required this.userId,
    required this.id,
    required this.title,
    required this.body,
  });

  final int userId;
  final int id;
  final String title;
  final String body;

  @override
  List<Object> get props => [
        userId,
        id,
        title,
        body,
      ];
}
