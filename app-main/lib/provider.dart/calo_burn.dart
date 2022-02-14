import 'package:flutter/material.dart';

class CaloBurnProvider with ChangeNotifier {
  double _runBurn;
  double _cycleBurn;

  CaloBurnProvider(this._runBurn, this._cycleBurn);

  double get runBurn => _runBurn;
  double get cycleBurn => _cycleBurn;

  void setRunBurn(double runBurn) {
    _runBurn = runBurn;
    notifyListeners();
  }

  void setCycleBurn(double cycleBurn) {
    _cycleBurn = cycleBurn;
    notifyListeners();
  }
}
