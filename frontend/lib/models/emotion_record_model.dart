class EmotionRecord {
  final DateTime time;
  final double valence;
  final double arousal;
  final double intensity_score;

  EmotionRecord({
    required this.time,
    required this.valence,
    required this.arousal,
    required this.intensity_score,
  });
}
