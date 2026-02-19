import 'package:flutter/material.dart';
import 'question_model.dart';
import 'result_screen.dart';

class QuizScreen extends StatefulWidget {
  @override
  State<QuizScreen> createState() => _QuizScreenState();
}

class _QuizScreenState extends State<QuizScreen> {
  int currentQuestion = 0;
  int score = 0;

  void answerQuestion(int selectedIndex) {
    if (selectedIndex == sampleQuestions[currentQuestion].correctAnswerIndex) {
      score++;
    }

    setState(() {
      if (currentQuestion < sampleQuestions.length - 1) {
        currentQuestion++;
      } else {
        // Navigate to result screen
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => ResultScreen(score: score),
          ),
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final question = sampleQuestions[currentQuestion];

    return Scaffold(
      appBar: AppBar(
        title: Text("Quiz App"),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "Question ${currentQuestion + 1}/${sampleQuestions.length}",
              style: TextStyle(fontSize: 20),
            ),
            SizedBox(height: 20),
            Text(
              question.questionText,
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 20),
            ...List.generate(question.options.length, (index) {
              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: ElevatedButton(
                  onPressed: () => answerQuestion(index),
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
