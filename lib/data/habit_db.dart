import 'package:hive_flutter/hive_flutter.dart';
import 'package:trackit/datetime/date_time.dart';

final _myBox = Hive.box("Habit_DB");

class HabitDB {
  List todaysHabitList = [];
  Map<DateTime, int> heatMapDataSet = {};

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

        bool wasCompletedYesterday = yesterdaysHabitList != null && yesterdaysHabitList[i][1] == true;
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
    DateTime startDate = createDateTimeObject(_myBox.get("START_DATE"));
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

  // resets all data, used for testing
  void clearBoxData() async {
    var box = await Hive.openBox("Habit_DB");
    await box.clear();
  }
}
