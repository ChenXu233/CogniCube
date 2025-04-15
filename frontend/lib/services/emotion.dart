// lib/services/emotion.dart
import 'package:dio/dio.dart';
import '../utils/dio_util.dart';
import '../models/emotion_record_model.dart';

class EmotionApiService {
  static final Dio _dio = DioUtil().dio;

  static Future<List<EmotionRecord>> getEmotionHistory() async {
    try {
      final response = await _dio.get('/statistics/emotion_record');
      if (response.statusCode == 200) {
        return (response.data as List)
            .map((e) => EmotionRecord.fromJson(e))
            .toList();
      } else {
        throw Exception('请求失败: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('请求失败: $e');
    }
  }
}
