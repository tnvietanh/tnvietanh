import 'package:app_flutter/model/workout.dart';
import 'package:flutter/material.dart';

class PracticedProvider extends ChangeNotifier {
  final List<WorkOut> _items = [];

  List<WorkOut> get items => _items;
  void removeProduct(WorkOut productItem) {
    _items.removeWhere((element) => productItem.id == element.id);
    notifyListeners();
  }

  void addToPracticed(WorkOut caloBurn) {
    _items.add(caloBurn);

    notifyListeners();
  }

  void clearPracticed() {
    _items.clear();
    notifyListeners();
  }

  double get totalKcalBurn {
    double total = 0;

    for (var element in _items) {
      total += element.kcalBurn * element.quantity;
    }
    return total;
  }
}
