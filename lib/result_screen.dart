import 'package:flutter/material.dart';
import 'package:quiz_app/app_style.dart';
import 'package:quiz_app/home_screen.dart';
import 'package:quiz_app/score_store.dart';
import 'quiz_screen.dart';

class ResultScreen extends StatelessWidget {
  final int score;
  final int totalQuestions;

  const ResultScreen({
    super.key,
    required this.score,
    required this.totalQuestions,
  });

  @override
  Widget build(BuildContext context) {
    final percentage = totalQuestions == 0
        ? 0
        : (score / totalQuestions * 100).round();
    return Scaffold(
      appBar: AppBar(title: const Text(AppText.resultTitle)),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text('Your Score', style: TextStyle(fontSize: 24)),
              const SizedBox(height: 10),
              Text(
                '$score',
                style: const TextStyle(
                  fontSize: 40,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                '$score out of $totalQuestions ($percentage%)',
                style: const TextStyle(fontSize: 16),
              ),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    ScoreStore.addScore(
                      score: score,
                      totalQuestions: totalQuestions,
                    );
                    Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const HomeScreen(),
                      ),
                      (_) => false,
                    );
                  },
                  child: const Text('Save & Go Home'),
                ),
              ),
              const SizedBox(height: 10),
              SizedBox(
                width: double.infinity,
                child: OutlinedButton(
                  onPressed: () {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const QuizScreen(),
                      ),
                    );
                  },
                  child: const Text('Restart Quiz'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
