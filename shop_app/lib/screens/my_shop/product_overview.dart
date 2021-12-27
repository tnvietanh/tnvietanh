import 'package:flutter/material.dart';
import '../../models/product.dart';

class ProductOverview extends StatelessWidget {
  static const routeName = '/product_overview';
  const ProductOverview({Key? key, required this.product}) : super(key: key);
  final Product product;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Stack(
            children: [
              Container(
                height: 350,
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: NetworkImage(product.imageUrl),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              Positioned(
                top: 25,
                left: 5,
                child: IconButton(
                  color: Colors.white,
                  onPressed: () => Navigator.pop(context),
                  icon: const Icon(Icons.arrow_back),
                ),
              ),
              Positioned(
                left: 30,
                bottom: 20,
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.black45,
                    border: Border.all(color: Colors.white, width: 1),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(3),
                    child: Text(
                      product.title,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 30,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 15),
          Text('\$${product.price}',
              style: const TextStyle(
                color: Colors.grey,
                fontSize: 20,
              )),
          const SizedBox(height: 15),
          Padding(
              padding: const EdgeInsets.only(left: 20, right: 20),
              child: Text(product.desc))
        ],
      ),
    );
  }
}
