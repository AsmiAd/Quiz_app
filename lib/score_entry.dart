class ScoreEntry {
  final int score;
  final int totalQuestions;
  final DateTime completedAt;

  const ScoreEntry({
    required this.score,
    required this.totalQuestions,
    required this.completedAt,
  });

  int get percentage {
    if (totalQuestions == 0) return 0;
    return ((score / totalQuestions) * 100).round();
  }
}
