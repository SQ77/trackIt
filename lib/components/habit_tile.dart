import 'package:flutter/material.dart';

class HabitTile extends StatelessWidget {
  final String name;
  final bool isCompleted;
  final Function(bool?)? onChanged;

  const HabitTile({
    super.key,
    required this.name,
    required this.isCompleted,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Container(
        padding: EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: Colors.grey[100],
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          children: [
            Checkbox(value: isCompleted, onChanged: onChanged),
            Text(name),
          ],
        ),
      ),
    );
  }
}
