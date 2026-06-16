import 'package:equatable/equatable.dart';

class BlogComment extends Equatable {
  const BlogComment({
    required this.id,
    required this.userId,
    required this.userName,
    required this.body,
    required this.createdAt,
    this.userAvatar = '',
  });

  final String id;
  final String userId;
  final String userName;
  final String userAvatar;
  final String body;
  final DateTime createdAt;

  @override
  List<Object?> get props => [id, userId, userName, userAvatar, body, createdAt];
}

class BlogSocial extends Equatable {
  const BlogSocial({
    this.likeCount = 0,
    this.commentCount = 0,
    this.shareCount = 0,
    this.likedByMe = false,
    this.comments = const [],
  });

  final int likeCount;
  final int commentCount;
  final int shareCount;
  final bool likedByMe;
  final List<BlogComment> comments;

  @override
  List<Object?> get props => [
        likeCount,
        commentCount,
        shareCount,
        likedByMe,
        comments,
      ];
}
