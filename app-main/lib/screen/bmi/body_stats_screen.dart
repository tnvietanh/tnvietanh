import 'package:app_flutter/provider.dart/bmi.dart';
import 'package:app_flutter/screen/bmi/bmi_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class BmiCaculator extends StatefulWidget {
  static const routeName = '/bmi';
  const BmiCaculator({Key? key}) : super(key: key);

  @override
  _BmiCaculatorState createState() => _BmiCaculatorState();
}

class _BmiCaculatorState extends State<BmiCaculator> {
  double bmiResult = 0;
  double bmrResult = 0;
  double _heightOfUser = 100.0;
  double _weightOfUser = 40.0;
  String textResult = "";
  int _genderIndex = 0;
  int age = 20;
  String level = 'Normal';
  double levelAct = 1.55;
  // BmiModel? _bmiModel;

  @override
  Widget build(BuildContext context) {
    final bmiModelProvider = Provider.of<BmiModel>(context, listen: false);
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(15, 55, 15, 10),
          child: Column(
            children: [
              Row(
                children: [
                  radioButton('Man', Colors.blue, 0),
                  radioButton('Woman', Colors.pink, 1)
                ],
              ),
              const SizedBox(
                height: 32,
              ),
              const Text(
                "Height (cm)",
                style: TextStyle(
                    color: Colors.grey,
                    fontSize: 24,
                    fontWeight: FontWeight.w400),
              ),
              Container(
                padding: const EdgeInsets.only(left: 16, right: 16),
                child: Slider(
                  min: 80.0,
                  max: 250.0,
                  onChanged: (height) {
                    setState(() {
                      _heightOfUser = height;
                    });
                  },
                  value: _heightOfUser,
                  divisions: 100,
                  activeColor: Colors.blue,
                  label: "$_heightOfUser",
                ),
              ),
              Text(
                "$_heightOfUser cm",
                style:
                    const TextStyle(fontSize: 18, fontWeight: FontWeight.w900),
              ),
              const SizedBox(
                height: 24,
              ),
              const Text(
                "Weight (kg)",
                style: TextStyle(
                    color: Colors.grey,
                    fontSize: 24,
                    fontWeight: FontWeight.w400),
              ),
              Container(
                padding: const EdgeInsets.only(left: 16, right: 16),
                child: Slider(
                  min: 30.0,
                  max: 120.0,
                  onChanged: (height) {
                    setState(() {
                      _weightOfUser = height;
                    });
                  },
                  value: _weightOfUser,
                  divisions: 100,
                  activeColor: Colors.blue,
                  label: "$_weightOfUser",
                ),
              ),
              Text(
                "$_weightOfUser kg",
                style:
                    const TextStyle(fontSize: 18, fontWeight: FontWeight.w900),
              ),
              const SizedBox(
                height: 16,
              ),
              Row(
                children: <Widget>[
                  Expanded(
                    child: Container(
                      height: 140,
                      child: Card(
                        color: Colors.grey[300],
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            const Text(
                              'AGE',
                              style: TextStyle(
                                fontSize: 20.0,
                              ),
                            ),
                            Text(
                              age.toString(),
                              style: const TextStyle(
                                  fontSize: 50.0, fontWeight: FontWeight.w900),
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                IconButton(
                                  icon: const Icon(Icons.remove),
                                  onPressed: () {
                                    setState(() {
                                      age--;
                                    });
                                  },
                                ),
                                const SizedBox(width: 10.0),
                                IconButton(
                                  icon: const Icon(Icons.add),
                                  onPressed: () {
                                    setState(() {
                                      age++;
                                    });
                                  },
                                ),
                              ],
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: GestureDetector(
                      onTap: () {
                        showDialog<String>(
                            context: context,
                            builder: (BuildContext context) => SimpleDialog(
                                  title: const Text('Activity Level'),
                                  children: [
                                    ListTile(
                                      title: const Text('Light'),
                                      subtitle: const Text('1-3 times on week'),
                                      onTap: () {
                                        setState(() {
                                          level = 'Light';
                                          levelAct = 1.375;
                                        });
                                        Navigator.pop(context);
                                      },
                                    ),
                                    const Divider(),
                                    ListTile(
                                      title: const Text('Normal'),
                                      subtitle: const Text('3-5 times on week'),
                                      onTap: () {
                                        setState(() {
                                          level = 'Normal';
                                          levelAct = 1.55;
                                        });
                                        Navigator.pop(context);
                                      },
                                    ),
                                    const Divider(),
                                    ListTile(
                                      title: const Text('Dynamic'),
                                      subtitle: const Text('6-7 times on week'),
                                      onTap: () {
                                        setState(() {
                                          level = 'Dynamic';
                                          levelAct = 1.725;
                                        });
                                        Navigator.pop(context);
                                      },
                                    )
                                  ],
                                ));
                      },
                      child: Container(
                        height: 140,
                        child: Card(
                          color: Colors.grey[300],
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Text(
                                'ACTIVITY LEVEL :',
                                style: TextStyle(
                                  fontSize: 20.0,
                                ),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                level,
                                style: const TextStyle(
                                    fontSize: 30.0,
                                    fontWeight: FontWeight.w900),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(
                height: 20,
              ),
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: () {
                    bmiModelProvider.setHeight(_heightOfUser);
                    bmiModelProvider.setWeight(_weightOfUser);
                    bmiModelProvider.setAge(age);
                    bmiModelProvider.setGenderIndex(_genderIndex);
                    setState(() {
                      bmiResult = _weightOfUser /
                          ((_heightOfUser / 100) * (_heightOfUser / 100));
                      bmiModelProvider.setBmi(bmiResult);
                      if (_genderIndex == 0) {
                        bmrResult = (66 +
                                (13.7 * _weightOfUser) +
                                (5 * _heightOfUser) -
                                (6.8 * age)) *
                            levelAct;
                      } else {
                        bmrResult = (655 +
                                (9.6 * _weightOfUser) +
                                (1.8 * _heightOfUser) -
                                (4.7 * age)) *
                            levelAct;
                      }
                      bmiModelProvider.setBmr(bmrResult);
                    });

                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const BmiScreen()));
                  },
                  child: const Text(
                    'Result',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ),
              const SizedBox(
                height: 25,
              ),
            ],
          ),
        ),
      ),
    );
  }

  // void saveData() {
  //   final _bmiModel = BmiModel(
  //       height: _heightOfUser,
  //       weight: _weightOfUser,
  //       age: age,
  //       bmi: bmiResult,
  //       bmr: bmrResult,
  //       genderIndex: _genderIndex);
  //   final productProvider =
  //       Provider.of<UserStatsProvider>(context, listen: false);
  //   productProvider.addProduct(_bmiModel);
  //   Navigator.push(
  //       context,
  //       MaterialPageRoute(
  //           builder: (context) => BmiScreen(bmiModel: _bmiModel)));
  // }

  void changeIndex(int index) {
    setState(() {
      _genderIndex = index;
    });
  }

  Widget radioButton(String value, Color color, int index) {
    return Expanded(
      child: Container(
        height: 100,
        margin: const EdgeInsets.symmetric(horizontal: 15.0),
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            primary: _genderIndex == index ? color : Colors.grey[200],
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
          ),
          onPressed: () {
            changeIndex(index);
          },
          child: Text(
            value,
            style: TextStyle(
                color: _genderIndex == index ? Colors.white : color,
                fontSize: 22,
                fontWeight: FontWeight.bold),
          ),
        ),
      ),
    );
  }
}
