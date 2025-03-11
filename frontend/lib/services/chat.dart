import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../utils/constants.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/message_model.dart' as message_model;
import '../../view_models/auth_view_model.dart';

class ChatApiService {
  static const _mockDelay = Duration(seconds: 1);
  late SharedPreferences _prefs;

  // 修改为实时获取token的header
  Map<String, String> get _headers {
    final token = _prefs.getString('auth_token') ?? '';
    print('[DEBUG] 当前使用Token: ${token.isEmpty ? "空" : "***"}'); // 调试日志
    return {'Content-Type': 'application/json', 'token': token};
  }

  // ChatApiService();

  static Future<ChatApiService> create() async {
    final instance = ChatApiService._();
    await instance._initialize();
    return instance;
  }

  ChatApiService._();

  Future<void> _initialize() async {
    _prefs = await SharedPreferences.getInstance();
  }

  Future<List<message_model.Message>> getChatHistory(
    double timeStart,
    double timeEnd,
  ) async {
    _validateTimeRange(timeStart, timeEnd);
    int timeStart0 = timeStart.toInt();
    int timeEnd0 = timeEnd.toInt();

    if (Constants.useMockResponses) {
      await Future.delayed(_mockDelay);
      return _mockHistoryMessages();
    }

    try {
      final uri = Uri.parse(
        '${Constants.backendUrl}/ai/history?'
        'start_time=$timeStart0&end_time=$timeEnd0',
      );

      final response = await http
          .get(uri, headers: _headers)
          .timeout(const Duration(seconds: 30));

      print('[DEBUG]: 状态码${response.statusCode}');
      if (response.statusCode == 401) {
        _handleUnauthorized();
        throw ApiException('未授权，请重新登录');
      }
      print(response.body); // 调试日志

      return _handleResponse<List<message_model.Message>>(
        response,
        parse:
            (data) =>
                (data['history'] as List)
                    .map((e) => message_model.Message.fromJson(e))
                    .toList(),
      );
    } on TimeoutException {
      throw ApiException('请求超时');
    } catch (e) {
      throw ApiException('获取历史记录失败: ${_sanitizeError(e)}');
    }
  }

  Future<String> getAIResponse(String message) async {
    if (Constants.useMockResponses) {
      await Future.delayed(_mockDelay);
      return "Mock AI Response to: $message";
    }

    try {
      final body = {
        'messages':
            message_model.Message(
              messages: [message_model.Text(text: message)],
              who: 'user',
              extension: {},
            ).toJson(),
      };

      final response = await http
          .post(
            Uri.parse('${Constants.backendUrl}/ai/conversation'),
            headers: _headers,
            body: body,
          )
          .timeout(const Duration(seconds: 60));

      return _handleResponse<String>(
        response,
        parse: (data) => data['message']['text'] ?? "未收到有效响应",
      );
    } on TimeoutException {
      throw ApiException('请求超时');
    } catch (e) {
      throw ApiException('获取AI响应失败: ${_sanitizeError(e)}');
    }
  }

  // 新增错误信息过滤
  String _sanitizeError(dynamic e) {
    final str = e.toString();
    final token = _prefs.getString('auth_token') ?? '';
    return token.isEmpty ? str : str.replaceAll(token, '***');
  }

  T _handleResponse<T>(
    http.Response response, {
    required T Function(dynamic) parse,
  }) {
    if (response.statusCode == 401) {
      throw ApiException('身份验证过期，请重新登录');
    }

    if (response.statusCode != 200) {
      throw ApiException('服务器错误: ${response.statusCode}');
    }

    try {
      final data = jsonDecode(utf8.decode(response.bodyBytes));
      print(data);
      return parse(data);
    } catch (e) {
      throw ApiException('响应解析失败: ${e.toString()}');
    }
  }

  void _validateTimeRange(double timeStart, double timeEnd) {
    if (timeStart < 0 || timeEnd < 0) {
      throw ArgumentError('时间戳不能为负数');
    }
    if (timeEnd < timeStart) {
      throw ArgumentError('结束时间不能早于开始时间');
    }
  }

  List<message_model.Message> _mockHistoryMessages() => [
    message_model.Message(
      messages: [message_model.Text(text: '历史消息1：你好，有什么可以帮助你的？')],
      who: 'assistant',
      extension: {},
    ),
  ];

  Future<void> _handleUnauthorized() {
    AuthViewModel(prefs: _prefs).logout();
    return Future.value();
  }
}

class ApiException implements Exception {
  final String message;
  const ApiException(this.message);

  @override
  String toString() => message;
}
