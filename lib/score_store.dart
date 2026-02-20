import 'package:flutter/foundation.dart';
import 'score_entry.dart';

class ScoreStore {
  ScoreStore._();

  static final ValueNotifier<List<ScoreEntry>> scores =
      ValueNotifier<List<ScoreEntry>>([]);

  static void addScore({required int score, required int totalQuestions}) {
    final updatedScores = List<ScoreEntry>.from(scores.value)
      ..insert(
        0,
        ScoreEntry(
          score: score,
          totalQuestions: totalQuestions,
          completedAt: DateTime.now(),
        ),
      );
    scores.value = updatedScores;
  }

  static void clearScores() {
    scores.value = [];
  }
}
