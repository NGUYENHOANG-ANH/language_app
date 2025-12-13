import 'package:flutter/material.dart';
import '../models/flashcard_model.dart';
import '../utils/app_colors.dart';
import '../utils/app_text_styles.dart';

class FlashcardWidget extends StatefulWidget {
  final Flashcard flashcard;
  final VoidCallback onAudioTap;

  const FlashcardWidget({
    Key? key,
    required this.flashcard,
    required this.onAudioTap,
  }) : super(key: key);

  @override
  State<FlashcardWidget> createState() => _FlashcardWidgetState();
}

class _FlashcardWidgetState extends State<FlashcardWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _flipController;
  bool _isFlipped = false;

  @override
  void initState() {
    super.initState();
    _flipController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );
  }

  @override
  void dispose() {
    _flipController.dispose();
    super.dispose();
  }

  void _toggleFlip() {
    if (_isFlipped) {
      _flipController.reverse();
    } else {
      _flipController.forward();
    }
    setState(() {
      _isFlipped = !_isFlipped;
    });
  }

  // ✅ THÊM METHOD _buildFrontSide
  Widget _buildFrontSide() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        // Hình ảnh
        Container(
          width: 200,
          height: 200,
          decoration: BoxDecoration(
            color: Colors.grey[200],
            borderRadius: BorderRadius.circular(15),
          ),
          child: Center(
            child: Icon(
              Icons.image,
              size: 80,
              color: Colors.grey[400],
            ),
          ),
        ),
        const SizedBox(height: 24),
        // Từ tiếng Anh
        Text(
          widget.flashcard.word,
          style: AppTextStyles.heading2.copyWith(
            color: AppColors.textPrimary,
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 12),
        // Phát âm
        Text(
          widget.flashcard.pronunciation,
          style: AppTextStyles.pronunciation,
        ),
      ],
    );
  }

  // ✅ THÊM METHOD _buildFlippedSide
  Widget _buildFlippedSide() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        // Tên tiếng Việt (nếu có)
        if (widget.flashcard.vietnameseName != null) ...[
          Text(
            'Tiếng Việt:  ',
            style: AppTextStyles.bodySmall.copyWith(
              color: AppColors.textSecondary,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            widget.flashcard.vietnameseName!,
            style: AppTextStyles.heading2.copyWith(
              color: AppColors.primaryPastel,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 24),
        ],
        // Mô tả (nếu có)
        if (widget.flashcard.description != null) ...[
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Text(
              widget.flashcard.description!,
              style: AppTextStyles.bodyMedium,
              textAlign: TextAlign.center,
            ),
          ),
          const SizedBox(height: 24),
        ],
        // Biểu tượng lật
        const Icon(
          Icons.flip,
          size: 40,
          color: AppColors.primaryPastel,
        ),
        const SizedBox(height: 12),
        Text(
          'Nhấn để lật lại',
          style: AppTextStyles.bodySmall.copyWith(
            color: AppColors.textSecondary,
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Flip animation card
          GestureDetector(
            onTap: _toggleFlip,
            child: AnimatedBuilder(
              animation: _flipController,
              builder: (context, child) {
                final angle = _flipController.value * 3.14159;
                final transform = Matrix4.identity()
                  ..setEntry(3, 2, 0.001)
                  ..rotateY(angle);

                return Transform(
                  alignment: Alignment.center,
                  transform: transform,
                  child: Container(
                    height: 320,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(25),
                      boxShadow: const [
                        BoxShadow(
                          color: AppColors.shadowColor,
                          blurRadius: 15,
                          offset: Offset(0, 8),
                        ),
                      ],
                    ),
                    child: Center(
                      child:
                          _isFlipped ? _buildFlippedSide() : _buildFrontSide(),
                    ),
                  ),
                );
              },
            ),
          ),
          const SizedBox(height: 32),

          // Flip hint text
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: AppColors.accentPastel.withOpacity(0.3),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.touch_app, size: 16, color: Colors.orange),
                const SizedBox(width: 8),
                Text(
                  _isFlipped ? 'Nhấn để xem hình' : 'Nhấn để lật thẻ',
                  style: AppTextStyles.bodySmall.copyWith(
                    color: Colors.orange[800],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 32),

          // Audio button
          ElevatedButton.icon(
            onPressed: widget.onAudioTap,
            icon: const Icon(Icons.volume_up, size: 24),
            label: const Text('Phát âm'),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primaryPastel,
              padding: const EdgeInsets.symmetric(
                horizontal: 32,
                vertical: 14,
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
            ),
          ),

          // Optional: Sound effect button
          // ✅ SỬA:  Đóng đúng dấu ngoặc
          if (widget.flashcard.soundUrl != null) ...[
            const SizedBox(height: 12),
            OutlinedButton.icon(
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Đang phát âm thanh đặc trưng... '),
                  ),
                );
              },
              icon: const Icon(Icons.music_note),
              label: const Text('Âm thanh đặc trưng'),
              style: OutlinedButton.styleFrom(
                foregroundColor: AppColors.primaryPastel,
                side: const BorderSide(
                  color: AppColors.primaryPastel,
                  width: 2,
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}
