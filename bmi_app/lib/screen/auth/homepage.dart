import 'package:app_flutter/screen/auth/login_screen.dart';
import 'package:app_flutter/screen/bmi/body_stats_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class MyApp2 extends StatelessWidget {
  const MyApp2({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: StreamBuilder(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasData) {
          return const BmiCaculator();
        } else if (snapshot.hasError) {
          return const Center(child: Text('Something Went Wrong!'));
        } else {
          return const LoginScreen();
        }
      },
    ));
  }
}
