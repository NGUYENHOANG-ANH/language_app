import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'flashcard_screen.dart';
import 'quiz_screen.dart';
import '../utils/app_colors.dart';
import '../utils/app_text_styles.dart';
import '../models/topic_model.dart';

class TopicSelectionScreen extends ConsumerWidget {
  final String mode; // 'flashcard' or 'quiz'

  const TopicSelectionScreen({Key? key, required this.mode}) : super(key: key);

  // Mock topics list
  static final List<Topic> _mockTopics = [
    Topic(
      id: 'animals',
      name: '🦁 Động Vật',
      description: 'Học tên các động vật',
      iconUrl: 'assets/images/topics/animals_icon.png',
      color: '#FF6B6B',
      totalFlashcards: 12,
      totalQuizzes: 10,
      isLocked: false,
    ),
    Topic(
      id: 'fruits',
      name: '🍎 Trái Cây',
      description: 'Học tên các trái cây',
      iconUrl: 'assets/images/topics/fruits_icon.png',
      color: '#FFD93D',
      totalFlashcards: 10,
      totalQuizzes: 8,
      isLocked: false,
    ),
    Topic(
      id: 'colors',
      name: '🎨 Màu Sắc',
      description: 'Nhận diện các màu sắc',
      iconUrl: 'assets/images/topics/colors_icon.png',
      color: '#6BCB77',
      totalFlashcards: 8,
      totalQuizzes: 6,
      isLocked: false,
    ),
    Topic(
      id: 'shapes',
      name: '⭕ Hình Dạng',
      description: 'Học các hình dạng cơ bản',
      iconUrl: 'assets/images/topics/shapes_icon.png',
      color: '#4D96FF',
      totalFlashcards: 7,
      totalQuizzes: 5,
      isLocked: true,
      requiredStars: 10,
    ),
    Topic(
      id: 'vehicles',
      name: '🚗 Phương Tiện',
      description: 'Nhận diện phương tiện',
      iconUrl: 'assets/images/topics/vehicles_icon.png',
      color: '#FF6B9D',
      totalFlashcards: 9,
      totalQuizzes: 7,
      isLocked: true,
      requiredStars: 20,
    ),
    Topic(
      id: 'alphabet',
      name: '🔤 Bảng Chữ Cái',
      description: 'Học Alphabet A-Z',
      iconUrl: 'assets/images/topics/alphabet_icon.png',
      color: '#F38181',
      totalFlashcards: 26,
      totalQuizzes: 20,
      isLocked: false,
    ),
  ];

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final title =
        mode == 'flashcard' ? '📚 Chọn Chủ Đề Học' : '🎮 Chọn Chủ Đề Quiz';

    return Scaffold(
      appBar: AppBar(
        title: Text(title),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      backgroundColor: AppColors.backgroundColor,
      body: GridView.builder(
        padding: const EdgeInsets.all(16),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          childAspectRatio: 0.85,
          crossAxisSpacing: 12,
          mainAxisSpacing: 12,
        ),
        itemCount: _mockTopics.length,
        itemBuilder: (context, index) {
          final topic = _mockTopics[index];
          return _buildTopicCard(context, topic);
        },
      ),
    );
  }

  Widget _buildTopicCard(BuildContext context, Topic topic) {
    final color = Color(int.parse(topic.color.replaceFirst('#', '0xff')));

    return GestureDetector(
      onTap: topic.isLocked
          ? () {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Mở khóa sau khi đạt ${topic.requiredStars} ⭐'),
                ),
              );
            }
          : () {
              if (mode == 'flashcard') {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => FlashcardScreen(topic: topic),
                  ),
                );
              } else {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => QuizScreen(topic: topic),
                  ),
                );
              }
            },
      child: Container(
        decoration: BoxDecoration(
          color: topic.isLocked ? Colors.grey[300] : color,
          borderRadius: BorderRadius.circular(20),
          boxShadow: const [
            BoxShadow(
              color: AppColors.shadowColor,
              blurRadius: 8,
              offset: Offset(0, 4),
            ),
          ],
        ),
        child: Stack(
          children: [
            // Main content
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Opacity(
                  opacity: topic.isLocked ? 0.5 : 1.0,
                  child: Text(
                    topic.name.split(' ')[0], // Just emoji
                    style: const TextStyle(fontSize: 48),
                  ),
                ),
                const SizedBox(height: 12),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  child: Text(
                    topic.name.split(' ').sublist(1).join(' '),
                    textAlign: TextAlign.center,
                    style: AppTextStyles.heading3.copyWith(
                      color: Colors.white,
                      fontSize: 16,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                const SizedBox(height: 8),
                Opacity(
                  opacity: topic.isLocked ? 0.5 : 0.8,
                  child: Text(
                    '${topic.totalFlashcards} thẻ',
                    style: AppTextStyles.bodySmall.copyWith(
                      color: Colors.white70,
                      fontSize: 12,
                    ),
                  ),
                ),
              ],
            ),

            // Lock icon overlay
            if (topic.isLocked)
              Positioned(
                top: 8,
                right: 8,
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  padding: const EdgeInsets.all(6),
                  child: const Icon(Icons.lock, color: Colors.grey, size: 20),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
