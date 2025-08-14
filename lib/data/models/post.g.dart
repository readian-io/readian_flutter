// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'post.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$PostImpl _$$PostImplFromJson(Map<String, dynamic> json) => _$PostImpl(
      id: json['id'] as String,
      title: json['title'] as String,
      content: json['content'] as String?,
      authorId: json['authorId'] as String,
      authorName: json['authorName'] as String,
      authorAvatar: json['authorAvatar'] as String?,
      imageUrl: json['imageUrl'] as String?,
      likeCount: (json['likeCount'] as num?)?.toInt() ?? 0,
      userLikeStatus:
          $enumDecodeNullable(_$LikeStatusEnumMap, json['userLikeStatus']) ??
              LikeStatus.neutral,
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
      isSaved: json['isSaved'] as bool? ?? false,
    );

Map<String, dynamic> _$$PostImplToJson(_$PostImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'content': instance.content,
      'authorId': instance.authorId,
      'authorName': instance.authorName,
      'authorAvatar': instance.authorAvatar,
      'imageUrl': instance.imageUrl,
      'likeCount': instance.likeCount,
      'userLikeStatus': _$LikeStatusEnumMap[instance.userLikeStatus]!,
      'createdAt': instance.createdAt.toIso8601String(),
      'updatedAt': instance.updatedAt.toIso8601String(),
      'isSaved': instance.isSaved,
    };

const _$LikeStatusEnumMap = {
  LikeStatus.neutral: 'neutral',
  LikeStatus.like: 'like',
  LikeStatus.dislike: 'dislike',
};
