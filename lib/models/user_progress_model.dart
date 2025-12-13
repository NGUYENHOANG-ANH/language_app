class UserProgress {
  final String userId;
  final Map<String, TopicProgress> topicProgress;
  final int totalStars;
  final DateTime lastAccessedTime;
  final List<String> unlockedAchievements;

  UserProgress({
    required this.userId,
    required this.topicProgress,
    required this.totalStars,
    required this.lastAccessedTime,
    required this.unlockedAchievements,
  });

  // ✅ THÊM copyWith()
  UserProgress copyWith({
    String? userId,
    Map<String, TopicProgress>? topicProgress,
    int? totalStars,
    DateTime? lastAccessedTime,
    List<String>? unlockedAchievements,
  }) {
    return UserProgress(
      userId: userId ?? this.userId,
      topicProgress: topicProgress ?? this.topicProgress,
      totalStars: totalStars ?? this.totalStars,
      lastAccessedTime: lastAccessedTime ?? this.lastAccessedTime,
      unlockedAchievements: unlockedAchievements ?? this.unlockedAchievements,
    );
  }

  factory UserProgress.fromJson(Map<String, dynamic> json) {
    final progressMap = (json['topicProgress'] as Map<String, dynamic>?)?.map(
            (key, value) => MapEntry(
                key, TopicProgress.fromJson(value as Map<String, dynamic>))) ??
        {};

    return UserProgress(
      userId: json['userId'] as String,
      topicProgress: progressMap,
      totalStars: json['totalStars'] as int? ?? 0,
      lastAccessedTime: DateTime.parse(json['lastAccessedTime'] as String),
      unlockedAchievements:
          List<String>.from(json['unlockedAchievements'] as List? ?? []),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'userId': userId,
      'topicProgress':
          topicProgress.map((key, value) => MapEntry(key, value.toJson())),
      'totalStars': totalStars,
      'lastAccessedTime': lastAccessedTime.toIso8601String(),
      'unlockedAchievements': unlockedAchievements,
    };
  }
}

class TopicProgress {
  final String topicId;
  final int starsEarned;
  final Map<int, int> levelProgress;
  final int flashcardsReviewed;
  final DateTime lastCompletedTime;

  TopicProgress({
    required this.topicId,
    required this.starsEarned,
    required this.levelProgress,
    required this.flashcardsReviewed,
    required this.lastCompletedTime,
  });

  factory TopicProgress.fromJson(Map<String, dynamic> json) {
    final levelMap = (json['levelProgress'] as Map<String, dynamic>?)
            ?.map((key, value) => MapEntry(int.parse(key), value as int)) ??
        {};

    return TopicProgress(
      topicId: json['topicId'] as String,
      starsEarned: json['starsEarned'] as int? ?? 0,
      levelProgress: levelMap,
      flashcardsReviewed: json['flashcardsReviewed'] as int? ?? 0,
      lastCompletedTime: DateTime.parse(json['lastCompletedTime'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'topicId': topicId,
      'starsEarned': starsEarned,
      'levelProgress':
          levelProgress.map((key, value) => MapEntry(key.toString(), value)),
      'flashcardsReviewed': flashcardsReviewed,
      'lastCompletedTime': lastCompletedTime.toIso8601String(),
    };
  }
}
