class Assessment {
  final String id;
  final String title;
  final String description;
  final String type; // 新增字段：标识评估类型（如'phq9'/'gad7'）
  final List<Question> questions;

  const Assessment({
    required this.id,
    required this.title,
    required this.description,
    this.type = 'default',
    required this.questions,
  });
}

class Question {
  final String text;
  final List<String> options;
  final int correctIndex;

  Question({
    required this.text,
    required this.options,
    required this.correctIndex,
  });
}
