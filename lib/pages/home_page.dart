import 'package:flutter/material.dart';
import 'package:trackit/components/habit_tile.dart';
import 'package:trackit/components/fab.dart';
import 'package:trackit/components/new_habit_box.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List todaysHabitList = [
    ["Morning Run", false],
    ["Read Book", false],
    ["Sleep early", false],
  ];

  void checkBoxTapped(bool? value, int index) {
    setState(() {
      todaysHabitList[index][1] = value;
    });
  }

  final _newHabitNameController = TextEditingController();

  void createNewHabit() {
    showDialog(
      context: context,
      builder: (context) {
        return EnterNewHabitBox(
          controller: _newHabitNameController,
          onSave: saveNewHabit,
          onCancel: cancelNewHabit,
        );
      },
    );
  }

  void saveNewHabit() {
    // add new habit to list
    setState(() {
      todaysHabitList.add([_newHabitNameController.text, false]);
    });

    _newHabitNameController.clear(); // clear text field
    Navigator.of(context).pop(); // pop dialog box
  }

  void cancelNewHabit() {
    _newHabitNameController.clear(); // clear text field
    Navigator.of(context).pop(); // pop dialog box
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[300],
      floatingActionButton: MyFloatingActionButton(onPressed: createNewHabit),
      body: ListView.builder(
        itemCount: todaysHabitList.length,
        itemBuilder: (context, index) {
          return HabitTile(
            name: todaysHabitList[index][0],
            isCompleted: todaysHabitList[index][1],
            onChanged: (value) => checkBoxTapped(value, index),
          );
        },
      ),
    );
  }
}
