import 'dart:math';

import 'package:flutter/material.dart';
import 'package:trackit/achievements/achievements.dart';
import 'package:trackit/components/achievement_dialog.dart';
import 'package:trackit/components/bottom_navbar.dart';
import 'package:trackit/data/habit_db.dart';
import 'package:trackit/datetime/date_time.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  HabitDB db = HabitDB();
  int completedHabits = 0;
  int bestStreak = 0;
  List<Achievement>? achievements;
  DateTime? startDate;

  @override
  void initState() {
    super.initState();
    _fetchStats();
    db.unlockAchievements();
  }

  void _fetchStats() {
    TwoInts stats = db.getCompletedHabitCountAndBestStreak();
    var numCompletedHabits = stats.firstInt;
    var numBestStreak = stats.secondInt;
    var startDateTime = db.getStartDate();
    var achievementsList = db.achievements;

    setState(() {
      completedHabits = numCompletedHabits;
      bestStreak = numBestStreak;
      startDate = startDateTime;
      achievements = achievementsList;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                margin: const EdgeInsets.only(top: 40.0, bottom: 20.0),
                alignment: Alignment.center,
                child: Text(
                  'Since ${startDate != null ? formatDateTime(startDate!) : 'Unknown'}',
                  style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
                ),
              ),

              Divider(color: Colors.green, thickness: 1, height: 30),

              Container(
                margin: const EdgeInsets.only(top: 20.0, bottom: 20.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  spacing: 30,
                  children: [
                    // completed habits stat
                    Column(
                      children: [
                        Text(
                          '$completedHabits',
                          style: TextStyle(
                            fontSize: 40,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text('Completions', style: TextStyle(fontSize: 18)),
                      ],
                    ),

                    SizedBox(height: 20),

                    // best streak stat
                    Column(
                      children: [
                        Text(
                          '$bestStreak',
                          style: TextStyle(
                            fontSize: 40,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text('Best Streak', style: TextStyle(fontSize: 18)),
                      ],
                    ),
                  ],
                ),
              ),
              Divider(color: Colors.green, thickness: 1, height: 30),

              Padding(
                padding: const EdgeInsets.only(
                  top: 20.0,
                  left: 10.0,
                  bottom: 10.0,
                ),
                child: Text(
                  'Achievements',
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
              ),

              achievements != null
                  ? Column(
                    children:
                        achievements!.map((achievement) {
                          return ListTile(
                            leading: GestureDetector(
                              onTap: () {
                                // open the AchievementDialog when image is tapped
                                showDialog(
                                  context: context,
                                  builder:
                                      (context) => AchievementDialog(
                                        achievement: achievement,
                                      ),
                                );
                              },
                              child: Opacity(
                                opacity: achievement.unlocked ? 1.0 : 0.2,
                                child: SizedBox(
                                  width: 60,
                                  height: 60,
                                  child: Image.asset(
                                    'assets/images/${achievement.badgeImage}',
                                    fit: BoxFit.fitHeight,
                                  ),
                                ),
                              ),
                            ),
                            title: Text(
                              achievement.name,
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 20,
                              ),
                            ),
                            subtitle: Padding(
                              padding: const EdgeInsets.only(
                                top: 8.0,
                                right: 8.0,
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  LinearProgressIndicator(
                                    value:
                                        achievement.done / achievement.needed,
                                    minHeight: 8,
                                    backgroundColor: Colors.green[200],
                                    valueColor:
                                        const AlwaysStoppedAnimation<Color>(
                                          Colors.green,
                                        ),
                                  ),
                                  const SizedBox(height: 6),
                                  Text(
                                    "${min(achievement.done, achievement.needed)} of ${achievement.needed}",
                                    textAlign: TextAlign.left,
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        }).toList(),
                  )
                  : Center(child: Text('No achievements available')),
            ],
          ),
        ),
      ),
      bottomNavigationBar: BottomNavbar(),
    );
  }
}
