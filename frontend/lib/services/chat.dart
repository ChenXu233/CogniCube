import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../utils/constants.dart';

class ApiService {
  static Future<String> getAIResponse(String message) async {
    await Future.delayed(const Duration(seconds: 1)); // 模拟延迟

    if (Constants.useMockResponses) {
      return "Mock AI Response to: $message";
    }

    try {
      final response = await http.post(
        Uri.parse(Constants.aiEndpoint),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer ${Constants.aiApiKey}'
        },
        body: jsonEncode({'message': message}),
      ).timeout(const Duration(seconds: 10));

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return data['response'] ?? "No response";
      }
      throw "API Error: ${response.statusCode}";
    } on TimeoutException {
      throw "Request timed out";
    } catch (e) {
      throw "Network Error: $e";
    }
  }
}