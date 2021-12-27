import '../models/product.dart';

class OrderedItem {
  final String id;
  final String name;
  final double price;
  final List<Product> products;
  final DateTime createdAt;
  final DateTime updatedAt;
  OrderedItem(
      {required this.id,
      required this.name,
      required this.products,
      required this.price,
      required this.createdAt,
      required this.updatedAt});

  factory OrderedItem.fromJson(Map<String, dynamic> json) {
    return OrderedItem(
        id: json['id'],
        name: json['name'],
        price: json['price'],
        products: (json['products'] as List<dynamic>)
            .map((e) => Product.fromJson(e))
            .toList(),
        createdAt: DateTime.parse(json['createdAt']),
        updatedAt: DateTime.parse(json['updatedAt']));
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'price': price,
      'products': products.map((e) => e.toJson()).toList(),
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String()
    };
  }

  copyWith({
    String? id,
    String? name,
    double? price,
    List<Product>? products,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return OrderedItem(
      id: id ?? this.id,
      name: name ?? this.name,
      price: price ?? this.price,
      products: products ?? this.products,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
