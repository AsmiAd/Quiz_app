import 'package:flutter/material.dart';
import 'package:quiz_app/app_style.dart';
import 'package:quiz_app/quiz_config.dart';
import 'quiz_screen.dart';
import 'scores_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  QuizSource _selectedSource = QuizSource.local;
  QuizCategory _selectedCategory = quizCategories.first;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text(AppText.homeTitle), centerTitle: true),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(
                Icons.emoji_events_rounded,
                size: 90,
                color: Colors.orange,
              ),
              const SizedBox(height: 16),
              const Text(
                AppText.homeWelcomeTitle,
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),
              const Text(
                AppText.homeWelcomeSubtitle,
                style: TextStyle(fontSize: 16),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 30),
              const SizedBox(height: 24),
              DropdownButtonFormField<QuizSource>(
                value: _selectedSource,
                decoration: const InputDecoration(
                  labelText: AppText.questionSource,
                  border: OutlineInputBorder(),
                ),
                items: const [
                  DropdownMenuItem(
                    value: QuizSource.local,
                    child: Text(AppText.localQuestions),
                  ),
                  DropdownMenuItem(
                    value: QuizSource.api,
                    child: Text(AppText.apiQuestions),
                  ),
                ],
                onChanged: (value) {
                  if (value == null) return;
                  setState(() {
                    _selectedSource = value;
                  });
                },
              ),
              const SizedBox(height: 12),
              DropdownButtonFormField<QuizCategory>(
                value: _selectedCategory,
                decoration: const InputDecoration(
                  labelText: AppText.category,
                  border: OutlineInputBorder(),
                ),
                items: quizCategories
                    .map(
                      (category) => DropdownMenuItem(
                        value: category,
                        child: Text(category.name),
                      ),
                    )
                    .toList(),
                onChanged: (value) {
                  if (value == null) return;
                  setState(() {
                    _selectedCategory = value;
                  });
                },
              ),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => QuizScreen(
                          config: QuizConfig(
                            source: _selectedSource,
                            category: _selectedCategory,
                          ),
                        ),
                      ),
                    );
                  },
                  icon: const Icon(Icons.play_arrow_rounded),
                  label: const Text(AppText.startQuiz),
                ),
              ),
              const SizedBox(height: 12),
              SizedBox(
                width: double.infinity,
                child: OutlinedButton.icon(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const ScoresScreen(),
                      ),
                    );
                  },
                  icon: const Icon(Icons.leaderboard_rounded),
                  label: const Text(AppText.viewScores),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
