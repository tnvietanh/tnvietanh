import 'package:app_flutter/home_page.dart';
import 'package:app_flutter/provider.dart/bmi.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class BmiScreen extends StatelessWidget {
  const BmiScreen({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final bmiModelProvider = Provider.of<BmiModel>(context);
    final height = bmiModelProvider.height;
    final weight = bmiModelProvider.weight;
    final bmi = bmiModelProvider.bmi;
    final bmr = bmiModelProvider.bmr;
    return Scaffold(
      backgroundColor: Colors.grey[200],
      appBar: AppBar(
        title: const Text('Statistics'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            const SizedBox(
              height: 20,
            ),
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.12),
                    blurRadius: 5.0,
                    spreadRadius: 1.1,
                  ),
                ],
              ),
              height: 230,
              width: double.infinity,
              child: Column(
                children: [
                  const SizedBox(
                    height: 25,
                  ),
                  const Text(
                    'BMI',
                    style: TextStyle(fontSize: 30, fontWeight: FontWeight.w500),
                  ),
                  Text(
                    bmi.round().toString(),
                    style: const TextStyle(fontSize: 25),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  const Divider(),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(30, 20, 30, 0),
                    child: Row(
                      children: [
                        Column(
                          children: [
                            Text('${height.round()} cm',
                                style: const TextStyle(
                                  fontSize: 25,
                                )),
                            const Text('Height')
                          ],
                        ),
                        const Spacer(),
                        Column(
                          children: [
                            Text('${weight.round()} kg',
                                style: const TextStyle(
                                  fontSize: 25,
                                )),
                            const Text('Weight')
                          ],
                        )
                      ],
                    ),
                  )
                ],
              ),
            ),
            const Text(
              'Body Status',
              style: TextStyle(fontSize: 30, fontWeight: FontWeight.w700),
            ),
            const SizedBox(
              height: 20,
            ),
            Text("$bmr kcal"),
            ElevatedButton(
                onPressed: () {
                  Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const HomePage()));
                },
                child: const Text('Start'))
          ],
        ),
      ),
    );
  }
}
