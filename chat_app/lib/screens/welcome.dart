import 'package:chat_app/provider/auth_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'authentication.dart';

import 'home_page.dart';

class WelcomeScreen extends StatefulWidget {
  static const routeName = 'home';
  const WelcomeScreen({Key? key}) : super(key: key);

  @override
  State<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  @override
  void initState() {
    super.initState();
    checkLoggedIn();
  }

  void checkLoggedIn() async {
    bool isLoggedIn =
        await Provider.of<AuthProvider>(context, listen: false).isLoggedIn();
    if (isLoggedIn) {
      Navigator.pushReplacementNamed(context, HomePage.routeName);
    }
  }

  @override
  Widget build(BuildContext context) {
    final deviceWidth = MediaQuery.of(context).size.width;
    final deviceHeight = MediaQuery.of(context).size.height;
    return SafeArea(
      child: Scaffold(
        body: Stack(
          children: [
            Positioned(
              width: deviceWidth * 0.8,
              top: 0,
              left: 0,
              child: Image.asset('assets/images/top.png'),
            ),
            Positioned(
              width: deviceWidth * 0.8,
              bottom: 0,
              right: 0,
              child: Image.asset('assets/images/bottom.png'),
            ),
            Padding(
              padding: EdgeInsets.only(top: deviceHeight * 0.12),
              child: Column(
                children: [
                  const Text(
                    'Chat App',
                    style: TextStyle(
                        color: Color(0xFF395B65),
                        fontFamily: 'Rock3D',
                        fontSize: 50,
                        fontWeight: FontWeight.w900),
                  ),
                  SizedBox(height: deviceHeight * 0.03),
                  Image.asset(
                    'assets/images/chat_app.png',
                    width: deviceWidth,
                  ),
                  SizedBox(height: deviceHeight * 0.03),
                  ElevatedButton(
                    child: const Text(
                      'Start Messaging',
                    ),
                    style: ElevatedButton.styleFrom(
                      fixedSize: Size(deviceWidth * 0.6, deviceHeight * 0.06),
                      primary: const Color(0xFF395B65),
                      onPrimary: Colors.white,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10)),
                    ),
                    onPressed: () {
                      Navigator.pushNamed(context, AuthScreen.routeName);
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
