import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../models/ordered.dart';
import '../../provider/ordered_products.dart';
import '../../widgets/loading.dart';

class OrderScreen extends StatelessWidget {
  static const routeName = '/ordered_screen';
  const OrderScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Order Screen'),
      ),
      body: FutureBuilder<List<OrderedItem>>(
          future:
              Provider.of<OrderProvider>(context, listen: false).fetchOrders(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: ColorLoader2(
                    color1: Colors.redAccent,
                    color2: Colors.green,
                    color3: Colors.amber),
              );
            }
            if (snapshot.hasError) {
              return Center(
                child: Text('Error: ${snapshot.error}'),
              );
            }
            final orderItems = snapshot.data ?? [];
            return ListView.separated(
                itemBuilder: (context, index) {
                  final orderItem = orderItems[index];
                  return Column(
                    children: [
                      ListTile(
                        title: Text(orderItem.name,
                            style: const TextStyle(fontSize: 20)),
                        subtitle: Text('Total: ${orderItem.price}\$'),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 20),
                        child: ListView.builder(
                          physics: const ClampingScrollPhysics(),
                          shrinkWrap: true,
                          itemCount: orderItem.products.length,
                          itemBuilder: (context, productIndex) {
                            final product = orderItem.products[productIndex];
                            return ListTile(
                              title:
                                  Text('${productIndex + 1}. ${product.title}'),
                              subtitle: Text(
                                  '${product.price}\$ x ${product.quantity}'),
                            );
                          },
                        ),
                      ),
                    ],
                  );
                },
                separatorBuilder: (context, index) => const Divider(
                      thickness: 2,
                      color: Colors.blue,
                      indent: 20,
                      endIndent: 20,
                    ),
                itemCount: orderItems.length);
          }),
    );
  }
}
