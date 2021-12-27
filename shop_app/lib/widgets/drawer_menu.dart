import 'package:flutter/material.dart';
import '../screens/my_shop/products_list.dart';
import '../screens/my_shop/grid_products.dart';
import '../screens/Fibonacci/fibonacci_test.dart';
import '../screens/movie/movie.dart';

class DrawerMenu extends StatelessWidget {
  const DrawerMenu({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final route = ModalRoute.of(context)!.settings.name;
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          const DrawerHeader(
            decoration: BoxDecoration(
              color: Colors.blue,
            ),
            child: Text('My Shop'),
          ),
          ListTile(
            title: const Text('Home'),
            onTap: () {
              route != UserProducts.routeName
                  ? Navigator.pushReplacementNamed(
                      context, UserProducts.routeName)
                  : Navigator.pop(context);
            },
          ),
          const Divider(),
          ListTile(
            title: const Text('Movies'),
            onTap: () {
              route != MoviesPage.routeName
                  ? Navigator.pushReplacementNamed(
                      context, MoviesPage.routeName)
                  : Navigator.pop(context);
            },
          ),
          const Divider(),
          ListTile(
            title: const Text('Fibonacci Test'),
            onTap: () {
              route != FibonacciTest.routeName
                  ? Navigator.pushReplacementNamed(
                      context, FibonacciTest.routeName)
                  : Navigator.pop(context);
            },
          ),
          const Divider(),
          ListTile(
            title: const Text('Administrator'),
            onTap: () {
              route != ProductsList.routeName
                  ? Navigator.pushReplacementNamed(
                      context, ProductsList.routeName)
                  : Navigator.pop(context);
            },
          ),
        ],
      ),
    );
  }
}
