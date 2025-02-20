class Constants {
  static const String aiApiKey = String.fromEnvironment('AI_API_KEY');
  static const String aiEndpoint = 'https://api.example-ai.com/chat';
  static const bool useMockResponses = bool.fromEnvironment('USE_MOCK');
}