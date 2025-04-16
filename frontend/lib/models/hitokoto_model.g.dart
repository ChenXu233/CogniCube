// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'hitokoto_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_OneSentence _$OneSentenceFromJson(Map<String, dynamic> json) => _OneSentence(
  category: json['category'] as String,
  author: json['author'] as String,
  origin: json['origin'] as String,
  content: json['content'] as String,
);

Map<String, dynamic> _$OneSentenceToJson(_OneSentence instance) =>
    <String, dynamic>{
      'category': instance.category,
      'author': instance.author,
      'origin': instance.origin,
      'content': instance.content,
    };
