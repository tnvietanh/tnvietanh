import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../models/product.dart';

class Products extends ChangeNotifier {
  final List<Product> _products = [];
  get items => [..._products];
  bool isLoading = false;

  Future<void> fetchProducts() async {
    isLoading = true;
    final url = Uri.parse(
        'https://imic-firebasedemo-default-rtdb.firebaseio.com/product.json');
    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body) as Map<String, dynamic>?;
        if (responseData != null) {
          final List<Product> loadedProducts = [];
          responseData.forEach((key, value) => loadedProducts.add(Product(
                id: key,
                title: value['title'],
                price: value['price'],
                desc: value['desc'],
                imageUrl: value['imageUrl'],
                quantity: value['quantity'],
              )));
          _products.clear();
          _products.addAll(loadedProducts);
        }
      }
    } catch (e) {
      rethrow;
    } finally {
      isLoading = false;
      notifyListeners();
    }
    notifyListeners();
  }

  Future<void> addProduct(Product product) async {
    final url = Uri.parse(
        'https://imic-firebasedemo-default-rtdb.firebaseio.com/product.json');
    try {
      final response = await http.post(url, body: jsonEncode(product.toJson()));
      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body) as Map<String, dynamic>?;
        if (responseData == null) {
          return;
        }
        _products.add(product.copyWith(id: responseData['name']));
      }
    } catch (e) {
      rethrow;
    }
    notifyListeners();
  }

  Future<void> updateProduct(Product product) async {
    final url = Uri.parse(
        'https://imic-firebasedemo-default-rtdb.firebaseio.com/product/${product.id}.json');
    try {
      final response = await http.put(url, body: jsonEncode(product.toJson()));
      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body) as Map<String, dynamic>?;
        if (responseData == null) {
          return;
        }
      }
      final prodIndex = _products.indexWhere((e) => e.id == product.id);
      _products[prodIndex] = product;
    } catch (e) {
      rethrow;
    }
    notifyListeners();
  }

  Future<void> deleteProduct(Product product) async {
    final url = Uri.parse(
        'https://imic-firebasedemo-default-rtdb.firebaseio.com/product/${product.id}.json');
    try {
      final response = await http.delete(url);
      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body) as Map<String, dynamic>?;
        if (responseData == null) {
          _products.removeWhere((e) => e.id == product.id);
        }
      }
    } catch (e) {
      rethrow;
    }
    notifyListeners();
  }
}
