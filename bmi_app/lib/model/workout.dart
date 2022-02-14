class WorkOut {
  final String id;
  final String name;
  final double kcalBurn;
  final int quantity;
  WorkOut(
      {required this.kcalBurn,
      required this.name,
      required this.id,
      required this.quantity});
  copyWith({
    String? id,
    String? name,
    double? kcalBurn,
    int? quantity,
    String? description,
  }) {
    return WorkOut(
      id: id ?? this.id,
      name: name ?? this.name,
      kcalBurn: kcalBurn ?? this.kcalBurn,
      quantity: quantity ?? this.quantity,
    );
  }

  factory WorkOut.fromJson(Map<String, dynamic> json) {
    return WorkOut(
        id: json['id'] as String,
        name: json['name'] as String,
        kcalBurn: json['kcalBurn'] as double,
        quantity: json['quantity'] as int);
  }

  Map<String, dynamic> toJson() {
    return {'id': id, 'name': name, 'kcalBurn': kcalBurn, 'quantity': quantity};
  }
}
