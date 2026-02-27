import 'package:flutter/material.dart';

class AppColors {
  static const Color primary = Colors.blue;
  static const Color success = Colors.green;
  static const Color danger = Colors.red;
  static const Color timer = Colors.red;

  static const Color optionDefault = primary;
}

class AppText {
  static const String appTitle = 'Quiz App';
  static const String homeTitle = 'Quiz Home';
  static const String homeWelcomeTitle = 'Welcome to Quiz Master';
  static const String homeWelcomeSubtitle =
      'Play a quick quiz and track your recent scores.';
  static const String startQuiz = 'Start Quiz';
  static const String questionSource = 'Question Source';
  static const String category = 'Category';
  static const String localQuestions = 'My Questions';
  static const String apiQuestions = 'Online Questions';
  static const String viewScores = 'View Scores';

  static const String timerLabel = 'Time Left';
  static const String questionLabel = 'Question';

  static const String resultTitle = 'Your Result';
  static const String yourScore = 'Your Score';
  static const String saveAndGoHome = 'Save & Go Home';
  static const String restartQuiz = 'Restart Quiz';

  static const String recentScores = 'Recent Scores';
  static const String clearScores = 'Clear';
  static const String noScores =
      'No scores yet.\nPlay a quiz to see results here.';

  static const String retry = 'Retry';
  static const String apiFallback =
      'Could not fetch online questions. Loaded local questions instead.';
  static const String noQuestions = 'No questions available.';
  static const String loadError = 'Could not load questions.';
}
