import 'package:flutter/material.dart';
import 'package:trackit/achievements/achievements.dart';

class AchievementDialog extends StatelessWidget {
  final Achievement achievement;

  const AchievementDialog({super.key, required this.achievement});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Opacity(
            opacity: achievement.unlocked ? 1.0 : 0.1,
            child: Image.asset(
              'assets/images/${achievement.badgeImage}',
              width: 200,
              height: 200,
              fit: BoxFit.cover,
            ),
          ),
          SizedBox(height: 10),
          Text(
            achievement.name,
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
          ),
          SizedBox(height: 5),
          Text(achievement.description),
        ],
      ),
    );
  }
}
