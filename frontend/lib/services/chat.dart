import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../utils/constants.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/message_model.dart';

class ChatApiService {
  late SharedPreferences prefs;
  late String token;

  ChatApiService() {
    init();
  }

  Future<void> init() async {
    prefs = await SharedPreferences.getInstance();
    token = prefs.getString('token') ?? '';
    headers['token'] = token;
  }

  static Map<String, String> headers = {
    'Content-Type': 'application/json',
    'token': '',
  };

  static Future<List<Message>> getChatHistory(double timeStart, double timeEnd) async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token') ?? '';
    headers['token'] = token;

    if (Constants.useMockResponses) {
      await Future.delayed(const Duration(seconds: 1));
      return [
        Message(text: '历史消息1：你好！', type: MessageType.ai),
        Message(text: '历史消息2：有什么可以帮助你的？', type: MessageType.ai),
      ];

    } else {
      try {
        final response = await http.get(
          Uri.parse('${Constants.backendUrl}/ai/conversation?time_start=$timeStart&time_end=$timeEnd'),
          headers: headers,
        ).timeout(const Duration(seconds: 30));

        if (response.statusCode == 200) {
          final data = jsonDecode(utf8.decode(latin1.encode(response.body)));
          return (data['messages'] as List).map((e) => Message.fromJson(e)).toList();
        } else {
          throw "API Error: ${response.statusCode}";
        }
      } catch (e) {
        throw "Network Error: $e";
      }
    }
  }

  static Future<String> getAIResponse(String message) async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token') ?? '';
    headers['token'] = token;

    if (Constants.useMockResponses) {
      await Future.delayed(const Duration(seconds: 1)); // 模拟延迟
      return "Mock AI Response to: $message";
    }

    try {
      final response = await http.post(
        Uri.parse('${Constants.backendUrl}/ai/conversation'),
        headers: headers,
        body: jsonEncode({'message': message}),
      ).timeout(const Duration(seconds: 30));

      if (response.statusCode == 200) {
        final data = jsonDecode(utf8.decode(latin1.encode(response.body)));
        return data['reply'] ?? "No response";
      }
      throw "API Error: ${response.statusCode}";
    } on TimeoutException {
      throw "Request timed out";
    } catch (e) {
      throw "Network Error: $e";
    }
  }
}
