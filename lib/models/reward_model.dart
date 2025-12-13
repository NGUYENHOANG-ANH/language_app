class Reward {
  final String id;
  final String name;
  final String description;
  final String animationUrl; // Lottie JSON hoặc Rive file
  final int starsRequired; // Số sao cần để mở khóa
  final String rewardType; // 'animation', 'sticker', 'badge', 'character'
  final bool isUnlocked;

  Reward({
    required this.id,
    required this.name,
    required this.description,
    required this.animationUrl,
    required this.starsRequired,
    required this.rewardType,
    this.isUnlocked = false,
  });

  factory Reward.fromJson(Map<String, dynamic> json) {
    return Reward(
      id: json['id'] as String,
      name: json['name'] as String,
      description: json['description'] as String,
      animationUrl: json['animationUrl'] as String,
      starsRequired: json['starsRequired'] as int,
      rewardType: json['rewardType'] as String,
      isUnlocked: json['isUnlocked'] as bool? ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'animationUrl': animationUrl,
      'starsRequired': starsRequired,
      'rewardType': rewardType,
      'isUnlocked': isUnlocked,
    };
  }
}
