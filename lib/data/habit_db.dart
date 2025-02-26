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
    Achievement(name: "First Habit", description: "Complete your first habit"),
    Achievement(name: "Streak Novice", description: "Reach a streak of 3 days"),
    Achievement(name: "Streak Master", description: "Reach a streak of 7 days"),
    Achievement(name: "Completionist", description: "Complete 100 habits"),
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

    // start of a new day
    if (_myBox.get(todaysDate) == null) {
      todaysHabitList = _myBox.get("CURRENT_HABIT_LIST") ?? [];

      for (int i = 0; i < todaysHabitList.length; i++) {
        // reset all habits to not done
        todaysHabitList[i][1] = false;

        bool wasCompletedYesterday =
            yesterdaysHabitList != null && yesterdaysHabitList[i][1] == true;
        // update streaks
        if (wasCompletedYesterday) {
          todaysHabitList[i][2] += 1;
        } else {
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

  void unlockAchievements() {
    var stats = getCompletedHabitCountAndBestStreak();
    var completedHabits = stats.firstInt;
    var bestStreak = stats.secondInt;
    // unlock "First Habit" after completing 1 habit
    if (completedHabits > 0 && !achievements[0].unlocked) {
      achievements[0].unlocked = true;
    }

    // unlock "Streak Novice" after a 3-day streak
    if (bestStreak >= 3 && !achievements[1].unlocked) {
      achievements[1].unlocked = true;
    }

    // unlock "Streak Master" after a 7-day streak
    if (bestStreak >= 7 && !achievements[2].unlocked) {
      achievements[2].unlocked = true;
    }

    // unlock "Completionist" after completing 100 habits
    if (completedHabits >= 100 && !achievements[3].unlocked) {
      achievements[3].unlocked = true;
    }
  }

  // resets all data, used for testing
  void clearBoxData() async {
    var box = await Hive.openBox("Habit_DB");
    await box.clear();
  }
}
