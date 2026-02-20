import 'package:flutter/material.dart';
import 'score_store.dart';

class ScoresScreen extends StatelessWidget {
  const ScoresScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Recent Scores'),
        actions: [
          TextButton(
            onPressed: ScoreStore.clearScores,
            child: const Text('Clear'),
          ),
        ],
      ),
      body: ValueListenableBuilder(
        valueListenable: ScoreStore.scores,
        builder: (context, scores, child) {
          if (scores.isEmpty) {
            return const Center(
              child: Text(
                'No scores yet.\nPlay a quiz to see results here.',
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
