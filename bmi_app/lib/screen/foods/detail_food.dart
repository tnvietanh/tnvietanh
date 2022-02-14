import 'package:app_flutter/provider.dart/bmi.dart';
import 'package:app_flutter/screen/ingerdient_progress.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class DetailFood extends StatefulWidget {
  final items;
  const DetailFood({Key? key, this.items}) : super(key: key);

  @override
  _DetailFoodState createState() => _DetailFoodState();
}

class _DetailFoodState extends State<DetailFood> {
  int touchedIndex = -1;

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;

    final bmiModelProvider = Provider.of<BmiModel>(context);
    final bmr = bmiModelProvider.bmr;
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.items.name,
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Text('Nutritional ingredients',
                  style: Theme.of(context).textTheme.headline3),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
              child: Container(
                height: 230,
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(30),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.5),
                      spreadRadius: 5,
                      blurRadius: 7,
                      offset: const Offset(0, 3), // changes position of shadow
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.fromLTRB(50, 10, 80, 10),
                      child: SizedBox(
                        height: 100,
                        width: 100,
                        child: PieChart(
                          PieChartData(
                              pieTouchData: PieTouchData(touchCallback:
                                  (FlTouchEvent event, pieTouchResponse) {
                                setState(() {
                                  if (!event.isInterestedForInteractions ||
                                      pieTouchResponse == null ||
                                      pieTouchResponse.touchedSection == null) {
                                    touchedIndex = -1;
                                    return;
                                  }
                                  touchedIndex = pieTouchResponse
                                      .touchedSection!.touchedSectionIndex;
                                });
                              }),
                              borderData: FlBorderData(
                                show: false,
                              ),
                              sectionsSpace: 0,
                              centerSpaceRadius: 25,
                              sections: showingSections()),
                        ),
                      ),
                    ),
                    Column(
                      mainAxisSize: MainAxisSize.max,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 60),
                        rowWidget(
                            icon: const Icon(
                              Icons.directions_run_rounded,
                              color: Colors.green,
                              size: 30,
                            ),
                            text: 'PROTEIN',
                            stats: widget.items.protein),
                        const SizedBox(
                          height: 10,
                        ),
                        rowWidget(
                            icon: const Icon(
                              Icons.directions_bike,
                              color: Colors.orangeAccent,
                              size: 30,
                            ),
                            text: 'CARB',
                            stats: widget.items.carb),
                        const SizedBox(
                          height: 10,
                        ),
                        rowWidget(
                            icon: const Icon(
                              Icons.mood_bad_rounded,
                              color: Colors.pinkAccent,
                              size: 30,
                            ),
                            text: 'FAT',
                            stats: widget.items.fat),
                      ],
                    )
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Text('Daily goals',
                  style: Theme.of(context).textTheme.headline3),
            ),
            Padding(
              padding: const EdgeInsets.all(10.0).copyWith(top: 0),
              child: Container(
                height: 200,
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(30),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.5),
                      spreadRadius: 5,
                      blurRadius: 7,
                      offset: const Offset(0, 3), // changes position of shadow
                    ),
                  ],
                ),
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(25, 35, 25, 25),
                  child: Column(
                    children: [
                      IngredientProgress(
                        ingredient: "Calo",
                        progress: (widget.items.kiloCalories / bmr),
                        progressColor: Colors.blueAccent,
                        leftAmount: widget.items.kiloCalories.toInt(),
                        width: width * 0.38,
                        limitAmount: bmr,
                      ),
                      IngredientProgress(
                        ingredient: "PROTEIN",
                        progress: (widget.items.protein / (bmr * 0.03)),
                        progressColor: Colors.green,
                        leftAmount: widget.items.protein.toInt(),
                        width: width * 0.38,
                        limitAmount: bmr * 0.03,
                      ),
                      IngredientProgress(
                        ingredient: "Carb",
                        progress: (widget.items.carb / (bmr * 0.03)),
                        progressColor: Colors.orangeAccent,
                        leftAmount: widget.items.carb.toInt(),
                        width: width * 0.38,
                        limitAmount: bmr * 0.03,
                      ),
                      IngredientProgress(
                        ingredient: "Fat",
                        progress: (widget.items.fat / (bmr * 0.03)),
                        progressColor: Colors.pinkAccent,
                        leftAmount: widget.items.fat.toInt(),
                        width: width * 0.38,
                        limitAmount: bmr * 0.03,
                      ),
                    ],
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  List<PieChartSectionData> showingSections() {
    return List.generate(3, (i) {
      final isTouched = i == touchedIndex;
      final fontSize = isTouched ? 25.0 : 16.0;
      final radius = isTouched ? 60.0 : 50.0;
      double protein = widget.items.protein;
      double carb = widget.items.carb;
      double fat = widget.items.fat;
      double proteinPC = ((protein / (protein + carb + fat)) * 100);
      double carbPC = ((carb / (protein + carb + fat)) * 100);
      late double fatPC = ((fat / (protein + carb + fat)) * 100);
      switch (i) {
        case 0:
          return PieChartSectionData(
            color: Colors.green,
            value: radius * proteinPC,
            title: '${proteinPC.round()}%',
            radius: radius,
            titleStyle: TextStyle(
                fontSize: fontSize,
                fontWeight: FontWeight.bold,
                color: const Color(0xffffffff)),
          );
        case 1:
          return PieChartSectionData(
            color: Colors.orangeAccent,
            value: radius * carbPC,
            title: '${carbPC.round()}%',
            radius: radius,
            titleStyle: TextStyle(
                fontSize: fontSize,
                fontWeight: FontWeight.bold,
                color: const Color(0xffffffff)),
          );
        case 2:
          return PieChartSectionData(
            color: Colors.pinkAccent,
            value: radius * fatPC,
            title: '${fatPC.round()}%',
            radius: radius,
            titleStyle: TextStyle(
                fontSize: fontSize,
                fontWeight: FontWeight.bold,
                color: const Color(0xffffffff)),
          );

        default:
          throw Error();
      }
    });
  }
}

class rowWidget extends StatelessWidget {
  final Icon icon;
  final String text;
  final double stats;

  const rowWidget(
      {Key? key, required this.icon, required this.text, required this.stats})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        icon,
        const SizedBox(
          width: 5,
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              text,
              style: const TextStyle(
                  color: Colors.black, fontWeight: FontWeight.bold),
            ),
            Text(
              '${stats.round()} kcal Burn',
              style: const TextStyle(
                  color: Color(0xffc4bbcc), fontWeight: FontWeight.bold),
            )
          ],
        )
      ],
    );
  }
}
