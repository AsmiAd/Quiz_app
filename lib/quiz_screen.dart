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
    final String response = await rootBundle.loadString(
      'lib/data/questions.json',
    );
    final data = json.decode(response);

    setState(() {
      questions = data.map<Question>((q) => Question.fromJson(q)).toList();
    });

    startTimer();
  }

  void startTimer() {
    secondsRemaining = 10;
    timer?.cancel();

    timer = Timer.periodic(Duration(seconds: 1), (timer) {
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

    Future.delayed(Duration(seconds: 2), () {
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
        MaterialPageRoute(builder: (context) => ResultScreen(score: score)),
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
    if (questions.isEmpty) {
      return Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    final question = questions[currentQuestionIndex];

    return Scaffold(
      appBar: AppBar(title: Text("Quiz App")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Text(
              "Time Left: $secondsRemaining",
              style: TextStyle(fontSize: 18, color: Colors.red),
            ),
            SizedBox(height: 20),
            Text(
              question.questionText,
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 20),
            ...List.generate(question.options.length, (index) {
              return Container(
                margin: EdgeInsets.symmetric(vertical: 8),
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
