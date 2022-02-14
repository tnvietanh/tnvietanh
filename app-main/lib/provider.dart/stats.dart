// import 'package:app_flutter/model/stats.dart';
// import 'package:flutter/material.dart';
// import 'dart:convert';
// import 'package:http/http.dart' as http;

// class UserStatsProvider extends ChangeNotifier {
//   final List<BmiModel> _items;

//   List<BmiModel> get items => _items;

//   String? authToken;
//   String? userId;

//   UserStatsProvider(this._items);

//   void updateAuthToken(String? token, String? userID) {
//     authToken = token;
//     userId = userID;
//   }

//   Future<void> fetchProducts([bool filterByUser = false]) async {
//     try {
//       final url =
//           'https://flutter1-d9f6d-default-rtdb.firebaseio.com/user-stat/$userId.json?auth=$authToken';
//       final response = await http.get(Uri.parse(url));
//       if (response.statusCode == 200) {
//         // success requesst
//         final extractedData =
//             json.decode(response.body) as Map<String, dynamic>?;
//         if (extractedData == null) {
//           return;
//         }

//         _items.clear();
//         extractedData.forEach((key, value) =>
//             _items.add(BmiModel.fromJson(value).copyWith(id: key)));

//         notifyListeners();
//       }
//     } catch (e) {
//       rethrow;
//     }
//   }

//   Future<void> addProduct(BmiModel productItem) async {
//     try {
//       final url = Uri.parse(
//           'https://flutter1-d9f6d-default-rtdb.firebaseio.com/user-stat/$userId.json?auth=$authToken');
//       final response =
//           await http.post(url, body: jsonEncode(productItem.toJson()));
//       if (response.statusCode == 200) {
//         // success requesst
//         final extractedData =
//             json.decode(response.body) as Map<String, dynamic>?;
//         if (extractedData == null) {
//           return;
//         }
//         _items.add(productItem.copyWith(id: extractedData['name']));
//         notifyListeners();
//       }
//     } catch (e) {
//       rethrow;
//     }
//   }

//   Future<void> updateProduct(BmiModel productItem) async {
//     try {
//       final url = Uri.parse(
//           'https://flutter1-d9f6d-default-rtdb.firebaseio.com/user-stat/$userId.json?auth=$authToken');
//       final response =
//           await http.put(url, body: jsonEncode(productItem.toJson()));
//       if (response.statusCode == 200) {
//         // success requesst
//         final extractedData =
//             json.decode(response.body) as Map<String, dynamic>?;
//         if (extractedData == null) {
//           return;
//         }

//         notifyListeners();
//       }
//     } catch (e) {
//       rethrow;
//     }
//   }
// }
