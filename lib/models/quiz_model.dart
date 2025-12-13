class Quiz {
  final String id;
  final String topicId;
  final String question; // Dạng câu hỏi (text/image/audio)
  final String questionType; // 'image', 'text', 'audio'
  final String? imageUrl; // Hình ảnh câu hỏi
  final String? audioUrl; // Âm thanh câu hỏi
  final List<QuizOption> options; // Các lựa chọn
  final String correctAnswerId; // ID câu trả lời đúng
  final int
      level; // 1: dễ (2 options), 2: trung bình (3 options), 3: khó (4 options)
  final int? timeLimit; // Giới hạn thời gian (giây)

  Quiz({
    required this.id,
    required this.topicId,
    required this.question,
    required this.questionType,
    this.imageUrl,
    this.audioUrl,
    required this.options,
    required this.correctAnswerId,
    required this.level,
    this.timeLimit,
  });

  factory Quiz.fromJson(Map<String, dynamic> json) {
    return Quiz(
      id: json['id'] as String,
      topicId: json['topicId'] as String,
      question: json['question'] as String,
      questionType: json['questionType'] as String,
      imageUrl: json['imageUrl'] as String?,
      audioUrl: json['audioUrl'] as String?,
      options: (json['options'] as List)
          .map((o) => QuizOption.fromJson(o as Map<String, dynamic>))
          .toList(),
      correctAnswerId: json['correctAnswerId'] as String,
      level: json['level'] as int? ?? 1,
      timeLimit: json['timeLimit'] as int?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'topicId': topicId,
      'question': question,
      'questionType': questionType,
      'imageUrl': imageUrl,
      'audioUrl': audioUrl,
      'options': options.map((o) => o.toJson()).toList(),
      'correctAnswerId': correctAnswerId,
      'level': level,
      'timeLimit': timeLimit,
    };
  }
}

class QuizOption {
  final String id;
  final String text; // Văn bản câu trả lời
  final String imageUrl; // Hình ảnh lựa chọn (nếu có)
  final String? audioUrl; // Âm thanh phát âm

  QuizOption({
    required this.id,
    required this.text,
    required this.imageUrl,
    this.audioUrl,
  });

  factory QuizOption.fromJson(Map<String, dynamic> json) {
    return QuizOption(
      id: json['id'] as String,
      text: json['text'] as String,
      imageUrl: json['imageUrl'] as String,
      audioUrl: json['audioUrl'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {'id': id, 'text': text, 'imageUrl': imageUrl, 'audioUrl': audioUrl};
  }
}
