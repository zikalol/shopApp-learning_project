import 'package:flutter/cupertino.dart';

import 'package:fourth_learning_project/models/http_exception.dart';
import 'package:fourth_learning_project/providers/cart.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class OrderItem {
  final String id;
  final double amount;
  final List<CartItem> poducts;
  final DateTime dateTime;

  OrderItem({
    @required this.id,
    @required this.amount,
    @required this.poducts,
    @required this.dateTime,
  });
}

class Orders with ChangeNotifier {
  List<OrderItem> _orders = [];
  final String authToken;
  final String userId;
  Orders(this.authToken, this._orders, this.userId);
  List<OrderItem> get orders {
    return [..._orders];
  }

  Future<dynamic> fetchAndSetOrders() async {
    final url = "realTimeDatabaseUrl/orders/$userId.json?auth=$authToken";
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final List<OrderItem> loadedOrders = [];
      final extractedData = json.decode(response.body) as Map<String, dynamic>;
      if (extractedData == null) return;
      extractedData.forEach((key, value) {
        loadedOrders.add(
          OrderItem(
              id: key,
              amount: value['amount'],
              dateTime: DateTime.parse(value['dateTime']),
              poducts: (value['products'] as List<dynamic>)
                  .map((e) => CartItem(
                      id: e['id'],
                      title: e['title'],
                      quantity: e['quantity'],
                      price: e['price']))
                  .toList()),
        );
      });
      _orders = loadedOrders.reversed.toList();
      notifyListeners();

      return response.statusCode;
    }

    if (response.statusCode >= 400)
      throw HttpException(response.statusCode.toString());
  }

  Future<void> addOrder(List<CartItem> cartProducts, double total) async {
    final url = "realTimeDatabaseUrl/orders/$userId.json?auth=$authToken";
    final timestamp = DateTime.now();
    final response = await http.post(url,
        body: json.encode({
          'amount': total,
          'dateTime': timestamp.toIso8601String(),
          'products': cartProducts
              .map((e) => {
                    'id': e.id,
                    'title': e.title,
                    'quantity': e.quantity,
                    'price': e.price
                  })
              .toList(),
        }));

    _orders.insert(
      0,
      new OrderItem(
        id: jsonDecode(response.body)['name'],
        amount: total,
        poducts: cartProducts,
        dateTime: timestamp,
      ),
    );
    notifyListeners();
  }
}
