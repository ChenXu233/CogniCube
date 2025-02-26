class Constants {
  static const String aiApiKey = String.fromEnvironment('AI_API_KEY');
  static const String aiEndpoint = 'https://api.example-ai.com/chat';
  static const bool useMockResponses = bool.fromEnvironment('USE_MOCK');
  static const String backendUrl = 'http://127.0.0.1:8000/apis/v1';
}