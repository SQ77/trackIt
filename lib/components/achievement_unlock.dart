import 'package:flutter/material.dart';
import 'package:trackit/achievements/achievements.dart';
import 'package:trackit/components/confetti.dart';

class AchievementUnlock extends StatefulWidget {
  final Achievement achievement;

  const AchievementUnlock({super.key, required this.achievement});

  @override
  State<AchievementUnlock> createState() => _AchievementUnlockState();
}

class _AchievementUnlockState extends State<AchievementUnlock> {
  bool showConfetti = true;

  void _triggerConfetti() {
    setState(() {
      showConfetti = true;
    });

    // hide confetti after some time
    Future.delayed(const Duration(seconds: 2), () {
      if (mounted) {
        setState(() {
          showConfetti = false;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        AlertDialog(
          title: const Text("Achievement Unlocked!"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              GestureDetector(
                onTap: _triggerConfetti,
                child: Image.asset(
                  'assets/images/${widget.achievement.badgeImage}',
                  width: 200,
                  height: 200,
                  fit: BoxFit.cover,
                ),
              ),
              const SizedBox(height: 10),
              Text(widget.achievement.name, style: TextStyle(fontSize: 18)),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text("Close"),
            ),
          ],
        ),
        if (showConfetti) const ConfettiEffect(),
      ],
    );
  }
}
