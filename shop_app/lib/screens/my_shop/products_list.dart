import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'edit_product.dart';
import '../../provider/list_products.dart';
import '../../widgets/drawer_menu.dart';

class ProductsList extends StatelessWidget {
  static const routeName = '/product_list';

  const ProductsList({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const DrawerMenu(),
      appBar: AppBar(
        title: const Text('Your Products'),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.pushNamed(context, EditProduct.routeName);
            },
            icon: const Icon(Icons.add),
          ),
        ],
      ),
      body: Consumer<Products>(
        builder: (context, product, child) {
          return Container(
            padding: const EdgeInsets.all(10),
            child: ListView.builder(
              itemCount: product.items.length,
              itemBuilder: (context, index) {
                return Card(
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(5),
                        child: ClipOval(
                          child: Image.network(
                            product.items[index].imageUrl,
                            height: 60,
                            width: 60,
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      Container(
                        margin: const EdgeInsets.all(20),
                        child: Text(product.items[index].title),
                      ),
                      Expanded(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            IconButton(
                              icon: const Icon(
                                Icons.edit,
                                color: Colors.blue,
                              ),
                              onPressed: () {
                                Navigator.pushNamed(
                                    context, EditProduct.routeName,
                                    arguments: product.items[index]);
                              },
                            ),
                            IconButton(
                              icon: const Icon(
                                Icons.delete,
                                color: Colors.red,
                              ),
                              onPressed: () {
                                Provider.of<Products>(context, listen: false)
                                    .deleteProduct(product.items[index]);
                              },
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }
}
