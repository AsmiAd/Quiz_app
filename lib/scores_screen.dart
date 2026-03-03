import 'package:flutter/material.dart';
import 'package:quiz_app/app_style.dart';
import 'score_store.dart';

class ScoresScreen extends StatelessWidget {
  const ScoresScreen({super.key});

  Future<void> _confirmClearScores(BuildContext context) async {
    final shouldClear = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Clear all scores?'),
        content: const Text('This will remove your recent score history.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Clear'),
          ),
        ],
      ),
    );

    if (shouldClear != true) {
      return;
    }

    ScoreStore.clearScores();
    if (!context.mounted) return;
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text('Score history cleared')));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(AppText.recentScores),
        actions: [
          TextButton(
            onPressed: () => _confirmClearScores(context),
            child: const Text(AppText.clearScores),
          ),
        ],
      ),
      body: ValueListenableBuilder(
        valueListenable: ScoreStore.scores,
        builder: (context, scores, child) {
          if (scores.isEmpty) {
            return const Center(
              child: Text(
                AppText.noScores,
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 18),
              ),
            );
          }

          return ListView.separated(
            padding: const EdgeInsets.all(16),
            itemBuilder: (context, index) {
              final entry = scores[index];
              return ListTile(
                tileColor: Colors.blue.shade50,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                leading: CircleAvatar(child: Text('${entry.percentage}%')),
                title: Text('${entry.score} / ${entry.totalQuestions}'),
                subtitle: Text(
                  'Completed: ${entry.completedAt.toLocal().toString().split('.').first}',
                ),
              );
            },
            separatorBuilder: (_, __) => const SizedBox(height: 10),
            itemCount: scores.length,
          );
        },
      ),
    );
  }
}
