import 'package:flutter/material.dart';
import 'package:trackit/pages/profile_page.dart';
import 'package:trackit/pages/home_page.dart';

class BottomNavbar extends StatelessWidget {
  const BottomNavbar({super.key});

  void navigateToHome(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => HomePage()),
    );
  }

  void navigateToProfile(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => ProfilePage()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BottomAppBar(
      shape: CircularNotchedRectangle(),
      color: Colors.green[200],
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          IconButton(
            icon: Icon(Icons.home, color: Colors.black),
            iconSize: 30,
            tooltip: "Home",
            onPressed:
                () => navigateToHome(context), // Pass context to navigate
          ),
          IconButton(
            icon: Icon(Icons.person, color: Colors.black),
            iconSize: 30,
            tooltip: "Profile",
            onPressed:
                () => navigateToProfile(context), // Pass context to navigate
          ),
        ],
      ),
    );
  }
}
