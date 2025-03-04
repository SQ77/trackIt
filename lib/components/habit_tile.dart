import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

class HabitTile extends StatelessWidget {
  final String name;
  final bool isCompleted;
  final int streak;
  final Function(bool?)? onChanged;
  final Function(BuildContext)? settingsTapped;
  final Function(BuildContext)? deleteTapped;

  const HabitTile({
    super.key,
    required this.name,
    required this.isCompleted,
    required this.streak,
    required this.onChanged,
    required this.settingsTapped,
    required this.deleteTapped,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 18.0, vertical: 12.0),
      child: Slidable(
        endActionPane: ActionPane(
          motion: const StretchMotion(),
          children: [
            // edit option
            SlidableAction(
              onPressed: settingsTapped,
              backgroundColor: Colors.blue.shade800,
              icon: Icons.edit,
              borderRadius: BorderRadius.circular(12),
            ),
            // delete option
            SlidableAction(
              onPressed: deleteTapped,
              backgroundColor: Colors.red.shade400,
              icon: Icons.delete,
              borderRadius: BorderRadius.circular(12),
            ),
          ],
        ),
        child: ConstrainedBox(
          constraints: BoxConstraints(
            maxWidth:
                kIsWeb
                    ? MediaQuery.of(context).size.width * 0.9
                    : double.infinity,
          ),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color:
                  isCompleted
                      ? Theme.of(context).colorScheme.primary
                      : Theme.of(context).colorScheme.secondary,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // checkbox and habit name
                Flexible(
                  child: Row(
                    children: [
                      Transform.scale(
                        scale: 1.3,
                        child: Checkbox(
                          value: isCompleted,
                          onChanged: onChanged,
                          checkColor: Colors.white,
                          side: BorderSide(
                            color:
                                Theme.of(context).brightness == Brightness.dark
                                    ? Colors.white
                                    : Colors.black,
                            width: 2,
                          ),
                          fillColor: WidgetStateProperty.resolveWith<Color>((
                            Set<WidgetState> states,
                          ) {
                            if (states.contains(WidgetState.selected)) {
                              return Colors.green;
                            }
                            return Theme.of(context).colorScheme.secondary;
                          }),
                        ),
                      ),
                      if (kIsWeb) SizedBox(width: 6),
                      Flexible(
                        child: Text(
                          name,
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w500,
                            decoration:
                                isCompleted ? TextDecoration.lineThrough : null,
                          ),
                          softWrap: true,
                        ),
                      ),
                    ],
                  ),
                ),

                // streak counter
                if (streak > 0)
                  Row(
                    children: [
                      const SizedBox(width: 4),
                      const Icon(
                        Icons.local_fire_department,
                        color: Colors.orange,
                        size: 30,
                      ),
                      Text(
                        streak.toString(),
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.orange,
                        ),
                      ),
                    ],
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
