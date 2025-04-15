// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'emotion_record_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_EmotionRecord _$EmotionRecordFromJson(Map<String, dynamic> json) =>
    _EmotionRecord(
      timestamp: (json['timestamp'] as num).toInt(),
      user_id: (json['user_id'] as num).toInt(),
      emotion_type: json['emotion_type'] as String,
      intensity_score: (json['intensity_score'] as num).toDouble(),
      valence_score: (json['valence_score'] as num).toDouble(),
      dominance_score: (json['dominance_score'] as num).toDouble(),
    );

Map<String, dynamic> _$EmotionRecordToJson(_EmotionRecord instance) =>
    <String, dynamic>{
      'timestamp': instance.timestamp,
      'user_id': instance.user_id,
      'emotion_type': instance.emotion_type,
      'intensity_score': instance.intensity_score,
      'valence_score': instance.valence_score,
      'dominance_score': instance.dominance_score,
    };
