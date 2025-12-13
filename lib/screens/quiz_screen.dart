import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/topic_model.dart';
import '../models/quiz_model.dart';
import '../utils/app_colors.dart';
import '../utils/app_text_styles.dart';
import '../widgets/celebration_animation.dart';
import '../widgets/encouragement_message.dart';
import '../services/data_service.dart';

class QuizScreen extends ConsumerStatefulWidget {
  final Topic topic;

  const QuizScreen({
    Key? key,
    required this.topic,
  }) : super(key: key);

  @override
  ConsumerState<QuizScreen> createState() => _QuizScreenState();
}

class _QuizScreenState extends ConsumerState<QuizScreen> {
  int _currentQuestionIndex = 0;
  int _starsEarned = 0;
  bool _answered = false;
  String? _selectedAnswerId;
  bool _isCorrect = false;

  // Mock quizzes for animals
  final List<Quiz> _mockQuizzes = [
    Quiz(
      id: 'quiz_001',
      topicId: 'animals',
      question: 'Con vật này là gì?',
      questionType: 'image',
      imageUrl: 'assets/images/quizzes/animals/lion_quiz.png',
      options: [
        QuizOption(
          id: 'opt_001_1',
          text: 'Lion',
          imageUrl: 'assets/images/options/animals/lion_small.png',
        ),
        QuizOption(
          id: 'opt_001_2',
          text: 'Tiger',
          imageUrl: 'assets/images/options/animals/tiger_small.png',
        ),
      ],
      correctAnswerId: 'opt_001_1',
      level: 1,
    ),
    Quiz(
      id: 'quiz_002',
      topicId: 'animals',
      question: 'Đây là con vật nào?',
      questionType: 'image',
      imageUrl: 'assets/images/quizzes/animals/elephant_quiz.png',
      options: [
        QuizOption(
          id: 'opt_002_1',
          text: 'Lion',
          imageUrl: 'assets/images/options/animals/lion_small.png',
        ),
        QuizOption(
          id: 'opt_002_2',
          text: 'Elephant',
          imageUrl: 'assets/images/options/animals/elephant_small.png',
        ),
        QuizOption(
          id: 'opt_002_3',
          text: 'Monkey',
          imageUrl: 'assets/images/options/animals/monkey_small.png',
        ),
      ],
      correctAnswerId: 'opt_002_2',
      level: 2,
    ),
  ];

  void _handleAnswer(String optionId) {
    if (_answered) return;

    final quiz = _mockQuizzes[_currentQuestionIndex];
    final isCorrect = optionId == quiz.correctAnswerId;

    setState(() {
      _answered = true;
      _selectedAnswerId = optionId;
      _isCorrect = isCorrect;
      if (isCorrect) {
        _starsEarned++;
      }
    });

    // Show celebration or encouragement
    Future.delayed(const Duration(milliseconds: 500), () {
      if (mounted) {
        if (isCorrect) {
          _showCelebration();
        } else {
          _showEncouragement();
        }
      }
    });
  }

  void _showCelebration() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => Dialog(
        backgroundColor: Colors.transparent,
        child: CelebrationAnimation(
          message: '🎉 Tuyệt vời! ',
          subtitle: 'Con trả lời đúng!  ',
          stars: 1,
          onDismiss: () {
            Navigator.pop(context);
            _nextQuestion();
          },
        ),
      ),
    );
  }

  void _showEncouragement() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => Dialog(
        backgroundColor: Colors.transparent,
        child: EncouragementMessage(
          message: '💪 Cố lên! ',
          subtitle: 'Thử lại nhé, con sẽ làm tốt mà! ',
          onDismiss: () {
            Navigator.pop(context);
            _nextQuestion();
          },
        ),
      ),
    );
  }

  void _nextQuestion() {
    if (_currentQuestionIndex < _mockQuizzes.length - 1) {
      setState(() {
        _currentQuestionIndex++;
        _answered = false;
        _selectedAnswerId = null;
      });
    } else {
      // Quiz completed
      _showQuizCompleted();
    }
  }

  void _showQuizCompleted() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        child: Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: AppColors.backgroundColor,
            borderRadius: BorderRadius.circular(20),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                '🏆 Hoàn thành!  ',
                style: AppTextStyles.heading2,
              ),
              const SizedBox(height: 20),
              const Text(
                'Con đạt được',
                style: AppTextStyles.bodyMedium,
              ),
              const SizedBox(height: 16),
              // Stars display
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(
                  _starsEarned,
                  (index) => Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 4),
                    child: _buildStar(true),
                  ),
                ),
              ),
              const SizedBox(height: 12),
              Text(
                '$_starsEarned / ${_mockQuizzes.length} ⭐',
                style: AppTextStyles.heading3.copyWith(
                  color: AppColors.starColor,
                ),
              ),
              const SizedBox(height: 24),
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.pop(context);
                        Navigator.pop(context);
                      },
                      // ✅ SỬA:  Thêm shape
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primaryPastel,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: const Text('Về nhà'),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.pop(context);
                        setState(() {
                          _currentQuestionIndex = 0;
                          _starsEarned = 0;
                          _answered = false;
                          _selectedAnswerId = null;
                        });
                      },
                      // ✅ SỬA: Thêm shape
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.secondaryPastel,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: const Text('Làm lại'),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final quiz = _mockQuizzes[_currentQuestionIndex];
    final topicColor =
        Color(int.parse(widget.topic.color.replaceFirst('#', '0xff')));

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.topic.name),
        backgroundColor: topicColor,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      backgroundColor: AppColors.backgroundColor,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Progress
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Câu ${_currentQuestionIndex + 1} / ${_mockQuizzes.length}',
                    style: AppTextStyles.heading3,
                  ),
                  Row(
                    children: [
                      const Text('⭐ ', style: TextStyle(fontSize: 20)),
                      Text(
                        '$_starsEarned',
                        style: AppTextStyles.heading3,
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 20),

              // Progress bar
              Container(
                height: 8,
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(4),
                ),
                child: FractionallySizedBox(
                  widthFactor:
                      (_currentQuestionIndex + 1) / _mockQuizzes.length,
                  child: Container(
                    decoration: BoxDecoration(
                      color: topicColor,
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 32),

              // Question
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(15),
                  boxShadow: const [
                    BoxShadow(
                      color: AppColors.shadowColor,
                      blurRadius: 8,
                      offset: Offset(0, 2),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    Text(
                      quiz.question,
                      style: AppTextStyles.heading3,
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 16),
                    // Question image
                    if (quiz.questionType == 'image' && quiz.imageUrl != null)
                      Container(
                        width: 200,
                        height: 200,
                        decoration: BoxDecoration(
                          color: Colors.grey[200],
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: const Placeholder(
                          child: Center(
                            child: Text(
                              'Hình ảnh câu hỏi',
                              style: AppTextStyles.bodyMedium,
                            ),
                          ),
                        ),
                      ),
                  ],
                ),
              ),
              const SizedBox(height: 32),

              // Options
              ...quiz.options.asMap().entries.map((entry) {
                final index = entry.key;
                final option = entry.value;
                final isSelected = _selectedAnswerId == option.id;
                final isCorrectOption = option.id == quiz.correctAnswerId;

                Color buttonColor = AppColors.cardBackground;
                Color borderColor = Colors.grey[300]!;
                Color textColor = AppColors.textPrimary;

                if (_answered) {
                  if (isSelected && _isCorrect) {
                    buttonColor = AppColors.correctGreen;
                    textColor = Colors.white;
                  } else if (isSelected && !_isCorrect) {
                    buttonColor = AppColors.wrongRed;
                    textColor = Colors.white;
                  } else if (isCorrectOption && !_isCorrect) {
                    buttonColor = AppColors.correctGreen;
                    textColor = Colors.white;
                  }
                } else if (isSelected) {
                  borderColor = topicColor;
                  buttonColor = topicColor.withOpacity(0.1);
                  textColor = topicColor;
                }

                return Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: GestureDetector(
                    onTap: _answered ? null : () => _handleAnswer(option.id),
                    child: Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: buttonColor,
                        border: Border.all(color: borderColor, width: 2),
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: Row(
                        children: [
                          // Option letter/number
                          Container(
                            width: 40,
                            height: 40,
                            decoration: BoxDecoration(
                              color: textColor.withOpacity(0.1),
                              shape: BoxShape.circle,
                            ),
                            child: Center(
                              child: Text(
                                String.fromCharCode(65 + index), // A, B, C, D
                                style: AppTextStyles.heading3.copyWith(
                                  color: textColor,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 16),
                          // Option text & image
                          Expanded(
                            child: Row(
                              children: [
                                if (option.imageUrl.isNotEmpty)
                                  Container(
                                    width: 50,
                                    height: 50,
                                    decoration: BoxDecoration(
                                      color: Colors.grey[200],
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    child: Placeholder(
                                      child: Center(
                                        child: Text(
                                          '${index + 1}',
                                          style: AppTextStyles.bodySmall,
                                        ),
                                      ),
                                    ),
                                  ),
                                if (option.imageUrl.isNotEmpty)
                                  const SizedBox(width: 12),
                                Expanded(
                                  child: Text(
                                    option.text,
                                    style: AppTextStyles.bodyLarge.copyWith(
                                      color: textColor,
                                      fontWeight: _answered
                                          ? FontWeight.bold
                                          : FontWeight.w500,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          // Checkmark/X icon
                          if (_answered)
                            Icon(
                              isCorrectOption
                                  ? Icons.check_circle
                                  : Icons.cancel,
                              color: Colors.white,
                              size: 24,
                            ),
                        ],
                      ),
                    ),
                  ),
                );
              }).toList(),

              const SizedBox(height: 24),

              // Next button
              if (_answered)
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: _nextQuestion,
                    // ✅ SỬA: Thêm shape
                    style: ElevatedButton.styleFrom(
                      backgroundColor: topicColor,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: Text(
                      _currentQuestionIndex < _mockQuizzes.length - 1
                          ? 'Câu tiếp theo'
                          : 'Hoàn thành',
                      style: AppTextStyles.buttonLarge,
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStar(bool filled) {
    return Icon(
      filled ? Icons.star : Icons.star_outline,
      color: AppColors.starColor,
      size: 32,
    );
  }
}
