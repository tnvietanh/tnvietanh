class Product {
  int quantity;
  String id;
  String title;
  double price;
  String desc;
  String imageUrl;

  Product({
    required this.quantity,
    required this.id,
    required this.title,
    required this.price,
    required this.desc,
    required this.imageUrl,
  });

  copyWith({
    String? id,
    String? title,
    double? price,
    String? desc,
    String? imageUrl,
    int? quantity,
  }) {
    return Product(
      id: id ?? this.id,
      title: title ?? this.title,
      price: price ?? this.price,
      desc: desc ?? this.desc,
      imageUrl: imageUrl ?? this.imageUrl,
      quantity: quantity ?? this.quantity,
    );
  }

  factory Product.fromJson(Map<String, dynamic> json) => Product(
        id: json["id"],
        title: json["title"],
        price: json["price"],
        desc: json["desc"],
        quantity: json["quantity"],
        imageUrl: json["imageUrl"],
      );
  Map<String, dynamic> toJson() => {
        'id': id,
        'title': title,
        'price': price,
        'desc': desc,
        'quantity': quantity,
        'imageUrl': imageUrl,
      };
}
