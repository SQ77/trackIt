import 'package:flutter/material.dart';
import 'package:trackit/components/bottom_navbar.dart';
import 'package:trackit/components/habit_tile.dart';
import 'package:trackit/components/fab.dart';
import 'package:trackit/components/habit_box.dart';
import 'package:trackit/components/monthly_summary.dart';
import 'package:trackit/data/habit_db.dart';
import 'package:hive_flutter/hive_flutter.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  HabitDB db = HabitDB();
  final _myBox = Hive.box("Habit_DB");

  @override
  void initState() {
    if (_myBox.get("CURRENT_HABIT_LIST") == null) {
      db.createDefaultData();
    } else {
      //db.clearBoxData();
      db.loadData();
    }
    db.updateDB();
    super.initState();
  }

  void checkBoxTapped(bool? value, int index) {
    setState(() {
      db.todaysHabitList[index][1] = value;
      // update streaks
      if (value != null && value == true) {
        db.todaysHabitList[index][2]++;
      } else if (value != null && value == false) {
        db.todaysHabitList[index][2]--;
      }
    });
    db.updateDB();
    db.unlockAchievements();
  }

  final _newHabitNameController = TextEditingController();

  void createNewHabit() {
    showDialog(
      context: context,
      builder: (context) {
        return HabitAlertBox(
          controller: _newHabitNameController,
          hintText: "Enter Habit Name...",
          onSave: saveNewHabit,
          onCancel: cancelDialogBox,
        );
      },
    );
  }

  void saveNewHabit() {
    // add new habit to list
    setState(() {
      db.todaysHabitList.add([_newHabitNameController.text, false, 0]);
    });

    _newHabitNameController.clear(); // clear text field
    Navigator.of(context).pop(); // pop dialog box
    db.updateDB();
  }

  void cancelDialogBox() {
    _newHabitNameController.clear(); // clear text field
    Navigator.of(context).pop(); // pop dialog box
  }

  void openHabitSettings(index) {
    _newHabitNameController.text = db.todaysHabitList[index][0];

    showDialog(
      context: context,
      builder: (context) {
        return HabitAlertBox(
          controller: _newHabitNameController,
          hintText: "Edit Habit Name...",
          onSave: () => saveExistingHabit(index),
          onCancel: cancelDialogBox,
        );
      },
    );
  }

  void saveExistingHabit(int index) {
    setState(() {
      db.todaysHabitList[index][0] = _newHabitNameController.text;
    });
    _newHabitNameController.clear();
    Navigator.pop(context);
    db.updateDB();
  }

  void deleteHabit(int index) {
    setState(() {
      db.todaysHabitList.removeAt(index);
    });
    db.updateDB();
    db.unlockAchievements();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[300],
      floatingActionButton: MyFloatingActionButton(onPressed: createNewHabit),
      body: ListView(
        children: [
          // monthly summary heatmap
          MonthlySummary(
            datasets: db.heatMapDataSet,
            startDate: _myBox.get("START_DATE"),
          ),

          Padding(
            padding: const EdgeInsets.symmetric(
              vertical: 1.0,
              horizontal: 20.0,
            ),
            child: Row(
              children: [
                Icon(Icons.checklist_outlined, color: Colors.black, size: 28),
                SizedBox(width: 10),
                Text(
                  "Today's Habits",
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
              ],
            ),
          ),

          // list of habits
          ListView.builder(
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            itemCount: db.todaysHabitList.length,
            itemBuilder: (context, index) {
              return HabitTile(
                name: db.todaysHabitList[index][0],
                isCompleted: db.todaysHabitList[index][1],
                streak: db.todaysHabitList[index][2],
                onChanged: (value) => checkBoxTapped(value, index),
                settingsTapped: (context) => openHabitSettings(index),
                deleteTapped: (context) => deleteHabit(index),
              );
            },
          ),
        ],
      ),
      bottomNavigationBar: BottomNavbar(),
    );
  }
}
