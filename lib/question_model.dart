import 'dart:math';

class Question {
  final String questionText;
  final List<String> options;
  final int correctAnswerIndex;

  Question({
    required this.questionText,
    required this.options,
    required this.correctAnswerIndex,
  });

  factory Question.fromJson(Map<String, dynamic> json) {
    return Question(
      questionText: json['question'] as String,
      options: List<String>.from(json['options'] as List<dynamic>),
      correctAnswerIndex: json['answer_index'] as int,
    );
  }

  factory Question.fromApi(Map<String, dynamic> json) {
    final correctAnswer = _decodeHtml(json['correct_answer'] as String);
    final incorrectAnswers = (json['incorrect_answers'] as List<dynamic>)
        .map((e) => _decodeHtml(e as String))
        .toList();

    final allOptions = [...incorrectAnswers, correctAnswer];
    allOptions.shuffle(Random());

    return Question(
      questionText: _decodeHtml(json['question'] as String),
      options: allOptions,
      correctAnswerIndex: allOptions.indexOf(correctAnswer),
    );
  }

  static String _decodeHtml(String input) {
    return input
        .replaceAll('&quot;', '"')
        .replaceAll('&#039;', "'")
        .replaceAll('&amp;', '&')
        .replaceAll('&lt;', '<')
        .replaceAll('&gt;', '>')
        .replaceAll('&eacute;', 'é')
        .replaceAll('&uuml;', 'ü');
  }
}