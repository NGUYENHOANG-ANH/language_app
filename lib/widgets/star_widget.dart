import 'package:flutter/material.dart';
import '../utils/app_colors.dart';

class StarWidget extends StatelessWidget {
  final int stars;
  final int maxStars;
  final double size;

  const StarWidget({
    Key? key,
    required this.stars,
    this.maxStars = 5,
    this.size = 24,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(
        maxStars,
        (index) => Padding(
          padding: const EdgeInsets.symmetric(horizontal: 2),
          child: Icon(
            index < stars ? Icons.star : Icons.star_outline,
            color: AppColors.starColor,
            size: size,
          ),
        ),
      ),
    );
  }
}
