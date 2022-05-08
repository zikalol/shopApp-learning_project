import 'package:flutter/material.dart';
import 'package:fourth_learning_project/models/http_exception.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'product.dart';

class ProductProvider with ChangeNotifier {
  List<Product> _items = [
    // Product(
    //   id: 'p1',
    //   title: 'Red Shirt',
    //   description: 'A red shirt - it is pretty red!',
    //   price: 29.99,
    //   imageUrl:
    //       'https://cdn.pixabay.com/photo/2016/10/02/22/17/red-t-shirt-1710578_1280.jpg',
    // ),
    // Product(
    //   id: 'p2',
    //   title: 'Trousers',
    //   description: 'A nice pair of trousers.',
    //   price: 59.99,
    //   imageUrl:
    //       'https://upload.wikimedia.org/wikipedia/commons/thumb/e/e8/Trousers%2C_dress_%28AM_1960.022-8%29.jpg/512px-Trousers%2C_dress_%28AM_1960.022-8%29.jpg',
    // ),
    // Product(
    //   id: 'p3',
    //   title: 'Yellow Scarf',
    //   description: 'Warm and cozy - exactly what you need for the winter.',
    //   price: 19.99,
    //   imageUrl:
    //       'https://live.staticflickr.com/4043/4438260868_cc79b3369d_z.jpg',
    // ),
    // Product(
    //   id: 'p4',
    //   title: 'A Pan',
    //   description: 'Prepare any meal you want.',
    //   price: 49.99,
    //   imageUrl:
    //       'https://upload.wikimedia.org/wikipedia/commons/thumb/1/14/Cast-Iron-Pan.jpg/1024px-Cast-Iron-Pan.jpg',
    // ),
  ];
/* 
  var _showFavoriteOnly = false; */
  List<Product> get getItems {
    /*  if (_showFavoriteOnly)
      return _items.where((element) => element.isFavourtie).toList();
    else */
    return [..._items];
  }

  List<Product> get favoriteItems {
    return _items.where((element) => element.isFavorite).toList();
  }

/*   void showFavoritesOnly() {
    _showFavoriteOnly = true;
    notifyListeners();
  }

  void showAll() {
    _showFavoriteOnly = false;
    notifyListeners();
  } */

  final String authToken;
  final String userId;
  ProductProvider(this.authToken, this.userId, this._items);

  Future<void> fetchAndsetProducts([bool filterByUser = false]) async {
    print('fetching products');
    final filterString =
        filterByUser ? '&orderBy="CreatorId"&equalTo="$userId"' : '';
    final url =
        'realTimeDatabaseUrl/products.json?auth=$authToken$filterString';
    print(url);
    try {
      final response = await http.get(url);
      print(response.body);
      final extractedData = json.decode(response.body) as Map<String, dynamic>;
      final List<Product> loadedProducts = [];
      final favoriteResponse = await http.get(
          "realTimeDatabaseUrl/userFavourites/$userId.json?auth=$authToken");
      final favoriteData = json.decode(favoriteResponse.body);
      print(json.decode(favoriteResponse.body));
      extractedData.forEach((key, value) {
        loadedProducts.add(Product(
          id: key,
          title: value['title'],
          description: value['description'],
          price: value['price'],
          imageUrl: value['imageUrl'],
          isFavorite: favoriteData == null ? false : favoriteData[key] ?? false,
        ));
      });
      _items = loadedProducts;
      notifyListeners();
    } catch (e) {
      print(e);
    }
  }

  Future<void> addProduct(Product product) async {
    final url = "realTimeDatabaseUrl//products.json?auth=$authToken";

    try {
      final response = await http.post(url,
          body: jsonEncode({
            'title': product.title,
            'description': product.description,
            'imageUrl': product.imageUrl,
            'price': product.price,
            'CreatorId': userId,
          }));
      final newProduct = Product(
        id: json.decode(response.body)['name'],
        title: product.title,
        description: product.description,
        price: product.price,
        imageUrl: product.imageUrl,
      );
      _items.insert(0, newProduct);
      notifyListeners();
    } catch (e) {
      print(e);
      throw e;
    }
  }

  Future<void> updateProduct(String id, Product product) async {
    final prodIndex = _items.indexWhere((element) => element.id == id);
    if (prodIndex >= 0) {
      final url = "realTimeDatabaseUrl//products/$id.json?auth=$authToken";

      await http.patch(url,
          body: json.encode({
            'title': product.title,
            'description': product.description,
            'imageUrl': product.imageUrl,
            'price': product.price,
          }));
      _items[prodIndex] = product;
      notifyListeners();
    } else {
      print('...');
    }
  }

  Future<void> deleteProduct(String id) async {
    final url = "realTimeDatabaseUrl//products/$id.json?auth=$authToken";

    final response = await http.delete(url);

    if (response.statusCode >= 400) {
      throw HttpException('could not delete product');
    }
    _items.removeWhere((element) => element.id == id);
    notifyListeners();
  }

  Product getById(String id) {
    return _items.firstWhere((element) => element.id == id);
  }
}
