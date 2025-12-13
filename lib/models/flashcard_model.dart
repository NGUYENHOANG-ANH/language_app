class Flashcard {
  final String id;
  final String word; // Từ tiếng Anh
  final String pronunciation; // Phát âm IPA
  final String imageUrl; // URL hình ảnh
  final String audioUrl; // URL âm thanh tiếng Anh
  final String? soundUrl; // URL âm thanh đặc trưng (nếu có)
  final String topicId;
  final String? vietnameseName; // Tên tiếng Việt (tuỳ chọn)
  final String? description; // Mô tả ngắn
  final int difficulty; // 1-3:  dễ, trung bình, khó

  Flashcard({
    required this.id,
    required this.word,
    required this.pronunciation,
    required this.imageUrl,
    required this.audioUrl,
    this.soundUrl,
    required this.topicId,
    this.vietnameseName,
    this.description,
    this.difficulty = 1,
  });

  factory Flashcard.fromJson(Map<String, dynamic> json) {
    return Flashcard(
      id: json['id'] as String,
      word: json['word'] as String,
      pronunciation: json['pronunciation'] as String,
      imageUrl: json['imageUrl'] as String,
      audioUrl: json['audioUrl'] as String,
      soundUrl: json['soundUrl'] as String?,
      topicId: json['topicId'] as String,
      vietnameseName: json['vietnameseName'] as String?,
      description: json['description'] as String?,
      difficulty: json['difficulty'] as int? ?? 1,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'word': word,
      'pronunciation': pronunciation,
      'imageUrl': imageUrl,
      'audioUrl': audioUrl,
      'soundUrl': soundUrl,
      'topicId': topicId,
      'vietnameseName': vietnameseName,
      'description': description,
      'difficulty': difficulty,
    };
  }
}
