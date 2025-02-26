import 'package:flutter/material.dart';
import 'package:trackit/components/bottom_navbar.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Profile'),
      ),
      body: Center(
        child: Text('This is the Profile Page'),
      ),
      bottomNavigationBar: BottomNavbar(),
    );
  }
}
