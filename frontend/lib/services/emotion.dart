// lib/services/emotion.dart
import '../models/emotion_record_model.dart';

class EmotionApiService {
  static Future<List<EmotionRecord>> getEmotionHistory() async {
    // 模拟数据（替换为真实API调用）
    final now = DateTime.now();
    return [
      EmotionRecord(
        time: now.subtract(const Duration(hours: 6)),
        valence: 0.8,
        arousal: 0.6,
        intensity_score: 0.7,
      ),
      EmotionRecord(
        time: now.subtract(const Duration(hours: 4)),
        valence: 0.5,
        arousal: 0.7,
        intensity_score: 0.8,
      ),
      EmotionRecord(
        time: now.subtract(const Duration(hours: 2)),
        valence: 0.3,
        arousal: 0.4,
        intensity_score: 0.6,
      ),
      EmotionRecord(
        time: now,
        valence: 0.7,
        arousal: 0.5,
        intensity_score: 0.9,
      ),
    ];
  }
}
