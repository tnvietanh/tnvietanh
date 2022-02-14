import 'package:app_flutter/model/workout.dart';
import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

final List<WorkOut> _exercises = <WorkOut>[
  WorkOut(id: '1', kcalBurn: 120, name: 'Yoga', quantity: 1),
  WorkOut(id: '2', kcalBurn: 800, name: 'Play with Neighbour Dog', quantity: 1),
  WorkOut(id: '3', kcalBurn: 900, name: 'Chase with Police', quantity: 1)
];

class WorkOutProvider extends ChangeNotifier {
  final List<WorkOut> _items = [];

  List<WorkOut> get items => _items;

  String? authToken;
  String? userId;

  WorkOutProvider(_items);

  void updateAuthToken(String? token, String? userID) {
    authToken = token;
    userId = userID;
  }

  Future<void> fetchProducts([bool filterByUser = false]) async {
    try {
      final filterString =
          filterByUser ? 'orderBy="creatorId"&equalTo="$userId"' : '';
      final url =
          'https://flutter1-d9f6d-default-rtdb.firebaseio.com/workouts.json?auth=$authToken&$filterString';
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        // success requesst
        final extractedData =
            json.decode(response.body) as Map<String, dynamic>?;
        if (extractedData == null) {
          return;
        }
        _items.clear();
        extractedData.forEach((key, value) =>
            _items.add(WorkOut.fromJson(value).copyWith(id: key)));
        notifyListeners();
      }
    } catch (e) {
      rethrow;
    }
  }

  Future<void> addProduct(WorkOut productItem) async {
    try {
      final url = Uri.parse(
          'https://flutter1-d9f6d-default-rtdb.firebaseio.com/workouts.json?auth=$authToken');
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

  Future<void> removeProduct(WorkOut productItem) async {
    try {
      final url = Uri.parse(
          'https://flutter1-d9f6d-default-rtdb.firebaseio.com/workouts/${productItem.id}.json?auth=$authToken');
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
