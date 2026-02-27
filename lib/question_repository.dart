import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'question_model.dart';
import 'quiz_config.dart';

class QuestionRepository {
  static const int apiQuestionCount = 10;

  Future<List<Question>> loadQuestions(QuizConfig config) async {
    if (config.source == QuizSource.api) {
      try {
        return await _loadFromApi(config.category);
      } catch (_) {
        return _loadFromLocal(config.category);
      }
    }
    return _loadFromLocal(config.category);
  }

  Future<List<Question>> _loadFromLocal(QuizCategory category) async {
    final String response = await rootBundle.loadString(
      'lib/data/questions.json',
    );
    final List<dynamic> data = json.decode(response) as List<dynamic>;

    final filtered = data.where((q) {
      final jsonMap = q as Map<String, dynamic>;
      return jsonMap['category'] == category.id;
    });

    return filtered
        .map<Question>((q) => Question.fromJson(q as Map<String, dynamic>))
        .toList();
  }

  Future<List<Question>> _loadFromApi(QuizCategory category) async {
    final apiCategoryId = category.apiCategoryId;
    if (apiCategoryId == null) {
      throw Exception('Category not mapped to API id');
    }

    final uri = Uri.https('opentdb.com', '/api.php', {
      'amount': '$apiQuestionCount',
      'category': '$apiCategoryId',
      'type': 'multiple',
    });

    final response = await http.get(uri);

    if (response.statusCode != 200) {
      throw Exception('Failed to load API questions');
    }

    final decoded = json.decode(response.body) as Map<String, dynamic>;
    final responseCode = decoded['response_code'] as int?;
    if (responseCode != 0) {
      throw Exception('API returned no questions');
    }

    final results = decoded['results'] as List<dynamic>;
    return results
        .map<Question>((item) => Question.fromApi(item as Map<String, dynamic>))
        .toList();
  }
}
