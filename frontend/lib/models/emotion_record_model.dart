import 'package:freezed_annotation/freezed_annotation.dart';

part 'emotion_record_model.freezed.dart';
part 'emotion_record_model.g.dart';

@freezed
abstract class EmotionRecord with _$EmotionRecord {
  const factory EmotionRecord({
    required int timestamp,
    required int user_id,
    required String emotion_type,
    required double intensity_score,
    required double valence_score,
    required double dominance_score,
  }) = _EmotionRecord;

  factory EmotionRecord.fromJson(Map<String, dynamic> json) =>
      _$EmotionRecordFromJson(json);
}
