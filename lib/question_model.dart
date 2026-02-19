class Question {
  final String questionText;
  final List<String> options;
  final int correctAnswerIndex;

  Question({
    required this.questionText,
    required this.options,
    required this.correctAnswerIndex,
  });
}

// Sample questions for the quiz
List<Question> sampleQuestions = [
  Question(
    questionText: "What is the capital of Nepal?",
    options: ["Kathmandu", "Pokhara", "Lalitpur", "Bhaktapur"],
    correctAnswerIndex: 0,
  ),
  Question(
    questionText: "Flutter is developed by?",
    options: ["Apple", "Google", "Microsoft", "Facebook"],
    correctAnswerIndex: 1,
  ),
  Question(
    questionText: "Which language is used in Flutter?",
    options: ["Java", "C++", "Dart", "Python"],
    correctAnswerIndex: 2,
  ),
];