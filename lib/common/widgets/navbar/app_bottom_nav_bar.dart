import 'package:flutter/material.dart';

class AppBottomNavBar extends StatelessWidget {
  //  |: Variables
  final int currentIndex;

  //  |: Constructor
  const AppBottomNavBar({super.key, required this.currentIndex});

  //  |: Functions
  void _onTap(BuildContext context, int index) {
    if (index == currentIndex) return;

    switch (index) {
      case 0:
        Navigator.pushReplacementNamed(context, '/pot');
        break;

      case 1:
        Navigator.pushReplacementNamed(context, '/notifications');
        break;

      case 2:
        Navigator.pushReplacementNamed(context, '/profile');
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      currentIndex: currentIndex,
      onTap: (i) => _onTap(context, i),
      items: const [
        BottomNavigationBarItem(icon: Icon(Icons.local_florist), label: "Pots"),
        BottomNavigationBarItem(icon: Icon(Icons.notifications_none), label: "Notifications"),
        BottomNavigationBarItem(icon: Icon(Icons.person_outline), label: "Profile"),
      ],
    );
  }
}
