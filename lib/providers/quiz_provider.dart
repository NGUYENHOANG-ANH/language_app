import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/quiz_model.dart';

// Quiz list provider
final quizProvider =
    StateNotifierProvider.family<QuizNotifier, List<Quiz>, String>(
        (ref, topicId) {
  return QuizNotifier(topicId);
});

class QuizNotifier extends StateNotifier<List<Quiz>> {
  final String topicId;

  QuizNotifier(this.topicId) : super([]) {
    _loadQuizzes();
  }

  Future<void> _loadQuizzes() async {
    // TODO: Load from JSON or API
    state = [];
  }

  void addQuiz(Quiz quiz) {
    state = [...state, quiz];
  }

  void updateQuiz(String id, Quiz quiz) {
    state = [
      for (final q in state)
        if (q.id == id) quiz else q,
    ];
  }
}

// Current quiz index provider
final currentQuizIndexProvider = StateProvider<int>((ref) => 0);

// Quiz answer tracking
final quizAnswersProvider = StateProvider<Map<String, String>>((ref) => {});

// Quiz score provider
final quizScoreProvider = StateProvider<int>((ref) => 0);
