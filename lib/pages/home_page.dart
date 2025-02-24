import 'package:flutter/material.dart';
import 'package:trackit/components/habit_tile.dart';
import 'package:trackit/components/fab.dart';
import 'package:trackit/components/habit_box.dart';
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
      db.loadData();
    }
    db.updateDB();
    super.initState();
  }

  void checkBoxTapped(bool? value, int index) {
    setState(() {
      db.todaysHabitList[index][1] = value;
    });
    db.updateDB();
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
      db.todaysHabitList.add([_newHabitNameController.text, false]);
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
    showDialog(
      context: context,
      builder: (context) {
        return HabitAlertBox(
          controller: _newHabitNameController,
          hintText: db.todaysHabitList[index][0],
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
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[300],
      floatingActionButton: MyFloatingActionButton(onPressed: createNewHabit),
      body: ListView.builder(
        itemCount: db.todaysHabitList.length,
        itemBuilder: (context, index) {
          return HabitTile(
            name: db.todaysHabitList[index][0],
            isCompleted: db.todaysHabitList[index][1],
            onChanged: (value) => checkBoxTapped(value, index),
            settingsTapped: (context) => openHabitSettings(index),
            deleteTapped: (context) => deleteHabit(index),
          );
        },
      ),
    );
  }
}
