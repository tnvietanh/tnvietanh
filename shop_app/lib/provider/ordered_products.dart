import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:faker/faker.dart';
import 'package:http/http.dart' as http;
import '../models/ordered.dart';
import '../models/product.dart';

class OrderProvider extends ChangeNotifier {
  bool _isLoading = false;
  bool get isLoading => _isLoading;

  final List<OrderedItem> _items = [];
  List<OrderedItem> get items => [..._items];

  Future<List<OrderedItem>> fetchOrders() async {
    try {
      final response = await http.get(Uri.parse(
          'https://imic-firebasedemo-default-rtdb.firebaseio.com/orders.json'));
      final parsed = json.decode(response.body) as Map<String, dynamic>?;
      final List<OrderedItem> loadedOrders = [];
      parsed?.forEach((key, value) {
        loadedOrders.add(OrderedItem.fromJson(value).copyWith(id: key));
      });
      return loadedOrders;
    } catch (error) {
      rethrow;
    }
  }

  Future addOrder(List<Product> productItems) async {
    try {
      _isLoading = true;
      notifyListeners();
      final order = OrderedItem(
        id: DateTime.now().toString(),
        name: faker.sport.name(),
        price: productItems.fold(0, (previousValue, element) {
          return double.parse((previousValue + element.price * element.quantity)
              .toStringAsFixed(2));
        }),
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
        products: [...productItems],
      );
      final url = Uri.parse(
          'https://imic-firebasedemo-default-rtdb.firebaseio.com/orders.json');
      final response = await http.post(url, body: jsonEncode(order.toJson()));
      if (response.statusCode == 200) {
        final responseData =
            json.decode(response.body) as Map<String, dynamic>?;
        if (responseData == null) {
          return;
        }
        _items.add(order.copyWith(id: responseData['name']));
        notifyListeners();
      }
    } catch (e) {
      rethrow;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
