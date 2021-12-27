import 'package:flutter/material.dart';
import '../models/product.dart';

class CartOrder extends ChangeNotifier {
  final List<Product> _orderProducts = [];
  final List<Product> _selectProducts = [];
  bool isDeleteMode = false;

  List<Product> get orderItems => [..._orderProducts];
  List<Product> get selectItems => [..._selectProducts];

  get totalPrice {
    double _total = 0;
    for (var element in _orderProducts) {
      _total += element.price * element.quantity;
    }
    return _total.toStringAsFixed(2);
  }

  void addOrder(Product orderProduct) {
    final prodIndex = _orderProducts.indexWhere((e) => e.id == orderProduct.id);
    if (prodIndex < 0) {
      _orderProducts.add(orderProduct.copyWith());
    } else {
      orderProduct.copyWith(quantity: _orderProducts[prodIndex].quantity++);
    }
    notifyListeners();
  }

  void degreeProd(Product orderProduct) {
    final productIndex =
        _orderProducts.indexWhere((e) => e.id == orderProduct.id);

    if (orderProduct.quantity > 1) {
      orderProduct.copyWith(quantity: _orderProducts[productIndex].quantity--);
    } else {
      _orderProducts.removeAt(productIndex);
    }
    notifyListeners();
  }

  void toggleSelected(Product orderProduct) {
    final productIndex =
        _selectProducts.indexWhere((e) => e.id == orderProduct.id);
    if (productIndex < 0) {
      _selectProducts.add(orderProduct);
    } else {
      _selectProducts.removeWhere((e) => e.id == orderProduct.id);
    }
    notifyListeners();
  }

  void toggleDeleteMode() {
    isDeleteMode = !isDeleteMode;
    notifyListeners();
  }

  void deleteSelected() {
    for (var element in _selectProducts) {
      _orderProducts.removeWhere((e) => e.id == element.id);
    }
    _selectProducts.clear();
    notifyListeners();
  }

  void undoDelete(List<Product> _oldSelectedItems) {
    _orderProducts.addAll(_oldSelectedItems);
    _selectProducts.addAll(_oldSelectedItems);
    notifyListeners();
  }

  bool isSelected(Product orderProduct) {
    return _selectProducts.indexWhere((e) => e.id == orderProduct.id) >= 0;
  }

  void clearCart() {
    isDeleteMode = false;
    _orderProducts.clear();
    _selectProducts.clear();
    notifyListeners();
  }
}
