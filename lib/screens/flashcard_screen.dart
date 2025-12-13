import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/topic_model.dart';
import '../models/flashcard_model.dart';
import '../utils/app_colors.dart';
import '../utils/app_text_styles.dart';
import '../widgets/flashcard_widget.dart';

class FlashcardScreen extends ConsumerStatefulWidget {
  final Topic topic;

  const FlashcardScreen({Key? key, required this.topic}) : super(key: key);

  @override
  ConsumerState<FlashcardScreen> createState() => _FlashcardScreenState();
}

class _FlashcardScreenState extends ConsumerState<FlashcardScreen> {
  late PageController _pageController;
  int _currentIndex = 0;

  // Mock flashcards for animals
  final List<Flashcard> _mockFlashcards = [
    Flashcard(
      id: 'fc_001',
      word: 'Lion',
      pronunciation: '/ˈlaɪən/',
      imageUrl: 'assets/images/flashcards/animals/lion.png',
      audioUrl: 'assets/sounds/flashcards/animals/lion_word.mp3',
      soundUrl: 'assets/sounds/flashcards/animals/lion_sound.mp3',
      topicId: 'animals',
      vietnameseName: 'Sư tử',
      description: 'A large wild cat with a mane',
      difficulty: 1,
    ),
    Flashcard(
      id: 'fc_002',
      word: 'Elephant',
      pronunciation: '/ˈɛlɪfənt/',
      imageUrl: 'assets/images/flashcards/animals/elephant.png',
      audioUrl: 'assets/sounds/flashcards/animals/elephant_word.mp3',
      soundUrl: 'assets/sounds/flashcards/animals/elephant_sound.mp3',
      topicId: 'animals',
      vietnameseName: 'Voi',
      description: 'A large animal with a long trunk',
      difficulty: 1,
    ),
    Flashcard(
      id: 'fc_003',
      word: 'Dog',
      pronunciation: '/dɔːɡ/',
      imageUrl: 'assets/images/flashcards/animals/dog.png',
      audioUrl: 'assets/sounds/flashcards/animals/dog_word.mp3',
      soundUrl: 'assets/sounds/flashcards/animals/dog_sound.mp3',
      topicId: 'animals',
      vietnameseName: 'Chó',
      description: 'A friendly pet animal',
      difficulty: 1,
    ),
    Flashcard(
      id: 'fc_004',
      word: 'Cat',
      pronunciation: '/kæt/',
      imageUrl: 'assets/images/flashcards/animals/cat.png',
      audioUrl: 'assets/sounds/flashcards/animals/cat_word.mp3',
      soundUrl: 'assets/sounds/flashcards/animals/cat_sound.mp3',
      topicId: 'animals',
      vietnameseName: 'Mèo',
      description: 'A small furry pet',
      difficulty: 1,
    ),
  ];

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final topicColor = Color(
      int.parse(widget.topic.color.replaceFirst('#', '0xff')),
    );

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
        child: Column(
          children: [
            // Progress indicator
            Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Thẻ ${_currentIndex + 1} / ${_mockFlashcards.length}',
                    style: AppTextStyles.heading3,
                  ),
                  _buildProgressBar(),
                ],
              ),
            ),

            // Flashcard PageView
            Expanded(
              child: PageView.builder(
                controller: _pageController,
                onPageChanged: (index) {
                  setState(() {
                    _currentIndex = index;
                  });
                },
                itemCount: _mockFlashcards.length,
                itemBuilder: (context, index) {
                  return FlashcardWidget(
                    flashcard: _mockFlashcards[index],
                    onAudioTap: () {
                      // TODO:  Play audio
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(
                            'Phát âm:  ${_mockFlashcards[index].word}',
                          ),
                        ),
                      );
                    },
                  );
                },
              ),
            ),

            // Navigation buttons
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Previous button
                  // ✅ SỬA:  Thay backgroundColor bằng backgroundColor trong styleFrom
                  ElevatedButton.icon(
                    onPressed: _currentIndex > 0
                        ? () {
                            _pageController.previousPage(
                              duration: const Duration(milliseconds: 300),
                              curve: Curves.easeInOut,
                            );
                          }
                        : null,
                    icon: const Icon(Icons.arrow_back),
                    label: const Text('Quay lại'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: topicColor,
                      disabledBackgroundColor: Colors.grey[300],
                      padding: const EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 12,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),

                  const SizedBox(width: 16),

                  // Next button
                  // ✅ SỬA: Thay backgroundColor bằng backgroundColor trong styleFrom
                  ElevatedButton.icon(
                    onPressed: _currentIndex < _mockFlashcards.length - 1
                        ? () {
                            _pageController.nextPage(
                              duration: const Duration(milliseconds: 300),
                              curve: Curves.easeInOut,
                            );
                          }
                        : null,
                    icon: const Icon(Icons.arrow_forward),
                    label: const Text('Tiếp'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: topicColor,
                      disabledBackgroundColor: Colors.grey[300],
                      padding: const EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 12,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProgressBar() {
    final progress = (_currentIndex + 1) / _mockFlashcards.length;
    return Expanded(
      child: Container(
        height: 8,
        margin: const EdgeInsets.only(left: 16),
        decoration: BoxDecoration(
          color: Colors.grey[300],
          borderRadius: BorderRadius.circular(4),
        ),
        child: FractionallySizedBox(
          widthFactor: progress,
          child: Container(
            decoration: BoxDecoration(
              color: AppColors.starColor,
              borderRadius: BorderRadius.circular(4),
            ),
          ),
        ),
      ),
    );
  }
}
