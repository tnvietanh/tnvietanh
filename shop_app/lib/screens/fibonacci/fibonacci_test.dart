import 'dart:math';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import '/widgets/drawer_menu.dart';

class FibonacciTest extends StatefulWidget {
  static const routeName = 'fibonacci_test';
  const FibonacciTest({Key? key}) : super(key: key);

  @override
  State<FibonacciTest> createState() => _FibonacciTestState();
}

class _FibonacciTestState extends State<FibonacciTest> {
  final _fibFormKey = GlobalKey<FormState>();
  final textController = TextEditingController();
  late bool isFib;

  void isFibNumber(double number) async {
    isFib = await compute(isFibonacci, number);
    setState(() {
      showDialog(
        context: context,
        builder: (BuildContext context) => AlertDialog(
          content: Text(
            isFib
                ? '${textController.text} is a Fibonacci number!'
                : '${textController.text} isn\'t a Fibonacci number!',
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 20),
          ),
        ),
      );
    });
  }

  static bool isFibonacci(double number) {
    if (number < 0) return false;
    bool isSquareNumber(double n) {
      var squareNumber = (sqrt(n) + 0.5).floor();
      return squareNumber * squareNumber == n;
    }

    return isSquareNumber(5 * number * number + 4) ||
        isSquareNumber(5 * number * number - 4);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const DrawerMenu(),
      appBar: AppBar(title: const Text('Fibonacci Test')),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Form(
            key: _fibFormKey,
            child: Column(
              children: [
                TextFormField(
                  decoration: const InputDecoration(
                    hintText: 'Input a number',
                  ),
                  keyboardType: TextInputType.number,
                  textInputAction: TextInputAction.done,
                  controller: textController,
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Please input a number!';
                    } else {
                      return null;
                    }
                  },
                ),
                const SizedBox(height: 10),
                ElevatedButton(
                  onPressed: () {
                    if (_fibFormKey.currentState?.validate() == true) {
                      isFibNumber(double.parse(textController.text));
                    }
                  },
                  child: const Text('Check'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
