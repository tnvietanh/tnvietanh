import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../provider/order_list.dart';
import '../../provider/ordered_products.dart';
import './ordered_list.dart';
import '/widgets/loading.dart';

class OrderProducts extends StatelessWidget {
  static const routeName = 'order_products';
  const OrderProducts({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final cartOrder = Provider.of<CartOrder>(context);
    final orderItems = Provider.of<CartOrder>(context).orderItems;
    final selectItems = Provider.of<CartOrder>(context).selectItems;
    final totalPrice = Provider.of<CartOrder>(context).totalPrice;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Your Cart'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(10),
        children: [
          Card(
            child: Padding(
              padding: const EdgeInsets.all(8),
              child: Row(
                children: [
                  const Expanded(
                    flex: 1,
                    child: Text(
                      'Total',
                      style: TextStyle(fontSize: 20),
                    ),
                  ),
                  Expanded(
                    flex: 6,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 5,
                            vertical: 5,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.blue,
                            borderRadius: BorderRadius.circular(50),
                          ),
                          child: Text(
                            '\$$totalPrice',
                            style: const TextStyle(
                              fontSize: 16,
                              color: Colors.white,
                            ),
                          ),
                        ),
                        const SizedBox(width: 5),
                        Provider.of<OrderProvider>(context, listen: true)
                                .isLoading
                            ? Container(
                                margin: const EdgeInsets.symmetric(
                                    vertical: 12, horizontal: 49),
                                width: 24,
                                height: 24,
                                child: const ColorLoader2(
                                    color1: Colors.deepOrangeAccent,
                                    color2: Colors.yellow,
                                    color3: Colors.lightGreen))
                            : ElevatedButton(
                                child: const Text(
                                  'ORDER NOW',
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: Colors.white,
                                  ),
                                ),
                                onPressed: () {
                                  if (orderItems.isNotEmpty) {
                                    Provider.of<OrderProvider>(context,
                                            listen: false)
                                        .addOrder(orderItems)
                                        .then((value) => Navigator.of(context)
                                            .pushNamed(OrderScreen.routeName));

                                    cartOrder.clearCart();
                                  } else {
                                    Navigator.of(context)
                                        .pushNamed(OrderScreen.routeName);
                                  }
                                },
                              ),
                        const SizedBox(width: 5),
                        OutlinedButton(
                          child: Text(
                            cartOrder.isDeleteMode
                                ? 'Delete\nSelected'
                                : 'Delete',
                            style: const TextStyle(
                              color: Colors.red,
                              fontSize: 14,
                            ),
                          ),
                          onPressed: () {
                            if (cartOrder.isDeleteMode) {
                              if (selectItems.isEmpty) {
                                cartOrder.toggleDeleteMode();
                                return;
                              }
                              final oldSelectedItems = [...selectItems];
                              cartOrder.deleteSelected();
                              cartOrder.toggleDeleteMode();
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: const Text('Deleted selected items'),
                                  action: SnackBarAction(
                                    label: 'Undo',
                                    onPressed: () {
                                      cartOrder.undoDelete(oldSelectedItems);
                                      cartOrder.toggleDeleteMode();
                                    },
                                  ),
                                ),
                              );
                            } else {
                              cartOrder.toggleDeleteMode();
                            }
                          },
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          SizedBox(
            height: MediaQuery.of(context).size.height - 170,
            child: ListView.builder(
              itemCount: orderItems.length,
              itemBuilder: (context, index) {
                return Card(
                  child: Row(
                    children: [
                      if (cartOrder.isDeleteMode)
                        Checkbox(
                          value: cartOrder.isSelected(orderItems[index]),
                          onChanged: (value) {
                            cartOrder.toggleSelected(orderItems[index]);
                          },
                        ),
                      Container(
                        margin: const EdgeInsets.all(5),
                        alignment: Alignment.center,
                        width: 60,
                        height: 60,
                        decoration: BoxDecoration(
                          color: Colors.blue,
                          borderRadius: BorderRadius.circular(50),
                        ),
                        child: Text(
                          '\$${orderItems[index].price.toString()}',
                          style: const TextStyle(color: Colors.white),
                        ),
                      ),
                      Expanded(
                        flex: 2,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              orderItems[index].title,
                              style: const TextStyle(
                                fontSize: 16,
                              ),
                            ),
                            Text(
                              'Total: \$' +
                                  (orderItems[index].price *
                                          orderItems[index].quantity)
                                      .toStringAsFixed(2),
                              style: const TextStyle(
                                color: Colors.grey,
                                fontSize: 14,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Expanded(
                        flex: 3,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            IconButton(
                              onPressed: () {
                                cartOrder.degreeProd(orderItems[index]);
                              },
                              icon: const Icon(
                                Icons.remove,
                                color: Colors.red,
                              ),
                            ),
                            Text(
                              'x' + orderItems[index].quantity.toString(),
                              textAlign: TextAlign.center,
                              style: const TextStyle(
                                fontSize: 16,
                              ),
                            ),
                            IconButton(
                              onPressed: () {
                                cartOrder.addOrder(orderItems[index]);
                              },
                              icon: const Icon(
                                Icons.add,
                                color: Colors.blue,
                              ),
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                );
              },
            ),
          )
        ],
      ),
    );
  }
}
