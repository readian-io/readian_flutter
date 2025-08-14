import 'package:freezed_annotation/freezed_annotation.dart';

part 'post.freezed.dart';
part 'post.g.dart';

enum LikeStatus {
  neutral,
  like,
  dislike,
}

@freezed
class Post with _$Post {
  const factory Post({
    required String id,
    required String title,
    String? content,
    required String authorId,
    required String authorName,
    String? authorAvatar,
    String? imageUrl,
    @Default(0) int likeCount,
    @Default(LikeStatus.neutral) LikeStatus userLikeStatus,
    required DateTime createdAt,
    required DateTime updatedAt,
    @Default(false) bool isSaved,
  }) = _Post;

  factory Post.fromJson(Map<String, dynamic> json) => _$PostFromJson(json);
}