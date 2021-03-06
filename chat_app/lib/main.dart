import 'package:chat_app/provider/user_provider.dart';
import 'package:chat_app/screens/home_page.dart';
import 'package:chat_app/screens/search_screen.dart';
import 'package:chat_app/theme.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'provider/auth_provider.dart';
import 'screens/authentication.dart';
import 'screens/update_profile.dart';
import 'screens/welcome.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
      // options: const FirebaseOptions(
      //     apiKey: "AIzaSyDTGs9mzFLXM6j24dRkhQxKKGy5PWhkhv8",
      //     authDomain: "chat-app-200f0.firebaseapp.com",
      //     projectId: "chat-app-200f0",
      //     storageBucket: "chat-app-200f0.appspot.com",
      //     messagingSenderId: "767446320674",
      //     appId: "1:767446320674:web:9a27bfeed463ee9e38ac7b"),
      );
  SharedPreferences prefs = await SharedPreferences.getInstance();
  runApp(MyApp(prefs: prefs));
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key, required this.prefs}) : super(key: key);
  final SharedPreferences prefs;
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider(prefs: prefs)),
        ChangeNotifierProvider(create: (_) => UserProvider(prefs: prefs)),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: lightThemeData(context),
        darkTheme: darkThemeData(context),
        home: const WelcomeScreen(),
        routes: {
          'home': (_) => const WelcomeScreen(),
          AuthScreen.routeName: (context) => const AuthScreen(),
          SearchScreen.routeName: (context) => const SearchScreen(),
          HomePage.routeName: (context) => const HomePage(),
          UpdateProfile.routeName: (context) => const UpdateProfile(),
        },
      ),
    );
  }
}
