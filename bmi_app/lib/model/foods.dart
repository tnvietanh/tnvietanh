class FoodItem {
  final String id;
  final String name;
  final double kiloCalories;
  final int quantity;
  final String image;
  final double protein;
  final double fat;
  final double carb;

  FoodItem({
    required this.id,
    required this.name,
    required this.image,
    required this.kiloCalories,
    required this.quantity,
    required this.protein,
    required this.fat,
    required this.carb,
  });
  copyWith({
    String? id,
    String? name,
    String? image,
    double? kiloCalories,
    int? quantity,
    double? protein,
    double? fat,
    double? carb,
  }) {
    return FoodItem(
      id: id ?? this.id,
      name: name ?? this.name,
      image: image ?? this.image,
      kiloCalories: kiloCalories ?? this.kiloCalories,
      quantity: quantity ?? this.quantity,
      protein: protein ?? this.protein,
      fat: fat ?? this.fat,
      carb: carb ?? this.carb,
    );
  }

  factory FoodItem.fromJson(Map<String, dynamic> json) {
    return FoodItem(
      id: json['id'] as String,
      name: json['name'] as String,
      image: json['image'] as String,
      kiloCalories: json['kiloCalories'] as double,
      quantity: json['quantity'] as int,
      protein: json['protein'] as double,
      fat: json['fat'] as double,
      carb: json['carb'] as double,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'kiloCalories': kiloCalories,
      'quantity': quantity,
      'protein': protein,
      'fat': fat,
      'carb': carb,
      'image': image,
    };
  }
}
