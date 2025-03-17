class Assessment {
  final String id;
  final String title;
  final String description;
  final List<Question> questions;

  Assessment({
    required this.id,
    required this.title,
    required this.description,
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
