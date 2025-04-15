// dart format width=80
// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'emotion_record_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$EmotionRecord {

 int get timestamp; int get user_id; String get emotion_type; double get intensity_score; double get valence_score; double get dominance_score;
/// Create a copy of EmotionRecord
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$EmotionRecordCopyWith<EmotionRecord> get copyWith => _$EmotionRecordCopyWithImpl<EmotionRecord>(this as EmotionRecord, _$identity);

  /// Serializes this EmotionRecord to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is EmotionRecord&&(identical(other.timestamp, timestamp) || other.timestamp == timestamp)&&(identical(other.user_id, user_id) || other.user_id == user_id)&&(identical(other.emotion_type, emotion_type) || other.emotion_type == emotion_type)&&(identical(other.intensity_score, intensity_score) || other.intensity_score == intensity_score)&&(identical(other.valence_score, valence_score) || other.valence_score == valence_score)&&(identical(other.dominance_score, dominance_score) || other.dominance_score == dominance_score));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,timestamp,user_id,emotion_type,intensity_score,valence_score,dominance_score);

@override
String toString() {
  return 'EmotionRecord(timestamp: $timestamp, user_id: $user_id, emotion_type: $emotion_type, intensity_score: $intensity_score, valence_score: $valence_score, dominance_score: $dominance_score)';
}


}

/// @nodoc
abstract mixin class $EmotionRecordCopyWith<$Res>  {
  factory $EmotionRecordCopyWith(EmotionRecord value, $Res Function(EmotionRecord) _then) = _$EmotionRecordCopyWithImpl;
@useResult
$Res call({
 int timestamp, int user_id, String emotion_type, double intensity_score, double valence_score, double dominance_score
});




}
/// @nodoc
class _$EmotionRecordCopyWithImpl<$Res>
    implements $EmotionRecordCopyWith<$Res> {
  _$EmotionRecordCopyWithImpl(this._self, this._then);

  final EmotionRecord _self;
  final $Res Function(EmotionRecord) _then;

/// Create a copy of EmotionRecord
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? timestamp = null,Object? user_id = null,Object? emotion_type = null,Object? intensity_score = null,Object? valence_score = null,Object? dominance_score = null,}) {
  return _then(_self.copyWith(
timestamp: null == timestamp ? _self.timestamp : timestamp // ignore: cast_nullable_to_non_nullable
as int,user_id: null == user_id ? _self.user_id : user_id // ignore: cast_nullable_to_non_nullable
as int,emotion_type: null == emotion_type ? _self.emotion_type : emotion_type // ignore: cast_nullable_to_non_nullable
as String,intensity_score: null == intensity_score ? _self.intensity_score : intensity_score // ignore: cast_nullable_to_non_nullable
as double,valence_score: null == valence_score ? _self.valence_score : valence_score // ignore: cast_nullable_to_non_nullable
as double,dominance_score: null == dominance_score ? _self.dominance_score : dominance_score // ignore: cast_nullable_to_non_nullable
as double,
  ));
}

}


/// @nodoc
@JsonSerializable()

class _EmotionRecord implements EmotionRecord {
  const _EmotionRecord({required this.timestamp, required this.user_id, required this.emotion_type, required this.intensity_score, required this.valence_score, required this.dominance_score});
  factory _EmotionRecord.fromJson(Map<String, dynamic> json) => _$EmotionRecordFromJson(json);

@override final  int timestamp;
@override final  int user_id;
@override final  String emotion_type;
@override final  double intensity_score;
@override final  double valence_score;
@override final  double dominance_score;

/// Create a copy of EmotionRecord
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$EmotionRecordCopyWith<_EmotionRecord> get copyWith => __$EmotionRecordCopyWithImpl<_EmotionRecord>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$EmotionRecordToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _EmotionRecord&&(identical(other.timestamp, timestamp) || other.timestamp == timestamp)&&(identical(other.user_id, user_id) || other.user_id == user_id)&&(identical(other.emotion_type, emotion_type) || other.emotion_type == emotion_type)&&(identical(other.intensity_score, intensity_score) || other.intensity_score == intensity_score)&&(identical(other.valence_score, valence_score) || other.valence_score == valence_score)&&(identical(other.dominance_score, dominance_score) || other.dominance_score == dominance_score));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,timestamp,user_id,emotion_type,intensity_score,valence_score,dominance_score);

@override
String toString() {
  return 'EmotionRecord(timestamp: $timestamp, user_id: $user_id, emotion_type: $emotion_type, intensity_score: $intensity_score, valence_score: $valence_score, dominance_score: $dominance_score)';
}


}

/// @nodoc
abstract mixin class _$EmotionRecordCopyWith<$Res> implements $EmotionRecordCopyWith<$Res> {
  factory _$EmotionRecordCopyWith(_EmotionRecord value, $Res Function(_EmotionRecord) _then) = __$EmotionRecordCopyWithImpl;
@override @useResult
$Res call({
 int timestamp, int user_id, String emotion_type, double intensity_score, double valence_score, double dominance_score
});




}
/// @nodoc
class __$EmotionRecordCopyWithImpl<$Res>
    implements _$EmotionRecordCopyWith<$Res> {
  __$EmotionRecordCopyWithImpl(this._self, this._then);

  final _EmotionRecord _self;
  final $Res Function(_EmotionRecord) _then;

/// Create a copy of EmotionRecord
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? timestamp = null,Object? user_id = null,Object? emotion_type = null,Object? intensity_score = null,Object? valence_score = null,Object? dominance_score = null,}) {
  return _then(_EmotionRecord(
timestamp: null == timestamp ? _self.timestamp : timestamp // ignore: cast_nullable_to_non_nullable
as int,user_id: null == user_id ? _self.user_id : user_id // ignore: cast_nullable_to_non_nullable
as int,emotion_type: null == emotion_type ? _self.emotion_type : emotion_type // ignore: cast_nullable_to_non_nullable
as String,intensity_score: null == intensity_score ? _self.intensity_score : intensity_score // ignore: cast_nullable_to_non_nullable
as double,valence_score: null == valence_score ? _self.valence_score : valence_score // ignore: cast_nullable_to_non_nullable
as double,dominance_score: null == dominance_score ? _self.dominance_score : dominance_score // ignore: cast_nullable_to_non_nullable
as double,
  ));
}


}

// dart format on
