import 'package:flutter/material.dart';

class HabitAlertBox extends StatelessWidget {
  final dynamic controller;
  final String hintText;
  final VoidCallback onSave;
  final VoidCallback onCancel;

  const HabitAlertBox({
    super.key,
    required this.controller,
    required this.hintText,
    required this.onSave,
    required this.onCancel,
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: Colors.grey[800],
      content: TextField(
        controller: controller,
        style: TextStyle(color: Colors.white),
        decoration: InputDecoration(
          hintText: hintText,
          hintStyle: TextStyle(color: Colors.grey[500]),
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.white),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.white),
          ),
        ),
      ),
      actions: [
        MaterialButton(
          onPressed: onSave,
          color: Colors.black,
          child: Text("Save", style: TextStyle(color: Colors.white)),
        ),
        MaterialButton(
          onPressed: onCancel,
          color: Colors.black,
          child: Text("Cancel", style: TextStyle(color: Colors.white)),
        ),
      ],
    );
  }
}
