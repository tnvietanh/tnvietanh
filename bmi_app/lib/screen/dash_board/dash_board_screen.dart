import 'package:app_flutter/provider.dart/calo_burn.dart';
import 'package:app_flutter/provider.dart/food_chosed.dart';
import 'package:app_flutter/screen/dash_board/calories_burn.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class TabBarScreen extends StatelessWidget {
  static const routeName = '/tab';

  const TabBarScreen({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      initialIndex: 0,
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          centerTitle: true,
          title: const Text('Dash Board'),
          bottom: const TabBar(
            tabs: <Widget>[
              Tab(
                icon: Icon(Icons.fastfood_rounded),
              ),
              Tab(
                icon: Icon(Icons.beach_access_sharp),
              ),
            ],
          ),
        ),
        body: const TabBarView(
          children: <Widget>[CartScreen(), CaloriesBurnScreen()],
        ),
      ),
    );
  }
}

class CartScreen extends StatefulWidget {
  static const routeName = '/cart';
  const CartScreen({Key? key}) : super(key: key);

  @override
  _CartScreenState createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  @override
  Widget build(BuildContext context) {
    final cartProvider = Provider.of<CartProvider>(context);
    return Scaffold(
        body: Card(
            child: ListView.builder(
                itemCount: cartProvider.cartItems.length,
                itemBuilder: (context, index) {
                  final foods = cartProvider.cartItems[index];
                  return GestureDetector(
                    onTap: () {
                      showDialog(
                          context: context,
                          builder: (context) {
                            return AlertDialog(
                              title: Text(
                                  "${foods.name} (${foods.kiloCalories * foods.quantity})"),
                              content: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  IconButton(
                                      onPressed: () {
                                        cartProvider.degreeFood(
                                          foods,
                                        );
                                      },
                                      icon: const Icon(
                                        Icons.remove,
                                        color: Colors.red,
                                      )),
                                  const SizedBox(width: 5),
                                  Text(
                                    'x' + foods.quantity.toString(),
                                    textAlign: TextAlign.center,
                                    style: const TextStyle(
                                      fontSize: 16,
                                    ),
                                  ),
                                  const SizedBox(width: 5),
                                  IconButton(
                                      onPressed: () {
                                        cartProvider.addToCart(
                                          foods,
                                        );
                                      },
                                      icon: const Icon(Icons.add,
                                          color: Colors.blue)),
                                ],
                              ),
                              actions: [
                                ElevatedButton(
                                    onPressed: () {
                                      Navigator.of(context).pop();
                                    },
                                    child: const Text('OK'))
                              ],
                            );
                          });
                    },
                    child: Card(
                      child: Row(
                        children: [
                          Container(
                            margin: const EdgeInsets.all(5),
                            alignment: Alignment.center,
                            width: 60,
                            height: 60,
                            child: CircleAvatar(
                              backgroundImage: NetworkImage(foods.image),
                              radius: 28,
                            ),
                          ),
                          Expanded(
                            flex: 3,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  ' ${foods.name} x ${foods.quantity.toString()}',
                                  style: const TextStyle(
                                    fontSize: 16,
                                  ),
                                ),
                                Text(
                                  'Calo: ${(foods.kiloCalories * foods.quantity).toString()} kcal',
                                  style: const TextStyle(
                                    color: Colors.grey,
                                    fontSize: 14,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          IconButton(
                              onPressed: () {
                                cartProvider.removeFood(foods);
                              },
                              icon: const Icon(Icons.delete))
                        ],
                      ),
                    ),
                  );
                })));
  }
}
// Expanded(
//                           flex: 3,
//                           child: Row(
//                             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                             children: [
//                               IconButton(
//                                   onPressed: () {
//                                     cartProvider.degreeFood(
//                                       foods,
//                                     );
//                                   },
//                                   icon: const Icon(
//                                     Icons.remove,
//                                     color: Colors.red,
//                                   )),
//                               const SizedBox(width: 5),
//                               Text(
//                                 'x' + foods.quantity.toString(),
//                                 textAlign: TextAlign.center,
//                                 style: const TextStyle(
//                                   fontSize: 16,
//                                 ),
//                               ),
//                               const SizedBox(width: 5),
//                               IconButton(
//                                   onPressed: () {
//                                     cartProvider.addToCart(
//                                       foods,
//                                     );
//                                   },
//                                   icon: const Icon(Icons.add,
//                                       color: Colors.blue)),
//                             ],
//                           ),
//                         )