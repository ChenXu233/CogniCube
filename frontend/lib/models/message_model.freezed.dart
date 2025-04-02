// dart format width=80
// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'message_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$TextModel implements DiagnosticableTreeMixin {

 MessageType get type; String get text;
/// Create a copy of TextModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$TextModelCopyWith<TextModel> get copyWith => _$TextModelCopyWithImpl<TextModel>(this as TextModel, _$identity);

  /// Serializes this TextModel to a JSON map.
  Map<String, dynamic> toJson();

@override
void debugFillProperties(DiagnosticPropertiesBuilder properties) {
  properties
    ..add(DiagnosticsProperty('type', 'TextModel'))
    ..add(DiagnosticsProperty('type', type))..add(DiagnosticsProperty('text', text));
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is TextModel&&(identical(other.type, type) || other.type == type)&&(identical(other.text, text) || other.text == text));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,type,text);

@override
String toString({ DiagnosticLevel minLevel = DiagnosticLevel.info }) {
  return 'TextModel(type: $type, text: $text)';
}


}

/// @nodoc
abstract mixin class $TextModelCopyWith<$Res>  {
  factory $TextModelCopyWith(TextModel value, $Res Function(TextModel) _then) = _$TextModelCopyWithImpl;
@useResult
$Res call({
 MessageType type, String text
});




}
/// @nodoc
class _$TextModelCopyWithImpl<$Res>
    implements $TextModelCopyWith<$Res> {
  _$TextModelCopyWithImpl(this._self, this._then);

  final TextModel _self;
  final $Res Function(TextModel) _then;

/// Create a copy of TextModel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? type = null,Object? text = null,}) {
  return _then(_self.copyWith(
type: null == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as MessageType,text: null == text ? _self.text : text // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// @nodoc
@JsonSerializable()

class _TextModel with DiagnosticableTreeMixin implements TextModel {
  const _TextModel({this.type = MessageType.text, required this.text});
  factory _TextModel.fromJson(Map<String, dynamic> json) => _$TextModelFromJson(json);

@override@JsonKey() final  MessageType type;
@override final  String text;

/// Create a copy of TextModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$TextModelCopyWith<_TextModel> get copyWith => __$TextModelCopyWithImpl<_TextModel>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$TextModelToJson(this, );
}
@override
void debugFillProperties(DiagnosticPropertiesBuilder properties) {
  properties
    ..add(DiagnosticsProperty('type', 'TextModel'))
    ..add(DiagnosticsProperty('type', type))..add(DiagnosticsProperty('text', text));
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _TextModel&&(identical(other.type, type) || other.type == type)&&(identical(other.text, text) || other.text == text));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,type,text);

@override
String toString({ DiagnosticLevel minLevel = DiagnosticLevel.info }) {
  return 'TextModel(type: $type, text: $text)';
}


}

/// @nodoc
abstract mixin class _$TextModelCopyWith<$Res> implements $TextModelCopyWith<$Res> {
  factory _$TextModelCopyWith(_TextModel value, $Res Function(_TextModel) _then) = __$TextModelCopyWithImpl;
@override @useResult
$Res call({
 MessageType type, String text
});




}
/// @nodoc
class __$TextModelCopyWithImpl<$Res>
    implements _$TextModelCopyWith<$Res> {
  __$TextModelCopyWithImpl(this._self, this._then);

  final _TextModel _self;
  final $Res Function(_TextModel) _then;

/// Create a copy of TextModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? type = null,Object? text = null,}) {
  return _then(_TextModel(
type: null == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as MessageType,text: null == text ? _self.text : text // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}


/// @nodoc
mixin _$ExpressionModel implements DiagnosticableTreeMixin {

 MessageType get type; int get expressionId; String get text;
/// Create a copy of ExpressionModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ExpressionModelCopyWith<ExpressionModel> get copyWith => _$ExpressionModelCopyWithImpl<ExpressionModel>(this as ExpressionModel, _$identity);

  /// Serializes this ExpressionModel to a JSON map.
  Map<String, dynamic> toJson();

@override
void debugFillProperties(DiagnosticPropertiesBuilder properties) {
  properties
    ..add(DiagnosticsProperty('type', 'ExpressionModel'))
    ..add(DiagnosticsProperty('type', type))..add(DiagnosticsProperty('expressionId', expressionId))..add(DiagnosticsProperty('text', text));
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ExpressionModel&&(identical(other.type, type) || other.type == type)&&(identical(other.expressionId, expressionId) || other.expressionId == expressionId)&&(identical(other.text, text) || other.text == text));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,type,expressionId,text);

@override
String toString({ DiagnosticLevel minLevel = DiagnosticLevel.info }) {
  return 'ExpressionModel(type: $type, expressionId: $expressionId, text: $text)';
}


}

/// @nodoc
abstract mixin class $ExpressionModelCopyWith<$Res>  {
  factory $ExpressionModelCopyWith(ExpressionModel value, $Res Function(ExpressionModel) _then) = _$ExpressionModelCopyWithImpl;
@useResult
$Res call({
 MessageType type, int expressionId, String text
});




}
/// @nodoc
class _$ExpressionModelCopyWithImpl<$Res>
    implements $ExpressionModelCopyWith<$Res> {
  _$ExpressionModelCopyWithImpl(this._self, this._then);

  final ExpressionModel _self;
  final $Res Function(ExpressionModel) _then;

/// Create a copy of ExpressionModel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? type = null,Object? expressionId = null,Object? text = null,}) {
  return _then(_self.copyWith(
type: null == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as MessageType,expressionId: null == expressionId ? _self.expressionId : expressionId // ignore: cast_nullable_to_non_nullable
as int,text: null == text ? _self.text : text // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// @nodoc
@JsonSerializable()

class _ExpressionModel with DiagnosticableTreeMixin implements ExpressionModel {
  const _ExpressionModel({this.type = MessageType.expression, required this.expressionId, required this.text});
  factory _ExpressionModel.fromJson(Map<String, dynamic> json) => _$ExpressionModelFromJson(json);

@override@JsonKey() final  MessageType type;
@override final  int expressionId;
@override final  String text;

/// Create a copy of ExpressionModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ExpressionModelCopyWith<_ExpressionModel> get copyWith => __$ExpressionModelCopyWithImpl<_ExpressionModel>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ExpressionModelToJson(this, );
}
@override
void debugFillProperties(DiagnosticPropertiesBuilder properties) {
  properties
    ..add(DiagnosticsProperty('type', 'ExpressionModel'))
    ..add(DiagnosticsProperty('type', type))..add(DiagnosticsProperty('expressionId', expressionId))..add(DiagnosticsProperty('text', text));
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ExpressionModel&&(identical(other.type, type) || other.type == type)&&(identical(other.expressionId, expressionId) || other.expressionId == expressionId)&&(identical(other.text, text) || other.text == text));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,type,expressionId,text);

@override
String toString({ DiagnosticLevel minLevel = DiagnosticLevel.info }) {
  return 'ExpressionModel(type: $type, expressionId: $expressionId, text: $text)';
}


}

/// @nodoc
abstract mixin class _$ExpressionModelCopyWith<$Res> implements $ExpressionModelCopyWith<$Res> {
  factory _$ExpressionModelCopyWith(_ExpressionModel value, $Res Function(_ExpressionModel) _then) = __$ExpressionModelCopyWithImpl;
@override @useResult
$Res call({
 MessageType type, int expressionId, String text
});




}
/// @nodoc
class __$ExpressionModelCopyWithImpl<$Res>
    implements _$ExpressionModelCopyWith<$Res> {
  __$ExpressionModelCopyWithImpl(this._self, this._then);

  final _ExpressionModel _self;
  final $Res Function(_ExpressionModel) _then;

/// Create a copy of ExpressionModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? type = null,Object? expressionId = null,Object? text = null,}) {
  return _then(_ExpressionModel(
type: null == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as MessageType,expressionId: null == expressionId ? _self.expressionId : expressionId // ignore: cast_nullable_to_non_nullable
as int,text: null == text ? _self.text : text // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}


/// @nodoc
mixin _$Message implements DiagnosticableTreeMixin {

 List<dynamic> get messages;// 使用联合类型
 int? get replyTo; double? get timestamp; String get who; int? get messageId; Map<String, dynamic> get extensions;
/// Create a copy of Message
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$MessageCopyWith<Message> get copyWith => _$MessageCopyWithImpl<Message>(this as Message, _$identity);

  /// Serializes this Message to a JSON map.
  Map<String, dynamic> toJson();

@override
void debugFillProperties(DiagnosticPropertiesBuilder properties) {
  properties
    ..add(DiagnosticsProperty('type', 'Message'))
    ..add(DiagnosticsProperty('messages', messages))..add(DiagnosticsProperty('replyTo', replyTo))..add(DiagnosticsProperty('timestamp', timestamp))..add(DiagnosticsProperty('who', who))..add(DiagnosticsProperty('messageId', messageId))..add(DiagnosticsProperty('extensions', extensions));
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Message&&const DeepCollectionEquality().equals(other.messages, messages)&&(identical(other.replyTo, replyTo) || other.replyTo == replyTo)&&(identical(other.timestamp, timestamp) || other.timestamp == timestamp)&&(identical(other.who, who) || other.who == who)&&(identical(other.messageId, messageId) || other.messageId == messageId)&&const DeepCollectionEquality().equals(other.extensions, extensions));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(messages),replyTo,timestamp,who,messageId,const DeepCollectionEquality().hash(extensions));

@override
String toString({ DiagnosticLevel minLevel = DiagnosticLevel.info }) {
  return 'Message(messages: $messages, replyTo: $replyTo, timestamp: $timestamp, who: $who, messageId: $messageId, extensions: $extensions)';
}


}

/// @nodoc
abstract mixin class $MessageCopyWith<$Res>  {
  factory $MessageCopyWith(Message value, $Res Function(Message) _then) = _$MessageCopyWithImpl;
@useResult
$Res call({
 List<dynamic> messages, int? replyTo, double? timestamp, String who, int? messageId, Map<String, dynamic> extensions
});




}
/// @nodoc
class _$MessageCopyWithImpl<$Res>
    implements $MessageCopyWith<$Res> {
  _$MessageCopyWithImpl(this._self, this._then);

  final Message _self;
  final $Res Function(Message) _then;

/// Create a copy of Message
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? messages = null,Object? replyTo = freezed,Object? timestamp = freezed,Object? who = null,Object? messageId = freezed,Object? extensions = null,}) {
  return _then(_self.copyWith(
messages: null == messages ? _self.messages : messages // ignore: cast_nullable_to_non_nullable
as List<dynamic>,replyTo: freezed == replyTo ? _self.replyTo : replyTo // ignore: cast_nullable_to_non_nullable
as int?,timestamp: freezed == timestamp ? _self.timestamp : timestamp // ignore: cast_nullable_to_non_nullable
as double?,who: null == who ? _self.who : who // ignore: cast_nullable_to_non_nullable
as String,messageId: freezed == messageId ? _self.messageId : messageId // ignore: cast_nullable_to_non_nullable
as int?,extensions: null == extensions ? _self.extensions : extensions // ignore: cast_nullable_to_non_nullable
as Map<String, dynamic>,
  ));
}

}


/// @nodoc
@JsonSerializable()

class _Message with DiagnosticableTreeMixin implements Message {
  const _Message({required final  List<dynamic> messages, this.replyTo, this.timestamp, required this.who, this.messageId, final  Map<String, dynamic> extensions = const {}}): _messages = messages,_extensions = extensions;
  factory _Message.fromJson(Map<String, dynamic> json) => _$MessageFromJson(json);

 final  List<dynamic> _messages;
@override List<dynamic> get messages {
  if (_messages is EqualUnmodifiableListView) return _messages;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_messages);
}

// 使用联合类型
@override final  int? replyTo;
@override final  double? timestamp;
@override final  String who;
@override final  int? messageId;
 final  Map<String, dynamic> _extensions;
@override@JsonKey() Map<String, dynamic> get extensions {
  if (_extensions is EqualUnmodifiableMapView) return _extensions;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableMapView(_extensions);
}


/// Create a copy of Message
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$MessageCopyWith<_Message> get copyWith => __$MessageCopyWithImpl<_Message>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$MessageToJson(this, );
}
@override
void debugFillProperties(DiagnosticPropertiesBuilder properties) {
  properties
    ..add(DiagnosticsProperty('type', 'Message'))
    ..add(DiagnosticsProperty('messages', messages))..add(DiagnosticsProperty('replyTo', replyTo))..add(DiagnosticsProperty('timestamp', timestamp))..add(DiagnosticsProperty('who', who))..add(DiagnosticsProperty('messageId', messageId))..add(DiagnosticsProperty('extensions', extensions));
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Message&&const DeepCollectionEquality().equals(other._messages, _messages)&&(identical(other.replyTo, replyTo) || other.replyTo == replyTo)&&(identical(other.timestamp, timestamp) || other.timestamp == timestamp)&&(identical(other.who, who) || other.who == who)&&(identical(other.messageId, messageId) || other.messageId == messageId)&&const DeepCollectionEquality().equals(other._extensions, _extensions));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(_messages),replyTo,timestamp,who,messageId,const DeepCollectionEquality().hash(_extensions));

@override
String toString({ DiagnosticLevel minLevel = DiagnosticLevel.info }) {
  return 'Message(messages: $messages, replyTo: $replyTo, timestamp: $timestamp, who: $who, messageId: $messageId, extensions: $extensions)';
}


}

/// @nodoc
abstract mixin class _$MessageCopyWith<$Res> implements $MessageCopyWith<$Res> {
  factory _$MessageCopyWith(_Message value, $Res Function(_Message) _then) = __$MessageCopyWithImpl;
@override @useResult
$Res call({
 List<dynamic> messages, int? replyTo, double? timestamp, String who, int? messageId, Map<String, dynamic> extensions
});




}
/// @nodoc
class __$MessageCopyWithImpl<$Res>
    implements _$MessageCopyWith<$Res> {
  __$MessageCopyWithImpl(this._self, this._then);

  final _Message _self;
  final $Res Function(_Message) _then;

/// Create a copy of Message
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? messages = null,Object? replyTo = freezed,Object? timestamp = freezed,Object? who = null,Object? messageId = freezed,Object? extensions = null,}) {
  return _then(_Message(
messages: null == messages ? _self._messages : messages // ignore: cast_nullable_to_non_nullable
as List<dynamic>,replyTo: freezed == replyTo ? _self.replyTo : replyTo // ignore: cast_nullable_to_non_nullable
as int?,timestamp: freezed == timestamp ? _self.timestamp : timestamp // ignore: cast_nullable_to_non_nullable
as double?,who: null == who ? _self.who : who // ignore: cast_nullable_to_non_nullable
as String,messageId: freezed == messageId ? _self.messageId : messageId // ignore: cast_nullable_to_non_nullable
as int?,extensions: null == extensions ? _self._extensions : extensions // ignore: cast_nullable_to_non_nullable
as Map<String, dynamic>,
  ));
}


}

// dart format on
