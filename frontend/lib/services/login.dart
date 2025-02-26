import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../utils/constants.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginApiService {
  static Future<String> getLoginResponse(String username, String password) async {
    try {
      final response = await http.post(
        Uri.parse('${Constants.backendUrl}/login'),
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'username': username,
          'password': password,
        }),
      ).timeout(const Duration(seconds: 10));

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString("token", data['token']);
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