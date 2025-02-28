import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../utils/constants.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ChatApiService {
  static Future<String> getAIResponse(String message) async {
    await Future.delayed(const Duration(seconds: 1)); // 模拟延迟
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token') ?? '';
    if (Constants.useMockResponses) {
      return "Mock AI Response to: $message";
    }

    try {
      final response = await http.post(
        Uri.parse('${Constants.backendUrl}/ai/conversation?token=$token'),
        headers: {
          'Content-Type': 'application/json',
        },
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