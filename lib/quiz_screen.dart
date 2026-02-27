import 'dart:async';

import 'package:flutter/material.dart';
import 'package:quiz_app/app_style.dart';

import 'question_model.dart';
import 'question_repository.dart';
import 'quiz_config.dart';
import 'result_screen.dart';

class QuizScreen extends StatefulWidget {
  final QuizConfig config;

  const QuizScreen({super.key, required this.config});

  @override
  State<QuizScreen> createState() => _QuizScreenState();
}

class _QuizScreenState extends State<QuizScreen> {
  final QuestionRepository _repository = QuestionRepository();
  List<Question> questions = [];
  int currentQuestionIndex = 0;
  int score = 0;
  int? selectedIndex;
  bool answerSelected = false;
  int secondsRemaining = 10;
  Timer? timer;
  bool isLoading = true;
  bool hasLoadingError = false;
  bool usedApiFallback = false;

  @override
  void initState() {
    super.initState();
    loadQuestions();
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  Future<void> loadQuestions() async {
    try {
      final loadedQuestions = await _repository.loadQuestions(widget.config);

      if (!mounted) return;
      setState(() {
        questions = loadedQuestions;
        isLoading = false;
        hasLoadingError = false;
        usedApiFallback =
            widget.config.source == QuizSource.api && loadedQuestions.length != 10;
      });

      startTimer();
    } catch (_) {
      if (!mounted) return;

      setState(() {
        questions = [];
        isLoading = false;
        hasLoadingError = true;
      });
    }
  }

  void startTimer() {
    timer?.cancel();
    setState(() {
      secondsRemaining = 10;
    });

    timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (secondsRemaining > 0) {
        setState(() {
          secondsRemaining--;
        });
      } else {
        timer.cancel();
        nextQuestion();
      }
    });
  }

  void selectAnswer(int index) {
    if (answerSelected) return;

    setState(() {
      selectedIndex = index;
      answerSelected = true;

      if (index == questions[currentQuestionIndex].correctAnswerIndex) {
        score++;
      }
    });

    timer?.cancel();

    Future.delayed(const Duration(seconds: 2), () {
      if (!mounted) return;
      nextQuestion();
    });
  }

  void nextQuestion() {
    if (currentQuestionIndex < questions.length - 1) {
      setState(() {
        currentQuestionIndex++;
        selectedIndex = null;
        answerSelected = false;
      });
      startTimer();
    } else {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => ResultScreen(
            score: score,
            totalQuestions: questions.length,
            config: widget.config,
          ),
        ),
      );
    }
  }

  Color getOptionColor(int index) {
    if (!answerSelected) return AppColors.optionDefault;

    if (index == questions[currentQuestionIndex].correctAnswerIndex) {
      return AppColors.success;
    }

    if (index == selectedIndex) {
      return AppColors.danger;
    }

    return AppColors.optionDefault;
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    if (hasLoadingError) {
      return Scaffold(
        appBar: AppBar(title: const Text(AppText.appTitle)),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                AppText.loadError,
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
              ),
              const SizedBox(height: 12),
              ElevatedButton(
                onPressed: () {
                  setState(() {
                    isLoading = true;
                    hasLoadingError = false;
                  });
                  loadQuestions();
                },
                child: const Text(AppText.retry),
              ),
            ],
          ),
        ),
      );
    }

    if (questions.isEmpty) {
      return const Scaffold(body: Center(child: Text(AppText.noQuestions)));
    }

    final question = questions[currentQuestionIndex];
    final totalQuestions = questions.length;
    final currentQuestionNumber = currentQuestionIndex + 1;
    final progressValue = currentQuestionNumber / totalQuestions;

    return Scaffold(
      appBar: AppBar(title: Text('${AppText.appTitle} • ${widget.config.category.name}')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            if (usedApiFallback)
              const Padding(
                padding: EdgeInsets.only(bottom: 8),
                child: Text(
                  AppText.apiFallback,
                  style: TextStyle(color: Colors.orange, fontSize: 12),
                  textAlign: TextAlign.center,
                ),
              ),
            Text(
              "${AppText.timerLabel}: $secondsRemaining",
              style: const TextStyle(fontSize: 18, color: AppColors.timer),
            ),
            const SizedBox(height: 12),
            Text(
              "${AppText.questionLabel} $currentQuestionNumber of $totalQuestions",
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
            ),
            const SizedBox(height: 8),
            LinearProgressIndicator(
              value: progressValue,
              backgroundColor: Colors.grey[300],
              color: AppColors.primary,
              minHeight: 8,
            ),
            const SizedBox(height: 20),
            Text(
              question.questionText,
              style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            ...List.generate(question.options.length, (index) {
              return Container(
                margin: const EdgeInsets.symmetric(vertical: 8),
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: getOptionColor(index),
                  ),
                  onPressed: () => selectAnswer(index),
                  child: Text(question.options[index]),
                ),
              );
            }),
          ],
        ),
      ),
    );
  }
}
