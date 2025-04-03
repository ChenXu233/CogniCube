import 'package:freezed_annotation/freezed_annotation.dart';

part 'hitokoto_model.freezed.dart';
part 'hitokoto_model.g.dart';

@freezed
abstract class OneSentence with _$OneSentence {
  const factory OneSentence({
    required int id,
    required String tag,
    required String name,
    required String origin,
    required String content,
  }) = _OneSentence;

  factory OneSentence.fromJson(Map<String, dynamic> json) =>
      _$OneSentenceFromJson(json);
}
