import 'package:app_flutter/screen/bmi/body_stats_screen.dart';
import 'package:app_flutter/screen/foods/foods_screen.dart';
import 'package:app_flutter/screen/dash_board/dash_board_screen.dart';
import 'package:app_flutter/screen/home_screen.dart';
import 'package:app_flutter/screen/profile_screen.dart';
import 'package:flutter/material.dart';

class DrawerMenu extends StatefulWidget {
  const DrawerMenu({Key? key}) : super(key: key);

  @override
  _DrawerMenuState createState() => _DrawerMenuState();
}

class _DrawerMenuState extends State<DrawerMenu> {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        // Important: Remove any padding from the ListView.
        padding: EdgeInsets.zero,
        children: [
          Container(
            height: 180,
            color: Colors.grey,
            child: Center(
              child: Stack(
                children: [
                  ClipOval(
                    child: Container(
                      height: 120,
                      width: 120,
                      color: Colors.amber,
                    ),
                  ),
                  Positioned(
                    bottom: 20.0,
                    right: 20.0,
                    child: InkWell(
                      onTap: () {},
                      child: const Icon(
                        Icons.camera_alt,
                        color: Colors.teal,
                        size: 28.0,
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
          ListTile(
            title: const Text('home'),
            onTap: () {
              Navigator.pushReplacementNamed(context, HomeScreen.routeName);
            },
          ),
          ListTile(
            title: const Text('Calories In Screen'),
            onTap: () {
              Navigator.pushReplacementNamed(
                  context, CaloriesInScreen.routeName);
            },
          ),
          ListTile(
            title: const Text('prdn'),
            onTap: () {
              Navigator.pushReplacementNamed(context, CartScreen.routeName);
            },
          ),
          ListTile(
            title: const Text('bmi'),
            onTap: () {
              Navigator.pushReplacementNamed(context, BmiCaculator.routeName);
            },
          ),
          ListTile(
            title: const Text('Profile'),
            onTap: () {
              Navigator.pushReplacementNamed(context, ProfileScreen.routeName);
            },
          ),
        ],
      ),
    );
  }
}
