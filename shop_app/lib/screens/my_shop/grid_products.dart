import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'product_overview.dart';
import 'order_cart.dart';
import '../../provider/order_list.dart';
import '../../widgets/drawer_menu.dart';
import '../../provider/list_products.dart';
import '../../widgets/loading.dart';

class UserProducts extends StatefulWidget {
  static const routeName = '/user_products';
  const UserProducts({Key? key}) : super(key: key);

  @override
  State<UserProducts> createState() => _UserProductsState();
}

class _UserProductsState extends State<UserProducts> {
  @override
  void initState() {
    super.initState();
    _refreshProducts(context);
  }

  Future<void> _refreshProducts(BuildContext context) async {
    await Provider.of<Products>(context, listen: false).fetchProducts();
  }

  @override
  Widget build(BuildContext context) {
    final orderItems = Provider.of<CartOrder>(context).orderItems;
    final deviceSize = MediaQuery.of(context).size;
    final productsProvider = Provider.of<Products>(context);
    return Scaffold(
      drawer: const DrawerMenu(),
      appBar: AppBar(
        title: const Text('My Shop'),
        actions: [
          Stack(
            children: [
              IconButton(
                onPressed: () {
                  Navigator.pushNamed(context, OrderProducts.routeName);
                },
                icon: const Icon(Icons.shopping_cart),
              ),
              if (orderItems.isNotEmpty)
                Positioned(
                  right: 5,
                  top: 10,
                  child: Container(
                    padding: const EdgeInsets.all(1),
                    decoration: BoxDecoration(
                      color: Colors.red,
                      borderRadius: BorderRadius.circular(8.5),
                    ),
                    constraints: const BoxConstraints(
                      minWidth: 15,
                      minHeight: 15,
                    ),
                    child: Text(
                      orderItems.length.toString(),
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 10,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                )
            ],
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () => _refreshProducts(context),
        child: productsProvider.isLoading
            ? const Center(
                child: ColorLoader2(
                    color1: Colors.redAccent,
                    color2: Colors.green,
                    color3: Colors.amber))
            : GridView.builder(
                padding: const EdgeInsets.all(15),
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: deviceSize.width > 600 ? 3 : 2,
                  mainAxisSpacing: 20,
                  crossAxisSpacing: 20,
                  childAspectRatio: 3 / 2,
                ),
                itemCount: productsProvider.items.length,
                itemBuilder: (context, index) {
                  final quantityOrderedProd = orderItems
                      .firstWhere(
                        (item) => item.id == productsProvider.items[index].id,
                        orElse: () =>
                            productsProvider.items[index].copyWith(quantity: 0),
                      )
                      .quantity;
                  return ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: GridTile(
                      child: GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => ProductOverview(
                                product: productsProvider.items[index],
                              ),
                            ),
                          );
                        },
                        child: Image(
                          image: NetworkImage(
                              productsProvider.items[index].imageUrl),
                          fit: BoxFit.cover,
                        ),
                      ),
                      footer: GridTileBar(
                        backgroundColor: Colors.black87,
                        leading: IconButton(
                          color: Colors.red,
                          onPressed: () {},
                          icon: const Icon(Icons.favorite),
                        ),
                        title: Text(
                          productsProvider.items[index].title,
                          textAlign: TextAlign.center,
                        ),
                        trailing: InkWell(
                          onTap: () {
                            Provider.of<CartOrder>(context, listen: false)
                                .addOrder(productsProvider.items[index]);
                          },
                          child: Stack(
                            children: [
                              IconButton(
                                onPressed: () {
                                  Provider.of<CartOrder>(context, listen: false)
                                      .addOrder(productsProvider.items[index]);
                                },
                                color: Colors.blue,
                                icon: const Icon(Icons.shopping_cart),
                              ),
                              if (quantityOrderedProd > 0)
                                Positioned(
                                  right: 5,
                                  top: 10,
                                  child: Container(
                                    padding: const EdgeInsets.all(1),
                                    decoration: BoxDecoration(
                                      color: Colors.red,
                                      borderRadius: BorderRadius.circular(8.5),
                                    ),
                                    constraints: const BoxConstraints(
                                      minWidth: 15,
                                      minHeight: 15,
                                    ),
                                    child: Text(
                                      quantityOrderedProd.toString(),
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 10,
                                      ),
                                      textAlign: TextAlign.center,
                                    ),
                                  ),
                                ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  );
                }),
      ),
    );
  }
}
