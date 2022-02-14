import 'package:app_flutter/provider.dart/calo_burn.dart';
import 'package:app_flutter/provider.dart/workout_chosed.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CaloriesBurnScreen extends StatefulWidget {
  const CaloriesBurnScreen({
    Key? key,
  }) : super(key: key);

  @override
  _CaloriesBurnScreenState createState() => _CaloriesBurnScreenState();
}

class _CaloriesBurnScreenState extends State<CaloriesBurnScreen> {
  final TextEditingController _controller = TextEditingController();

  int touchedIndex = -1;

  @override
  Widget build(BuildContext context) {
    final _practicedProvider = Provider.of<PracticedProvider>(context);
    return SingleChildScrollView(
      child: ListView.separated(
          shrinkWrap: true,
          physics: const BouncingScrollPhysics(),
          itemBuilder: (BuildContext context, int index) {
            final item = _practicedProvider.items[index];
            return GestureDetector(
              onTap: () {
                showDialog(
                    context: context,
                    builder: (context) {
                      return AlertDialog(
                        title: Text(
                            "${item.name} (${item.kcalBurn.round()} kcal - ${_controller.text} minutes)"),
                        content: TextField(
                          controller: _controller,
                          keyboardType: TextInputType.number,
                          autofocus: true,
                          decoration: const InputDecoration(
                              labelText: 'Activity Time',
                              hintText: '30 minutes'),
                        ),
                        actions: [
                          ElevatedButton(
                              onPressed: () {
                                Navigator.of(context).pop(_controller.text);
                              },
                              child: const Text('OK'))
                        ],
                      );
                    });
              },
              child: Card(
                elevation: 10,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(50),
                ),
                child: ListTile(
                  title: Text(
                    item.name,
                    style: const TextStyle(
                        fontSize: 20, fontWeight: FontWeight.w800),
                  ),
                  subtitle: Text('${item.kcalBurn.round()} kcal - 30 minutes'),
                  trailing: IconButton(
                    icon: const Icon(Icons.clear_rounded),
                    onPressed: () {
                      _practicedProvider.removeProduct(item);
                    },
                  ),
                ),
              ),
            );
          },
          separatorBuilder: (BuildContext context, int index) => const SizedBox(
                height: 10,
              ),
          itemCount: _practicedProvider.items.length),
    );
  }

  List<PieChartSectionData> showingSections(double totalKcalBurn) {
    return List.generate(3, (i) {
      final caloBurnProvider = Provider.of<CaloBurnProvider>(context);
      final runBurn = caloBurnProvider.runBurn;
      final cycleBurn = caloBurnProvider.cycleBurn;
      final isTouched = i == touchedIndex;
      final fontSize = isTouched ? 25.0 : 16.0;
      final radius = isTouched ? 60.0 : 50.0;
      double runPC = ((runBurn / (runBurn + cycleBurn + totalKcalBurn)) * 100);
      double cyclePC =
          ((cycleBurn / (runBurn + cycleBurn + totalKcalBurn)) * 100);
      late double othersPC =
          ((totalKcalBurn / (runBurn + cycleBurn + totalKcalBurn)) * 100);
      switch (i) {
        case 0:
          return PieChartSectionData(
            color: Colors.blueAccent,
            value: radius * runPC,
            title: '${runPC.round()}%',
            radius: radius,
            titleStyle: TextStyle(
                fontSize: fontSize,
                fontWeight: FontWeight.bold,
                color: const Color(0xffffffff)),
          );
        case 1:
          return PieChartSectionData(
            color: Colors.orangeAccent,
            value: radius * cyclePC,
            title: '${cyclePC.round()}%',
            radius: radius,
            titleStyle: TextStyle(
                fontSize: fontSize,
                fontWeight: FontWeight.bold,
                color: const Color(0xffffffff)),
          );
        case 2:
          return PieChartSectionData(
            color: Colors.pinkAccent,
            value: radius * othersPC,
            title: '${othersPC.round()}%',
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
