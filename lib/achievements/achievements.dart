class Achievement {
  final String name;
  final String description;
  bool unlocked;

  Achievement({
    required this.name,
    required this.description,
    this.unlocked = false,
  });
}
