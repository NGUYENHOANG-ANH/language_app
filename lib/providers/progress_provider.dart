import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/user_progress_model.dart';

// User progress provider
final userProgressProvider =
    StateNotifierProvider<UserProgressNotifier, UserProgress>((ref) {
  return UserProgressNotifier();
});

class UserProgressNotifier extends StateNotifier<UserProgress> {
  UserProgressNotifier()
      : super(
          UserProgress(
            userId: 'child_001',
            topicProgress: {},
            totalStars: 0,
            lastAccessedTime: DateTime.now(),
            unlockedAchievements: [],
          ),
        ) {
    _loadProgress();
  }

  Future<void> _loadProgress() async {
    // TODO: Load from local storage (Hive)
  }

  void addStars(String topicId, int starsToAdd) {
    final currentProgress = state.topicProgress[topicId];

    // ✅ Tạo TopicProgress mới
    final newTopicProgress = TopicProgress(
      topicId: topicId,
      starsEarned: (currentProgress?.starsEarned ?? 0) + starsToAdd,
      levelProgress: currentProgress?.levelProgress ?? {},
      flashcardsReviewed: currentProgress?.flashcardsReviewed ?? 0,
      lastCompletedTime: DateTime.now(),
    );

    // ✅ Cập nhật map
    final updatedTopicMap = {
      ...state.topicProgress,
      topicId: newTopicProgress,
    };

    // ✅ Sử dụng copyWith
    state = state.copyWith(
      topicProgress: updatedTopicMap,
      totalStars: state.totalStars + starsToAdd,
    );
  }

  void updateFlashcardsReviewed(String topicId, int count) {
    final currentProgress = state.topicProgress[topicId];

    // ✅ Tạo TopicProgress mới
    final newTopicProgress = TopicProgress(
      topicId: topicId,
      starsEarned: currentProgress?.starsEarned ?? 0,
      levelProgress: currentProgress?.levelProgress ?? {},
      flashcardsReviewed: count,
      lastCompletedTime: DateTime.now(),
    );

    // ✅ Cập nhật map
    final updatedTopicMap = {
      ...state.topicProgress,
      topicId: newTopicProgress,
    };

    // ✅ Sử dụng copyWith
    state = state.copyWith(topicProgress: updatedTopicMap);
  }
}
