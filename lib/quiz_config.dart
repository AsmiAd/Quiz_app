enum QuizSource { local, api }

class QuizCategory {
  final String id;
  final String name;
  final int? apiCategoryId;

  const QuizCategory({
    required this.id,
    required this.name,
    this.apiCategoryId,
  });
}

class QuizConfig {
  final QuizSource source;
  final QuizCategory category;

  const QuizConfig({required this.source, required this.category});
}

const List<QuizCategory> quizCategories = [
  QuizCategory(id: 'general', name: 'General Knowledge', apiCategoryId: 9),
  QuizCategory(id: 'science', name: 'Science & Nature', apiCategoryId: 17),
  QuizCategory(id: 'history', name: 'History', apiCategoryId: 23),
  QuizCategory(id: 'technology', name: 'Technology', apiCategoryId: 18),
];