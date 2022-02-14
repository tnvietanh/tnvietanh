import 'dart:math';

import 'package:app_flutter/provider.dart/bmi.dart';
import 'package:app_flutter/provider.dart/food_chosed.dart';
import 'package:app_flutter/provider.dart/workout_chosed.dart';
import 'package:app_flutter/screen/foods/foods_screen.dart';
import 'package:app_flutter/screen/ingerdient_progress.dart';
import 'package:app_flutter/screen/work_out/workout_list_screen.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatefulWidget {
  static const routeName = '/home-screen';
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int touchedIndex = -1;

  @override
  Widget build(BuildContext context) {
    final bmiModelProvider = Provider.of<BmiModel>(context);
    final bmr = bmiModelProvider.bmr;
    final totalProtein = Provider.of<CartProvider>(context).totalProtein;
    final totalFat = Provider.of<CartProvider>(context).totalFat;
    final totalCarb = Provider.of<CartProvider>(context).totalCarb;
    final totalKcal = Provider.of<CartProvider>(context).totalKcal;
    final totalKcalBurn = Provider.of<PracticedProvider>(context).totalKcalBurn;

    final width = MediaQuery.of(context).size.width;
    final today = DateTime.now();
    return WillPopScope(
        onWillPop: () async {
          return false;
        },
        child: Scaffold(
          backgroundColor: Colors.grey[200],
          appBar: AppBar(
            automaticallyImplyLeading: false,
            centerTitle: true,
            title: const Text('Home Screen'),
          ),
          body: SingleChildScrollView(
            child: Column(
              children: <Widget>[
                ClipRRect(
                  borderRadius: const BorderRadius.vertical(
                    bottom: Radius.circular(30),
                  ),
                  child: Container(
                    color: Colors.white,
                    padding: const EdgeInsets.only(
                        top: 10, left: 22, right: 16, bottom: 10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        ListTile(
                          title: Text(
                            "${DateFormat("EEEE").format(today)}, ${DateFormat("d MMMM").format(today)}",
                            style: const TextStyle(
                              fontWeight: FontWeight.w400,
                              fontSize: 18,
                            ),
                          ),
                          subtitle: const Text(
                            "Hello, User",
                            style: TextStyle(
                              fontWeight: FontWeight.w800,
                              fontSize: 26,
                              color: Colors.black,
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        Row(
                          children: <Widget>[
                            _RadialProgress(
                              width: width * 0.3,
                              height: width * 0.3,
                              progress: 2 * pi * (70 / 100),
                              limitKcal: bmr,
                            ),
                            const SizedBox(
                              width: 25,
                            ),
                            Column(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              mainAxisSize: MainAxisSize.max,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                IngredientProgress(
                                  ingredient: "Protein",
                                  progress: (totalProtein / (bmr * 0.08)),
                                  progressColor: Colors.green,
                                  leftAmount: totalProtein.toInt(),
                                  width: width * 0.28,
                                  limitAmount: bmr * 0.08,
                                ),
                                const SizedBox(
                                  height: 10,
                                ),
                                IngredientProgress(
                                  ingredient: "Carbs",
                                  progress: (totalCarb / (bmr * 0.08)),
                                  progressColor: Colors.red,
                                  leftAmount: totalCarb.toInt(),
                                  width: width * 0.28,
                                  limitAmount: bmr * 0.08,
                                ),
                                const SizedBox(
                                  height: 10,
                                ),
                                IngredientProgress(
                                  ingredient: "Fat",
                                  progress: (totalFat / (bmr * 0.03)),
                                  progressColor: Colors.yellow,
                                  leftAmount: totalFat.toInt(),
                                  width: width * 0.28,
                                  limitAmount: bmr * 0.03,
                                ),
                              ],
                            )
                          ],
                        ),
                        const SizedBox(height: 15)
                      ],
                    ),
                  ),
                ),
                const SizedBox(
                  height: 15,
                ),
                Container(
                    margin:
                        const EdgeInsets.only(bottom: 10, left: 12, right: 12),
                    height: 80,
                    width: double.infinity,
                    decoration: const BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(20)),
                        color: Colors.white),
                    child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 35),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Absorbed ${totalKcal.round()}kcal',
                              style: Theme.of(context)
                                  .textTheme
                                  .headline1
                                  ?.copyWith(color: Colors.lightGreen[400]),
                            ),
                            Text(
                              'Consumed ${totalKcalBurn.round()}kcal',
                              style: Theme.of(context)
                                  .textTheme
                                  .headline1
                                  ?.copyWith(color: Colors.red[400]),
                            )
                          ],
                        ))),
                Row(
                  children: [
                    Expanded(
                      child: GestureDetector(
                        onTap: () {
                          Navigator.pushNamed(
                              context, CaloriesInScreen.routeName);
                        },
                        child: Container(
                            margin: const EdgeInsets.only(
                                bottom: 10, left: 12, right: 12),
                            height: 80,
                            decoration: BoxDecoration(
                                borderRadius:
                                    const BorderRadius.all(Radius.circular(20)),
                                color: Colors.lightGreen[400]),
                            child: const Center(
                              child: Text(
                                'Calories In',
                                style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.w800,
                                    color: Colors.white),
                              ),
                            )),
                      ),
                    ),
                    Expanded(
                      child: GestureDetector(
                        onTap: () {
                          Navigator.pushNamed(
                              context, WorkOutListSceen.routeName);
                        },
                        child: Container(
                            margin: const EdgeInsets.only(
                                bottom: 10, left: 12, right: 12),
                            height: 80,
                            decoration: BoxDecoration(
                                borderRadius:
                                    const BorderRadius.all(Radius.circular(20)),
                                color: Colors.red[400]),
                            child: const Center(
                                child: Text('Calories Burn',
                                    style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.w800,
                                        color: Colors.white)))),
                      ),
                    )
                  ],
                ),
                const SizedBox(
                  height: 15,
                ),
                const Water()
              ],
            ),
          ),
        ));
  }

  // List<PieChartSectionData> showingSections() {
  //   return List.generate(3, (i) {
  //     final isTouched = i == touchedIndex;
  //     final fontSize = isTouched ? 25.0 : 16.0;
  //     final radius = isTouched ? 60.0 : 50.0;
  //     final totalKcal = Provider.of<CartProvider>(context).totalKcal;
  //     final totalKcalBurn =
  //         Provider.of<PracticedProvider>(context).totalKcalBurn;

  //     double totalKcalPC = ((totalKcal / (totalKcal + totalKcalBurn)) * 100);
  //     double totalKcalBurnPC =
  //         ((totalKcalBurn / (totalKcalPC + totalKcalBurn)) * 100);

  //     switch (i) {
  //       case 0:
  //         return PieChartSectionData(
  //           color: Colors.green,
  //           value: radius * totalKcalPC,
  //           title: '${totalKcalPC.round()}%',
  //           radius: radius,
  //           titleStyle: TextStyle(
  //               fontSize: fontSize,
  //               fontWeight: FontWeight.bold,
  //               color: const Color(0xffffffff)),
  //         );
  //       case 1:
  //         return PieChartSectionData(
  //           color: Colors.orangeAccent,
  //           value: radius * totalKcalBurnPC,
  //           title: '${totalKcalBurnPC.round()}%',
  //           radius: radius,
  //           titleStyle: TextStyle(
  //               fontSize: fontSize,
  //               fontWeight: FontWeight.bold,
  //               color: const Color(0xffffffff)),
  //         );

  //       default:
  //         throw Error();
  //     }
  //   });
  // }
}

class _RadialProgress extends StatelessWidget {
  final double height, width, progress, limitKcal;

  const _RadialProgress(
      {Key? key,
      required this.height,
      required this.width,
      required this.progress,
      required this.limitKcal})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final totalKcal = Provider.of<CartProvider>(context).totalKcal;
    final totalKcalBurn = Provider.of<PracticedProvider>(context).totalKcalBurn;

    final number = ((limitKcal + totalKcalBurn) - (totalKcal)).round();
    return CustomPaint(
      painter: _RadialPainter(
        progress: totalKcal / (limitKcal + totalKcalBurn),
      ),
      child: SizedBox(
        height: height,
        width: width,
        child: Center(
          child: RichText(
            textAlign: TextAlign.center,
            text: TextSpan(
              children: [
                TextSpan(
                  text: '$number',
                  style: const TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF200087),
                  ),
                ),
                const TextSpan(text: "\n"),
                const TextSpan(
                  text: "kcal need",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w500,
                    color: Color(0xFF200087),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _RadialPainter extends CustomPainter {
  final double progress;

  _RadialPainter({required this.progress});

  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = Paint()
      ..strokeWidth = 10
      ..color = Colors.black12
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;
    Offset center = Offset(size.width / 2, size.height / 2);
    double radius = size.width / 2;
    canvas.drawCircle(center, radius, paint);

    Paint paintA = Paint()
      ..strokeWidth = 10
      ..color = const Color(0xFF200087)
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    double angel = 2 * pi * progress;
    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      pi / 2,
      angel,
      false,
      paintA,
    );
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}

class Water extends StatefulWidget {
  const Water({Key? key}) : super(key: key);

  @override
  _WaterState createState() => _WaterState();
}

class _WaterState extends State<Water> {
  int waterML = 0;
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          height: 100,
          width: double.infinity,
          decoration: const BoxDecoration(
            borderRadius: BorderRadius.only(
                topRight: Radius.circular(25.0),
                topLeft: Radius.circular(25.0)),
            color: Colors.white,
          ),
          child: Center(
              child: Column(
            children: [
              Text(
                '${(waterML / 2000) * 100}%',
                style: const TextStyle(
                    color: Colors.blue,
                    fontWeight: FontWeight.w900,
                    fontSize: 45),
              ),
              Text(
                '$waterML/2000 ml water',
                style: const TextStyle(color: Colors.black, fontSize: 18),
              ),
            ],
          )),
        ),
        Container(
          height: 100,
          width: double.infinity,
          decoration: const BoxDecoration(
            borderRadius: BorderRadius.only(
                bottomRight: Radius.circular(25.0),
                bottomLeft: Radius.circular(25.0)),
            color: Colors.blue,
          ),
          child: Center(
              child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 35),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                ElevatedButton(
                  onPressed: () {
                    setState(() {
                      waterML = waterML + 100;
                    });
                  },
                  child: Text("100ml",
                      style: Theme.of(context).textTheme.headline4),
                ),
                ElevatedButton(
                  onPressed: () {
                    setState(() {
                      waterML = waterML + 200;
                    });
                  },
                  child: Text("200ml",
                      style: Theme.of(context).textTheme.headline4),
                ),
                ElevatedButton(
                  onPressed: () {
                    setState(() {
                      waterML = waterML + 300;
                    });
                  },
                  child: Text("300ml",
                      style: Theme.of(context).textTheme.headline4),
                ),
              ],
            ),
          )),
        ),
      ],
    );
  }
}
