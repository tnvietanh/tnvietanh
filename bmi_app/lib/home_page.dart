import 'package:app_flutter/screen/dash_board/dash_board_screen.dart';
import 'package:app_flutter/screen/foods/foods_screen.dart';
import 'package:app_flutter/screen/home_screen.dart';
import 'package:app_flutter/screen/profile_screen.dart';
import 'package:app_flutter/screen/work_out/work_out_screen.dart';
import 'package:app_flutter/screen/work_out/workout_list_screen.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  HomePageState createState() => HomePageState();
}

class HomePageState extends State<HomePage> {
  int _currentIndex = 0;
  List<Widget> _children() => [
        const HomeScreen(),
        const TabBarScreen(),
        const ProfileScreen(),
      ];

  void onTabTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    final List<Widget> children = _children();

    return Scaffold(
      body: children[_currentIndex], // new
      bottomNavigationBar: BottomNavigationBar(
        onTap: onTabTapped,
        currentIndex: _currentIndex,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.sticky_note_2_rounded),
            label: 'Dash Board',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.account_circle_rounded),
            label: 'Settings',
          ),
        ],
      ),
    );
  }
}
