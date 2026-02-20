import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'question_model.dart';
import 'result_screen.dart';

class QuizScreen extends StatefulWidget {
  const QuizScreen({super.key});

  @override
  State<QuizScreen> createState() => _QuizScreenState();
}

class _QuizScreenState extends State<QuizScreen> {
  List<Question> questions = [];
  int currentQuestionIndex = 0;
  int score = 0;
  int? selectedIndex;
  bool answerSelected = false;
  int secondsRemaining = 10;
  Timer? timer;
  bool isLoading = true;
  bool hasLoadingError = false;

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
      final String response = await rootBundle.loadString(
        'lib/data/questions.json',
      );
      final data = json.decode(response);

      if (!mounted) return;
      setState(() {
        questions = data.map<Question>((q) => Question.fromJson(q)).toList();
        isLoading = false;
        hasLoadingError = false;
      });

      startTimer();
    } catch (_) {
      if (!mounted) return;

      setState(() {
        questions = [];
        isLoading = false;
        hasLoadingError = false;
      });
    }
  }

  void startTimer() {
    secondsRemaining = 10;
    timer?.cancel();

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
          builder: (context) =>
              ResultScreen(score: score, totalQuestions: questions.length),
        ),
      );
    }
  }

  Color getOptionColor(int index) {
    if (!answerSelected) return Colors.blue;

    if (index == questions[currentQuestionIndex].correctAnswerIndex) {
      return Colors.green;
    }

    if (index == selectedIndex) {
      return Colors.red;
    }

    return Colors.blue;
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    if (hasLoadingError) {
      return Scaffold(
        appBar: AppBar(title: const Text("Quiz App")),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                "Could not load questions.",
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
                child: const Text("Retry"),
              ),
            ],
          ),
        ),
      );
    }

    if (questions.isEmpty) {
      return const Scaffold(
        body: Center(child: Text("No questions available.")),
      );
    }

    final question = questions[currentQuestionIndex];
    final totalQuestions = questions.length;
    final currentQuestionNumber = currentQuestionIndex + 1;
    final progressValue = currentQuestionNumber / totalQuestions;

    return Scaffold(
      appBar: AppBar(title: const Text("Quiz App")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Text(
              "Time Left: $secondsRemaining",
              style: const TextStyle(fontSize: 18, color: Colors.red),
            ),
            const SizedBox(height: 12),
            Text(
              "Question $currentQuestionNumber of $totalQuestions",
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
            ),
            const SizedBox(height: 8),
            LinearProgressIndicator(
              value: progressValue,
              backgroundColor: Colors.grey[300],
              color: Colors.blue,
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
