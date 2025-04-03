// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'hitokoto_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_OneSentence _$OneSentenceFromJson(Map<String, dynamic> json) => _OneSentence(
  id: (json['id'] as num).toInt(),
  tag: json['tag'] as String,
  name: json['name'] as String,
  origin: json['origin'] as String,
  content: json['content'] as String,
);

Map<String, dynamic> _$OneSentenceToJson(_OneSentence instance) =>
    <String, dynamic>{
      'id': instance.id,
      'tag': instance.tag,
      'name': instance.name,
      'origin': instance.origin,
      'content': instance.content,
    };
