class Achievement {
  final String name;
  final String description;
  final String badgeImage;
  final int needed; // goal to unlock the achievement
  int done; // progress done so far
  bool unlocked;

  Achievement({
    required this.name,
    required this.description,
    required this.badgeImage,
    required this.needed,
    this.done = 0,
    this.unlocked = false,
  });
}
