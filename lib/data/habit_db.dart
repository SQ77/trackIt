import 'dart:math';

import 'package:hive_flutter/hive_flutter.dart';
import 'package:trackit/datetime/date_time.dart';
import 'package:trackit/achievements/achievements.dart';

final _myBox = Hive.box("Habit_DB");

class TwoInts {
  final int firstInt;
  final int secondInt;

  TwoInts(this.firstInt, this.secondInt);
}

class HabitDB {
  List todaysHabitList = [];
  Map<DateTime, int> heatMapDataSet = {};
  List<Achievement> achievements = [
    Achievement(
      name: "First Habit",
      description: "Complete your first habit",
      badgeImage: "habit-1.png",
      needed: 1,
    ),
    Achievement(
      name: "Streak Novice",
      description: "Reach a streak of 3 days",
      badgeImage: "streak-3.png",
      needed: 3,
    ),
    Achievement(
      name: "Streak Master",
      description: "Reach a streak of 7 days",
      badgeImage: "streak-7.png",
      needed: 7,
    ),
    Achievement(
      name: "Completionist",
      description: "Complete 100 habits",
      badgeImage: "habit-100.png",
      needed: 100,
    ),
  ];

  // create default data initially
  void createDefaultData() {
    // [habit_name, complete, streak]
    todaysHabitList = [
      ["Run 5km", false, 0],
      ["Read for 10 minutes", false, 0],
      ["Clear email inbox", false, 0],
    ];

    _myBox.put("START_DATE", todaysDateFormatted());
  }

  // load existing data
  void loadData() {
    String todaysDate = todaysDateFormatted();
    String yesterdaysDate = convertDateTimeToString(
      DateTime.now().subtract(const Duration(days: 1)),
    );
    List? yesterdaysHabitList = _myBox.get(yesterdaysDate);

    // load achievement state from Hive
    List? achievementState = _myBox.get("ACHIEVEMENT_STATE");
    if (achievementState != null) {
      for (int i = 0; i < achievements.length; i++) {
        achievements[i].unlocked = achievementState[i];
      }
    }

    // start of a new day
    if (_myBox.get(todaysDate) == null) {
      todaysHabitList = _myBox.get("CURRENT_HABIT_LIST") ?? [];

      for (int i = 0; i < todaysHabitList.length; i++) {
        // reset all habits to not done
        todaysHabitList[i][1] = false;

        bool wasCompletedYesterday =
            yesterdaysHabitList != null && yesterdaysHabitList[i][1] == true;
        // reset streak if broken
        if (!wasCompletedYesterday) {
          todaysHabitList[i][2] = 0;
        }
      }
    } else {
      todaysHabitList = _myBox.get(todaysDate);
    }
  }

  // update db
  void updateDB() {
    _myBox.put(todaysDateFormatted(), todaysHabitList);
    _myBox.put("CURRENT_HABIT_LIST", todaysHabitList);

    calculateHabitPercentages();
    loadHeatMap();
  }

  void calculateHabitPercentages() {
    int completedCount = 0;
    for (int i = 0; i < todaysHabitList.length; i++) {
      if (todaysHabitList[i][1] == true) {
        completedCount++;
      }
    }

    String percent =
        todaysHabitList.isEmpty
            ? "0.0"
            : (completedCount / todaysHabitList.length).toStringAsFixed(1);

    _myBox.put("PERCENTAGE_SUMMARY_${todaysDateFormatted()}", percent);
  }

  void loadHeatMap() {
    DateTime startDate = getStartDate();
    int daysBetween = DateTime.now().difference(startDate).inDays;
    // go from start date to today and add each percentage to the dataset
    // "PERCENTAGE_SUMMARY_yyyymmdd" will be the key in the database
    for (int i = 0; i < daysBetween + 1; i++) {
      String yyyymmdd = convertDateTimeToString(
        startDate.add(Duration(days: i)),
      );

      double strengthAsPercent = double.parse(
        _myBox.get("PERCENTAGE_SUMMARY_$yyyymmdd") ?? "0.0",
      );

      // year
      int year = startDate.add(Duration(days: i)).year;

      // month
      int month = startDate.add(Duration(days: i)).month;

      // day
      int day = startDate.add(Duration(days: i)).day;

      final percentForEachDay = <DateTime, int>{
        DateTime(year, month, day): (10 * strengthAsPercent).toInt(),
      };

      heatMapDataSet.addEntries(percentForEachDay.entries);
    }
  }

  // returns the total number of completed habits and best streak
  TwoInts getCompletedHabitCountAndBestStreak() {
    int completedCount = 0;
    int bestStreak = 0;
    DateTime startDate = getStartDate();
    String startDateString = convertDateTimeToString(startDate);

    // track the streak for each habit individually
    Map<String, int> habitStreaks = {};

    for (var key in _myBox.keys) {
      bool isValidDateKey =
          key is String && key.length == 8 && RegExp(r'^\d{8}$').hasMatch(key);

      if (isValidDateKey && key.compareTo(startDateString) >= 0) {
        // get the list of habits for the given date
        List<dynamic> habitList = _myBox.get(key);

        for (var habit in habitList) {
          if (habit[1] == true) {
            completedCount++;

            // update streaks for each habit
            String habitName = habit[0];
            if (habitStreaks.containsKey(habitName)) {
              habitStreaks[habitName] = habitStreaks[habitName]! + 1;
            } else {
              habitStreaks[habitName] = 1;
            }

            bestStreak = max(bestStreak, habitStreaks[habitName]!);
          }
        }
      }
    }

    return TwoInts(completedCount, bestStreak);
  }

  DateTime getStartDate() {
    return createDateTimeObject(_myBox.get("START_DATE"));
  }

  Achievement? unlockAchievements() {
    var stats = getCompletedHabitCountAndBestStreak();
    var completedHabits = stats.firstInt;
    var bestStreak = stats.secondInt;

    achievements[0].done = completedHabits;
    achievements[1].done = bestStreak;
    achievements[2].done = bestStreak;
    achievements[3].done = completedHabits;

    // unlock "First Habit" after completing 1 habit
    if (completedHabits > 0 && !achievements[0].unlocked) {
      achievements[0].unlocked = true;
      _saveAchievementState();
      return achievements[0];
    }

    // unlock "Streak Novice" after a 3-day streak
    if (bestStreak >= 3 && !achievements[1].unlocked) {
      achievements[1].unlocked = true;
      _saveAchievementState();
      return achievements[1];
    }

    // unlock "Streak Master" after a 7-day streak
    if (bestStreak >= 7 && !achievements[2].unlocked) {
      achievements[2].unlocked = true;
      _saveAchievementState();
      return achievements[2];
    }

    // unlock "Completionist" after completing 100 habits
    if (completedHabits >= 100 && !achievements[3].unlocked) {
      achievements[3].unlocked = true;
      _saveAchievementState();
      return achievements[3];
    }
    return null;
  }

  // save the achievement state to Hive
  void _saveAchievementState() {
    var achievementData =
        achievements.map((achievement) => achievement.unlocked).toList();
    _myBox.put("ACHIEVEMENT_STATE", achievementData);
  }

  // resets all data, used for testing
  void clearBoxData() async {
    var box = await Hive.openBox("Habit_DB");
    await box.clear();
  }

  void populateSampleData() {
    // Populate today's habits
    todaysHabitList = [
      ["Run 5km", false, 5], 
      ["Read for 10 minutes", true, 10], 
      ["Clear email inbox", false, 0], 
      ["Drink 2L of water", true, 7], 
    ];

    // Add sample heatmap data
    DateTime startDate = DateTime.now().subtract(Duration(days: 25));
    for (int i = 0; i < 25; i++) {
      double randomPercent = Random().nextDouble() * 0.7 + 0.3;
      String dateKey = convertDateTimeToString(
        startDate.add(Duration(days: i)),
      );
      _myBox.put(
        "PERCENTAGE_SUMMARY_$dateKey",
        randomPercent.toStringAsFixed(1),
      );
    }

    // Add sample achievements
    achievements[0].unlocked = true; 
    achievements[1].unlocked = true; 
    achievements[2].unlocked = true; 
    achievements[3].unlocked = false;

    // Save achievements state to Hive
    _saveAchievementState();

    _myBox.put("START_DATE", "20250203");

    // Save today's habit list to Hive
    _myBox.put(todaysDateFormatted(), todaysHabitList);
    _myBox.put("CURRENT_HABIT_LIST", todaysHabitList);

    // Update the heatmap
    loadHeatMap();
  }
}
