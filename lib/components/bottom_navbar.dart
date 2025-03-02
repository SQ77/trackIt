import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:trackit/pages/profile_page.dart';
import 'package:trackit/pages/home_page.dart';
import 'package:trackit/theme/theme.dart';
import 'package:trackit/theme/theme_provider.dart';

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
    final themeProvider = Provider.of<ThemeProvider>(context);

    const WidgetStateProperty<Icon> thumbIcon =
        WidgetStateProperty<Icon>.fromMap(<WidgetStatesConstraint, Icon>{
          WidgetState.selected: Icon(Icons.dark_mode, color: Colors.white),
          WidgetState.any: Icon(Icons.light_mode),
        });

    return BottomAppBar(
      shape: CircularNotchedRectangle(),
      color: Theme.of(context).colorScheme.primary,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          IconButton(
            icon: Icon(
              Icons.home,
              color:
                  Theme.of(context).brightness == Brightness.dark
                      ? Colors.white70
                      : Colors.black,
            ),
            iconSize: 30,
            tooltip: "Home",
            onPressed: () => navigateToHome(context),
          ),
          IconButton(
            icon: Icon(
              Icons.person,
              color:
                  Theme.of(context).brightness == Brightness.dark
                      ? Colors.white70
                      : Colors.black,
            ),
            iconSize: 30,
            tooltip: "Profile",
            onPressed: () => navigateToProfile(context),
          ),
          Container(
            decoration: BoxDecoration(
              border: Border.all(color: Colors.white, width: 1),
              borderRadius: BorderRadius.all(Radius.circular(20)),
            ),
            child: SizedBox(
              width: 51,
              height: 31,
              child: Switch(
                thumbIcon: thumbIcon,
                value: themeProvider.themeData == darkMode,
                onChanged: (value) {
                  themeProvider.toggleTheme();
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
