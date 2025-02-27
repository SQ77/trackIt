class Achievement {
  final String name;
  final String description;
  final String badgeImage;
  bool unlocked;

  Achievement({
    required this.name,
    required this.description,
    required this.badgeImage,
    this.unlocked = false,
  });
}
