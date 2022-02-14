import 'package:alan_voice/alan_voice.dart';
import 'package:app_flutter/provider.dart/bmi.dart';
import 'package:app_flutter/provider.dart/calo_burn.dart';
import 'package:app_flutter/provider.dart/auth.dart';
import 'package:app_flutter/provider.dart/google_sign_in.dart';
import 'package:app_flutter/provider.dart/workout_chosed.dart';
import 'package:app_flutter/provider.dart/food_chosed.dart';
import 'package:app_flutter/provider.dart/food.dart';
import 'package:app_flutter/provider.dart/user.dart';
import 'package:app_flutter/provider.dart/workout.dart';
import 'package:app_flutter/screen/auth/login_screen.dart';
import 'package:app_flutter/screen/bmi/body_stats_screen.dart';
import 'package:app_flutter/screen/foods/foods_screen.dart';
import 'package:app_flutter/screen/dash_board/dash_board_screen.dart';
import 'package:app_flutter/screen/foods/foods_update_screen.dart';
import 'package:app_flutter/screen/home_screen.dart';
import 'package:app_flutter/screen/profile_screen.dart';
import 'package:app_flutter/screen/update_profile_screen.dart';
import 'package:app_flutter/screen/work_out/workout_list_screen.dart';
import 'package:app_flutter/screen/work_out/workout_update_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

int? isviewed;

Future main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
    statusBarColor: Colors.transparent,
  ));
  WidgetsFlutterBinding.ensureInitialized();
  SharedPreferences prefs = await SharedPreferences.getInstance();
  isviewed = prefs.getInt('onBoard');

  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  _MyAppState() {
    AlanVoice.addButton(
        "dad035de1dce25d5611e6130bbed73622e956eca572e1d8b807a3e2338fdd0dc/stage",
        buttonAlign: AlanVoice.BUTTON_ALIGN_LEFT);

    /// Handle commands from Alan Studio
    AlanVoice.onCommand.add((command) => _handleCommand(command.data));
  }

  /// Init Alan Button with project key from Alan Studio

  void _handleCommand(Map<String, dynamic> command) {
    switch (command["command"]) {
      case "home":
        Navigator.pushReplacementNamed(context, HomeScreen.routeName);
        break;
      case 'profile':
        Navigator.pushNamed(context, ProfileScreen.routeName);
        break;
      default:
        debugPrint("Unknown command");
    }
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => CartProvider()),
        ChangeNotifierProvider(create: (_) => CaloBurnProvider(0, 0)),
        ChangeNotifierProvider(create: (_) => BmiModel(0, 0, 0, 0, 0, 0)),
        ChangeNotifierProvider(create: (_) => PracticedProvider()),
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        ChangeNotifierProvider(create: (_) => GoogleSignInProvider()),
        ChangeNotifierProxyProvider<AuthProvider, FoodProvider>(
          create: (_) => FoodProvider([]),
          update: (context, value, previous) =>
              previous!..updateAuthToken(value.token, value.userId),
        ),
        ChangeNotifierProxyProvider<AuthProvider, WorkOutProvider>(
          create: (_) => WorkOutProvider([]),
          update: (context, value, previous) =>
              previous!..updateAuthToken(value.token, value.userId),
        ),
        ChangeNotifierProxyProvider<AuthProvider, UserProvider>(
          create: (_) => UserProvider([]),
          update: (context, value, previous) =>
              previous!..updateAuthToken(value.token, value.userId),
        ),
        // ChangeNotifierProxyProvider<AuthProvider, UserStatsProvider>(
        //   create: (_) => UserStatsProvider([]),
        //   update: (context, value, previous) =>
        //       previous!..updateAuthToken(value.token, value.userId),
        // ),
      ],
      child: Builder(builder: (context) {
        return MaterialApp(
          title: 'Flutter Demo',
          theme: ThemeData(
              primarySwatch: Colors.blue,
              textTheme: const TextTheme(
                headline1: TextStyle(
                  fontSize: 15,
                  color: Colors.black,
                  fontWeight: FontWeight.w400,
                ),
                headline2: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: Colors.black),
                headline3: TextStyle(
                    fontSize: 25,
                    fontWeight: FontWeight.bold,
                    color: Colors.black),
                headline4: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.w900,
                    color: Colors.white),
              )),
          debugShowCheckedModeBanner: false,
          // home: const LoginScreen(),
          home: Provider.of<AuthProvider>(context, listen: true).token != null
              ? isviewed != 0
                  ? const BmiCaculator()
                  : const HomeScreen()
              : const LoginScreen(),

          routes: {
            ProfileScreen.routeName: (context) => const ProfileScreen(),
            HomeScreen.routeName: (context) => const HomeScreen(),
            CartScreen.routeName: (context) => const CartScreen(),
            CaloriesInScreen.routeName: (context) => const CaloriesInScreen(),
            BmiCaculator.routeName: (context) => const BmiCaculator(),
            WorkOutListSceen.routeName: (context) => const WorkOutListSceen(),
            TabBarScreen.routeName: (context) => const TabBarScreen(),
          },
          onGenerateRoute: generateRoute,
          onUnknownRoute: (settings) => MaterialPageRoute(
            builder: (context) => const Text('Unknown route'),
          ),
        );
      }),
    );
  }

  Route<dynamic>? generateRoute(RouteSettings settings) {
    if (settings.name == WorkOutUpdateScreen.routeName) {
      return MaterialPageRoute(
          builder: (_) {
            //some custom code
            return const WorkOutUpdateScreen();
          },
          settings: settings);
    } else if (settings.name == FoodUpdateScreen.routeName) {
      return MaterialPageRoute(
          builder: (_) {
            //some custom code
            return const FoodUpdateScreen();
          },
          settings: settings);
    } else if (settings.name == UpdateProfileScreen.routeName) {
      return MaterialPageRoute(
          builder: (_) {
            //some custom code
            return const UpdateProfileScreen();
          },
          settings: settings);
    }
    return null;
  }
}
