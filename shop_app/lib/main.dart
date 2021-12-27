import 'package:flutter/material.dart';
import 'package:my_shop/screens/my_shop/ordered_list.dart';
import 'package:provider/provider.dart';
import 'authentication.dart';
import './provider/list_products.dart';
import './provider/order_list.dart';
import './provider/list_movie.dart';
import 'screens/my_shop/edit_product.dart';
import 'screens/my_shop/order_cart.dart';
import 'screens/my_shop/grid_products.dart';
import 'screens/my_shop/products_list.dart';
import './screens/movie/movie.dart';
import './provider/auth.dart';
import './provider/ordered_products.dart';
import './screens/Fibonacci/fibonacci_test.dart';

void main() => runApp(
      MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (_) => Products()),
          ChangeNotifierProvider(create: (_) => CartOrder()),
          ChangeNotifierProvider(create: (_) => OrderProvider()),
          ChangeNotifierProvider(create: (_) => Movies()),
          ChangeNotifierProvider(create: (_) => AuthProvider()),
        ],
        child: const MyApp(),
      ),
    );

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Provider.of<AuthProvider>(context, listen: true).token != null
          ? const UserProducts()
          : const HomePage(),
      onGenerateRoute: generateRoute,
      routes: {
        'home': (_) => const HomePage(),
        ProductsList.routeName: (context) => const ProductsList(),
        EditProduct.routeName: (context) => const EditProduct(),
        UserProducts.routeName: (context) => const UserProducts(),
        OrderProducts.routeName: (context) => const OrderProducts(),
        OrderScreen.routeName: (context) => const OrderScreen(),
        MoviesPage.routeName: (context) => const MoviesPage(),
        FibonacciTest.routeName: (context) => const FibonacciTest(),
      },
    );
  }

  Route<dynamic>? generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case 'home':
        return MaterialPageRoute(
          builder: (context) => const HomePage(),
          settings: settings,
        );
      case '/user_products':
        return MaterialPageRoute(
          builder: (context) => const UserProducts(),
          settings: settings,
        );
      case '/product_list':
        return MaterialPageRoute(
          builder: (context) => const ProductsList(),
          settings: settings,
        );
      case '/edit_product':
        return MaterialPageRoute(
          builder: (context) => const EditProduct(),
          settings: settings,
        );
      case '/order_products':
        return MaterialPageRoute(
          builder: (context) => const OrderProducts(),
          settings: settings,
        );
      case '/movies_page':
        return MaterialPageRoute(
          builder: (context) => const MoviesPage(),
          settings: settings,
        );
    }
  }
}

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: <Color>[
                  Color.fromRGBO(67, 206, 162, 1),
                  Color.fromRGBO(24, 90, 157, 1),
                ],
              ),
            ),
          ),
          SingleChildScrollView(
            child: Column(
              children: [
                Container(
                  padding: const EdgeInsets.all(20),
                  margin: const EdgeInsets.only(top: 120),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: <Widget>[
                      RotationTransition(
                        turns: const AlwaysStoppedAnimation(350 / 360),
                        child: SizedBox(
                          height: 100,
                          child: Card(
                            elevation: 8,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(50)),
                            color: const Color.fromRGBO(24, 90, 157, 0.8),
                            child: const Text(
                              'My App',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                height: 1.6,
                                fontSize: 50,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                SingleChildScrollView(
                  child: Container(
                    margin: const EdgeInsets.only(top: 50, left: 10, right: 10),
                    child: Column(
                      children: [
                        Card(
                          elevation: 10,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20)),
                          child: const SetForm(),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
