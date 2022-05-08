import 'package:flutter/material.dart';
import 'package:fourth_learning_project/Widgets/app_drawer.dart';
import 'package:fourth_learning_project/Widgets/order_item.dart';
import 'package:fourth_learning_project/providers/orders.dart' show Orders;
import 'package:fourth_learning_project/screens/products_overview_screen.dart';
import 'package:provider/provider.dart';

import 'Product_detail_screen.dart';

class OrdersScreen extends StatefulWidget {
  static const routeName = '/orders';
  OrdersScreen({Key key}) : super(key: key);

  @override
  _OrdersScreenState createState() => _OrdersScreenState();
}

class _OrdersScreenState extends State<OrdersScreen> {
  var _isLoaded = false;
  @override
  void initState() {
    _isLoaded = true;
    Provider.of<Orders>(context, listen: false)
        .fetchAndSetOrders()
        .then((value) {
      print(value);
      setState(() {
        _isLoaded = false;
      });
    }).catchError((onError) {
      print(onError);
      setState(() {
        _isLoaded = false;
      });
      showDialog(
        context: context,
        builder: (ctx) => AlertDialog(
          title: Text('An error occured !'),
          content: Text('something went wrong'),
          actions: [
            FlatButton(
                onPressed: () {
                  Navigator.of(ctx).pop();
                  Navigator.of(context).popAndPushNamed('/');
                },
                child: Text('Ok'))
          ],
        ),
      );
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    print('orders build');
    final ordersData = Provider.of<Orders>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('Your orders'),
      ),
      drawer: AppDrawer(),
      body: _isLoaded
          ? Center(
              child: CircularProgressIndicator(),
            )
          : ListView.builder(
              itemBuilder: (ctx, index) {
                return OrderItem(ordersData.orders[index]);
              },
              itemCount: ordersData.orders.length,
            ),
    );
  }
}
