import 'package:hive_flutter/hive_flutter.dart';
import 'package:trackit/datetime/date_time.dart';

final _myBox = Hive.box("Habit_DB");

class HabitDB {
  List todaysHabitList = [];

  // create default data initially
  void createDefaultData() {
    todaysHabitList = [
      ["Run 5km", false],
      ["Read for 10 minutes", false],
      ["Clear email inbox", false],
    ];

    _myBox.put("START_DATE", todaysDateFormatted());
  }

  // load existing data
  void loadData() {
    // start of a new day
    if (_myBox.get(todaysDateFormatted()) == null) {
      todaysHabitList = _myBox.get("CURRENT_HABIT_LIST");
      // reset all habits to not done
      for (int i = 0; i < todaysHabitList.length; i++) {
        todaysHabitList[i][1] = false;
      }
    } else {
      todaysHabitList = _myBox.get(todaysDateFormatted());
    }
  }

  // update db
  void updateDB() {
    _myBox.put(todaysDateFormatted(), todaysHabitList);
    _myBox.put("CURRENT_HABIT_LIST", todaysHabitList);
  }
}
