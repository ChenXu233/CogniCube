import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../utils/constants.dart';

class RegisterApiService {
  static Future<String> getRegisterResponse(
    String username,
    String password,
    String email,
  ) async {
    try {
      final response = await http.post(
        Uri.parse('${Constants.backendUrl}/auth/register'),
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'email': email,
          'username': username,
          'password': password,
        }),
      ).timeout(const Duration(seconds: 10));

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        // Extract the String field from the response (e.g., 'message' or 'token')
        final result = data['message'] as String?;
        return result ?? "No message in response";
      }
      throw "API Error: ${response.statusCode}";
    } on TimeoutException {
      throw "Request timed out";
    } catch (e) {
      throw "Network Error: $e";
    }
  }
}