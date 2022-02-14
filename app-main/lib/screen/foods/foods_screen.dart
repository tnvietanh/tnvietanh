import 'package:app_flutter/model/foods.dart';
import 'package:app_flutter/provider.dart/food_chosed.dart';
import 'package:app_flutter/provider.dart/food.dart';
import 'package:app_flutter/screen/dash_board/dash_board_screen.dart';
import 'package:app_flutter/screen/foods/detail_food.dart';
import 'package:app_flutter/screen/foods/foods_update_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CaloriesInScreen extends StatefulWidget {
  static const routeName = '/in';
  const CaloriesInScreen({Key? key}) : super(key: key);

  @override
  State<CaloriesInScreen> createState() => _CaloriesInScreenState();
}

/// AnimationControllers can be created with `vsync: this` because of TickerProviderStateMixin.
class _CaloriesInScreenState extends State<CaloriesInScreen> {
  Future<void> _refreshProducts(BuildContext context) async {
    await Provider.of<FoodProvider>(context, listen: false).fetchFoods();
  }

  @override
  void initState() {
    super.initState();
    _refreshProducts(context);
  }

  @override
  Widget build(BuildContext context) {
    final cartProvider = Provider.of<CartProvider>(context);
    final foodProvider = Provider.of<FoodProvider>(context);

    return Scaffold(
        backgroundColor: Colors.grey[100],
        appBar: AppBar(
          // backgroundColor: Colors.transparent,
          // elevation: 0,
          title: const Text('Calories in'),
          actions: [
            IconButton(
                onPressed: () async {
                  final result = await Navigator.pushNamed(
                      context, FoodUpdateScreen.routeName);
                  debugPrint('$result');
                },
                icon: const Icon(Icons.add)),
            CartWidget(
              count: cartProvider.cartItems.length,
              onTap: () {
                Navigator.pushNamed(context, TabBarScreen.routeName);
              },
            )
          ],
        ),
        body: RefreshIndicator(
          onRefresh: () => _refreshProducts(context),
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(10, 10, 10, 0),
              child: ListView.separated(
                physics: const BouncingScrollPhysics(),
                reverse: true,
                shrinkWrap: true,
                itemCount: foodProvider.items.length,
                itemBuilder: (context, index) {
                  final items = foodProvider.items[index];
                  return Card(
                    elevation: 10,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(50),
                    ),
                    child: ListTile(
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      DetailFood(items: items)));
                        },
                        leading: CircleAvatar(
                            backgroundImage: NetworkImage(items.image)),
                        title: Text(
                          items.name,
                          style: const TextStyle(
                              fontSize: 20, fontWeight: FontWeight.w800),
                        ),
                        subtitle:
                            Text('Calo: ${items.kiloCalories.round()}kcal'),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                              icon: const Icon(Icons.delete),
                              onPressed: () {
                                foodProvider.removeFood(items).then((value) {
                                  ScaffoldMessenger.of(context)
                                      .showSnackBar(const SnackBar(
                                    content: Text('Deleted item'),
                                    duration: Duration(microseconds: 1200),
                                  ));
                                });
                              },
                            ),
                            IconButton(
                              icon: const Icon(Icons.add),
                              onPressed: () {
                                cartProvider.addToCart(items);
                              },
                            ),
                          ],
                        )),
                  );
                },
                separatorBuilder: (BuildContext context, int index) =>
                    const SizedBox(
                  height: 5,
                ),
              ),
            ),
          ),
        ));
  }

  // void _showDialog(name, kcal, protein, fat, carb) {
  //   showDialog(
  //       context: context,
  //       builder: (context) {
  //         return AlertDialog(
  //           title: Text(name),
  //           content: Column(
  //             crossAxisAlignment: CrossAxisAlignment.start,
  //             children: [Text(kcal), Text(fat), Text(carb), Text(protein)],
  //           ),
  //           actions: [
  //             ElevatedButton(
  //                 onPressed: () {
  //                   Navigator.of(context).pop();
  //                 },
  //                 child: const Text('OK'))
  //           ],
  //         );
  //       });
  // }
}

// Widget SearchBar() {
//   return const TextField(
//     decoration: InputDecoration(
//         border: OutlineInputBorder(
//           borderRadius: BorderRadius.all(Radius.circular(50)),
//         ),
//         focusedBorder: OutlineInputBorder(
//           borderRadius: BorderRadius.all(Radius.circular(50)),
//         ),
//         fillColor: Colors.white,
//         filled: true,
//         contentPadding: EdgeInsets.symmetric(horizontal: 20),
//         prefixIcon: Icon(Icons.search),
//         hintText: 'Find For Nutrisi'),
//   );
// }

class CartWidget extends StatelessWidget {
  final int count;
  final VoidCallback onTap;

  const CartWidget({
    Key? key,
    required this.count,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Stack(
        children: [
          IconButton(
              onPressed: onTap, icon: const Icon(Icons.fastfood_rounded)),
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
                '$count',
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
    );
  }
}
