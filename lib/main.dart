import 'package:flutter/material.dart';
import 'package:fourth_learning_project/providers/auth.dart';
import 'package:fourth_learning_project/providers/cart.dart';
import 'package:fourth_learning_project/providers/orders.dart';
import 'package:fourth_learning_project/providers/product_provider.dart';
import 'package:fourth_learning_project/screens/Product_detail_screen.dart';
import 'package:fourth_learning_project/screens/auth_screen.dart';
import 'package:fourth_learning_project/screens/cart_screen.dart';
import 'package:fourth_learning_project/screens/edit_product_screen.dart';
import 'package:fourth_learning_project/screens/orders_screen.dart';
import 'package:fourth_learning_project/screens/products_overview_screen.dart';
import 'package:fourth_learning_project/screens/splash_screen.dart';
import 'package:fourth_learning_project/screens/user_products_screen.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (ctx) {
            print('auth created');
            return Auth();
          },
        ),
        ChangeNotifierProxyProvider<Auth, ProductProvider>(
          create: (ctx) {
            print('productprovider created');
            return ProductProvider(null, null, []);
          },
          update: (ctx, auth, previousProducts) => ProductProvider(
              auth.token, auth.userId, previousProducts.getItems),
        ),
        ChangeNotifierProvider(
          create: (ctx) => Cart(),
        ),
        ChangeNotifierProxyProvider<Auth, Orders>(
          create: (ctx) => Orders(null, [], null),
          update: (ctx, auth, previousOrder) => Orders(auth.token,
              previousOrder == null ? [] : previousOrder.orders, auth.userId),
        ),
      ],
      child: Consumer<Auth>(
        builder: (ctx, auth, _) => MaterialApp(
          title: 'MyShop',
          theme: ThemeData(
            primarySwatch: Colors.purple,
            accentColor: Colors.deepOrange,
            visualDensity: VisualDensity.adaptivePlatformDensity,
            fontFamily: 'Lato',
          ),
          home: auth.isAuth
              ? ProductsOverviewScreen()
              : FutureBuilder(
                  future: auth.tryAutoLogin(),
                  builder: (ctx, authResult) =>
                      authResult.connectionState == ConnectionState.waiting
                          ? SplashScreen()
                          : AuthScreen()),
          routes: {
            ProductDetailScreen.routeName: (ctx) => ProductDetailScreen(),
            CartScreen.routeName: (ctx) => CartScreen(),
            OrdersScreen.routeName: (ctx) => OrdersScreen(),
            UserProductsScreen.routeName: (ctx) => UserProductsScreen(),
            EditProductScreen.routerName: (ctx) => EditProductScreen(),
          },
        ),
      ),
    );
  }
}

class MyHomePage extends StatelessWidget {
  const MyHomePage({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('MyShop'),
      ),
      body: Center(
        child: ProductsOverviewScreen(),
      ),
    );
  }
}
