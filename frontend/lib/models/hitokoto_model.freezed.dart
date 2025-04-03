// dart format width=80
// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'hitokoto_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$OneSentence {

 int get id; String get tag; String get name; String get origin; String get content;
/// Create a copy of OneSentence
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$OneSentenceCopyWith<OneSentence> get copyWith => _$OneSentenceCopyWithImpl<OneSentence>(this as OneSentence, _$identity);

  /// Serializes this OneSentence to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is OneSentence&&(identical(other.id, id) || other.id == id)&&(identical(other.tag, tag) || other.tag == tag)&&(identical(other.name, name) || other.name == name)&&(identical(other.origin, origin) || other.origin == origin)&&(identical(other.content, content) || other.content == content));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,tag,name,origin,content);

@override
String toString() {
  return 'OneSentence(id: $id, tag: $tag, name: $name, origin: $origin, content: $content)';
}


}

/// @nodoc
abstract mixin class $OneSentenceCopyWith<$Res>  {
  factory $OneSentenceCopyWith(OneSentence value, $Res Function(OneSentence) _then) = _$OneSentenceCopyWithImpl;
@useResult
$Res call({
 int id, String tag, String name, String origin, String content
});




}
/// @nodoc
class _$OneSentenceCopyWithImpl<$Res>
    implements $OneSentenceCopyWith<$Res> {
  _$OneSentenceCopyWithImpl(this._self, this._then);

  final OneSentence _self;
  final $Res Function(OneSentence) _then;

/// Create a copy of OneSentence
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? tag = null,Object? name = null,Object? origin = null,Object? content = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,tag: null == tag ? _self.tag : tag // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,origin: null == origin ? _self.origin : origin // ignore: cast_nullable_to_non_nullable
as String,content: null == content ? _self.content : content // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// @nodoc
@JsonSerializable()

class _OneSentence implements OneSentence {
  const _OneSentence({required this.id, required this.tag, required this.name, required this.origin, required this.content});
  factory _OneSentence.fromJson(Map<String, dynamic> json) => _$OneSentenceFromJson(json);

@override final  int id;
@override final  String tag;
@override final  String name;
@override final  String origin;
@override final  String content;

/// Create a copy of OneSentence
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$OneSentenceCopyWith<_OneSentence> get copyWith => __$OneSentenceCopyWithImpl<_OneSentence>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$OneSentenceToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _OneSentence&&(identical(other.id, id) || other.id == id)&&(identical(other.tag, tag) || other.tag == tag)&&(identical(other.name, name) || other.name == name)&&(identical(other.origin, origin) || other.origin == origin)&&(identical(other.content, content) || other.content == content));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,tag,name,origin,content);

@override
String toString() {
  return 'OneSentence(id: $id, tag: $tag, name: $name, origin: $origin, content: $content)';
}


}

/// @nodoc
abstract mixin class _$OneSentenceCopyWith<$Res> implements $OneSentenceCopyWith<$Res> {
  factory _$OneSentenceCopyWith(_OneSentence value, $Res Function(_OneSentence) _then) = __$OneSentenceCopyWithImpl;
@override @useResult
$Res call({
 int id, String tag, String name, String origin, String content
});




}
/// @nodoc
class __$OneSentenceCopyWithImpl<$Res>
    implements _$OneSentenceCopyWith<$Res> {
  __$OneSentenceCopyWithImpl(this._self, this._then);

  final _OneSentence _self;
  final $Res Function(_OneSentence) _then;

/// Create a copy of OneSentence
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? tag = null,Object? name = null,Object? origin = null,Object? content = null,}) {
  return _then(_OneSentence(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,tag: null == tag ? _self.tag : tag // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,origin: null == origin ? _self.origin : origin // ignore: cast_nullable_to_non_nullable
as String,content: null == content ? _self.content : content // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

// dart format on
