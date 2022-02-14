import 'package:app_flutter/model/foods.dart';
import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

// final List<FoodItem> _foodItems = <FoodItem>[
//   FoodItem(
//       id: '1',
//       name: 'Banh Bao',
//       kiloCalories: 219,
//       quantity: 1,
//       // image:
//       //     'https://flutter.github.io/assets-for-api-docs/assets/widgets/owl.jpg',
//       protein: 10.1,
//       fat: 5,
//       carb: 47.5),
//   FoodItem(
//       id: '2',
//       name: 'Banh Bong Lan Kem',
//       kiloCalories: 260,
//       quantity: 1,
//       protein: 5.2,
//       fat: 9.0,
//       carb: 38.9),
//   FoodItem(
//       id: '3',
//       name: 'Banh Gio',
//       kiloCalories: 216,
//       quantity: 1,
//       protein: 9.3,
//       fat: 7.1,
//       carb: 28.5),
//   FoodItem(
//       id: '4',
//       name: 'Pa Te',
//       kiloCalories: 326,
//       quantity: 1,
//       protein: 10.8,
//       fat: 24.6,
//       carb: 15.4),
// ];

class FoodProvider extends ChangeNotifier {
  final List<FoodItem> _items; // init default product items
  String? authToken;
  String? userId;

  FoodProvider(this._items);

  void updateAuthToken(String? token, String? userID) {
    authToken = token;
    userId = userID;
  }

  List<FoodItem> get items => _items;

  Future<void> fetchFoods([bool filterByUser = false]) async {
    try {
      final filterString =
          filterByUser ? 'orderBy="creatorId"&equalTo="$userId"' : '';
      final url =
          'https://flutter1-d9f6d-default-rtdb.firebaseio.com/foods.json?auth=$authToken&$filterString';
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        final extractedData =
            json.decode(response.body) as Map<String, dynamic>?;
        if (extractedData == null) {
          return;
        }
        _items.clear();
        extractedData.forEach((key, value) =>
            _items.add(FoodItem.fromJson(value).copyWith(id: key)));
        print('extractedData');
        notifyListeners();
      }
    } catch (e) {
      rethrow;
    }
  }

  Future<void> addFood(FoodItem productItem) async {
    try {
      final url = Uri.parse(
          'https://flutter1-d9f6d-default-rtdb.firebaseio.com/foods.json?auth=$authToken');
      final response =
          await http.post(url, body: jsonEncode(productItem.toJson()));
      if (response.statusCode == 200) {
        // success requesst
        final extractedData =
            json.decode(response.body) as Map<String, dynamic>?;
        if (extractedData == null) {
          return;
        }
        _items.add(productItem.copyWith(id: extractedData['name']));
        notifyListeners();
      }
    } catch (e) {
      rethrow;
    }
  }

  Future<void> removeFood(FoodItem productItem) async {
    try {
      final url = Uri.parse(
          'https://flutter1-d9f6d-default-rtdb.firebaseio.com/foods/${productItem.id}.json?auth=$authToken');
      final response = await http.delete(url);
      if (response.statusCode == 200) {
        // success requesst
        final extractedData =
            json.decode(response.body) as Map<String, dynamic>?;
        if (extractedData == null) {
          return;
        }
        _items.removeWhere((element) => productItem.id == element.id);
        notifyListeners();
      }
    } catch (e) {
      rethrow;
    }
  }
}
