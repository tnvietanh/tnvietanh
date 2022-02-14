import 'package:app_flutter/model/foods.dart';
import 'package:flutter/material.dart';

class CartProvider extends ChangeNotifier {
  final List<FoodItem> _items = [];

  List<FoodItem> get cartItems => _items;

  void addToCart(FoodItem foodItem) {
    final foodIndex = _items.indexWhere((element) => element.id == foodItem.id);
    if (foodIndex < 0) {
      _items.add(foodItem);
    } else {
      _items[foodIndex] =
          foodItem.copyWith(quantity: _items[foodIndex].quantity + 1);
    }
    notifyListeners();
  }

  void degreeFood(FoodItem foodItem) {
    final foodIndex = _items.indexWhere((element) => element.id == foodItem.id);
    if (_items[foodIndex].quantity > 1) {
      _items[foodIndex] =
          foodItem.copyWith(quantity: _items[foodIndex].quantity - 1);
    } else {
      _items.removeAt(foodIndex);
    }
    notifyListeners();
  }

  void clearCart() {
    _items.clear();
    notifyListeners();
  }

  void removeFood(FoodItem foodItem) {
    _items.removeWhere((element) => foodItem.id == element.id);
    notifyListeners();
  }

  double get totalKcal {
    double total = 0;

    for (var element in _items) {
      total += element.kiloCalories * element.quantity;
    }
    return total;
  }

  double get totalProtein {
    double total = 0;

    for (var element in _items) {
      total += element.protein * element.quantity;
    }
    return total;
  }

  double get totalFat {
    double total = 0;

    for (var element in _items) {
      total += element.fat * element.quantity;
    }
    return total;
  }

  double get totalCarb {
    double total = 0;

    for (var element in _items) {
      total += element.carb * element.quantity;
    }
    return total;
  }
}
