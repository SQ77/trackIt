import 'package:flutter/material.dart';
import 'package:trackit/achievements/achievements.dart';
import 'package:trackit/components/confetti.dart';

class AchievementDialog extends StatelessWidget {
  final Achievement achievement;

  const AchievementDialog({super.key, required this.achievement});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // different opacity for different parts of achievement badge
          // visually shows user's progress to unlocking achievement
          ShaderMask(
            shaderCallback: (rect) {
              return LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: <Color>[
                  Color.fromRGBO(0, 0, 0, 0.1),
                  Color.fromRGBO(0, 0, 0, 0.1),
                  Color.fromRGBO(0, 0, 0, 1.0),
                  Color.fromRGBO(0, 0, 0, 1.0),
                ],
                stops: [
                  0.0,
                  1 - achievement.done / achievement.needed,
                  1 - achievement.done / achievement.needed,
                  1.0,
                ],
              ).createShader(Rect.fromLTRB(0, 0, rect.width, rect.height));
            },
            blendMode: BlendMode.dstIn,
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
          Text(achievement.description, style: TextStyle(fontSize: 18)),
          if (achievement.unlocked) const ConfettiEffect(),
        ],
      ),
    );
  }
}
