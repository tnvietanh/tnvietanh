import 'package:flutter/material.dart';

class BmiModel with ChangeNotifier {
  double _height;
  double _weight;
  double _bmi;
  int _age;
  int _genderIndex;
  double _bmr;

  BmiModel(this._height, this._weight, this._age, this._bmi, this._bmr,
      this._genderIndex);

  double get height => _height;
  double get weight => _weight;
  double get bmi => _bmi;
  double get bmr => _bmr;
  int get age => _age;
  int get genderIndex => _genderIndex;

  void setHeight(double height) {
    _height = height;
    notifyListeners();
  }

  void setWeight(double weight) {
    _weight = weight;
    notifyListeners();
  }

  void setBmi(double bmi) {
    _bmi = bmi;
    notifyListeners();
  }

  void setBmr(double bmr) {
    _bmr = bmr;
    notifyListeners();
  }

  void setAge(int age) {
    _age = age;
    notifyListeners();
  }

  void setGenderIndex(int genderIndex) {
    _genderIndex = genderIndex;
    notifyListeners();
  }
}
