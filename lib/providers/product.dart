import 'package:flutter/foundation.dart';

import 'package:http/http.dart' as http;
import 'dart:convert';

class Product with ChangeNotifier {
  final String id;
  final String title;
  final String description;
  final double price;
  final String imageUrl;
  bool isFavorite;

  Product({
    @required this.id,
    @required this.title,
    @required this.description,
    @required this.price,
    @required this.imageUrl,
    this.isFavorite = false,
  });

  Future<void> toggleFavourite(String authToken, String userId) async {
    final url =
        'realTimeDatabaseUrl/userFavourites/$userId/$id.json?auth=$authToken';

    var response = await http.put(url,
        body: json.encode(
          !isFavorite,
        ));
    print(response.statusCode);
    print(response.body);

    if (response.statusCode == 200) isFavorite = !isFavorite;
    if (response.statusCode >= 400) throw response.body;
    notifyListeners();
  }
}
