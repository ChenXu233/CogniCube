import 'package:dio/dio.dart';
import '../utils/dio_util.dart';
import '../models/message_model.dart' as message_model;

class ChatApiService {
  static final Dio _dio = DioUtil().dio;

  static Future<List<message_model.Message>> getChatHistory(
    int timeStart,
    int timeEnd,
  ) async {
    final timeStart0 = timeStart.toInt();
    final timeEnd0 = timeEnd.toInt();

    try {
      final response = await _dio.get(
        '/ai/history',
        queryParameters: {'start_time': timeStart0, 'end_time': timeEnd0},
      );

      return (response.data['history'] as List)
          .map((e) => message_model.Message.fromJson(e))
          .toList();
    } on DioException catch (e) {
      throw _handleDioError(e);
    }
  }

  static Future<String> getAIResponse(String message) async {
    try {
      final body = {
        'message':
            message_model.Message(
              messages: [message_model.TextModel(text: message)],
              who: 'user',
            ).toJson(),
      }; // 直接序列化整个消息对象

      final response = await _dio.post(
        '/ai/conversation',
        data: body, // 直接使用序列化后的对象
      );

      return (response.data['message']['messages'] as List)
          .map((msg) => msg['text']?.toString() ?? "未收到有效响应")
          .join('\n');
    } on DioException catch (e) {
      throw _handleDioError(e);
    } catch (e) {
      throw Exception('获取 AI 回复失败: $e');
    }
  }

  static Exception _handleDioError(DioException e) {
    return Exception('网络请求失败: ${e.response?.statusCode}');
  }
}
