import 'package:flutter/material.dart';
import 'package:fourth_learning_project/Widgets/app_drawer.dart';
import 'package:fourth_learning_project/providers/cart.dart';
import 'package:fourth_learning_project/providers/product_provider.dart';
import 'package:fourth_learning_project/screens/cart_screen.dart';
import 'package:provider/provider.dart';
import 'package:fourth_learning_project/Widgets/ProductsGrid.dart';
import 'package:fourth_learning_project/Widgets/badge.dart';

enum filterOptions { Favorites, All }

class ProductsOverviewScreen extends StatefulWidget {
  @override
  _ProductsOverviewScreenState createState() => _ProductsOverviewScreenState();
}

class _ProductsOverviewScreenState extends State<ProductsOverviewScreen> {
  var _showOnlyFavorites = false;
  var _isInit = true;
  var _isLoading = false;

  @override
  void didChangeDependencies() async {
    if (_isInit) {
      setState(() {
        _isLoading = true;
      });
      Provider.of<ProductProvider>(context).fetchAndsetProducts().then((value) {
        setState(() {
          _isLoading = false;
        });
      });
    }

    _isInit = false;
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    var scaffold = Scaffold(
      appBar: AppBar(
        title: Text('MyShop'),
        actions: [
          PopupMenuButton(
              icon: Icon(Icons.more_vert),
              onSelected: (filterOptions selectedValue) {
                setState(() {
                  if (selectedValue == filterOptions.Favorites) {
                    _showOnlyFavorites = true;
                  } else {
                    _showOnlyFavorites = false;
                  }
                });
              },
              itemBuilder: (_) {
                return [
                  PopupMenuItem(
                    child: Text('Only favorites'),
                    value: filterOptions.Favorites,
                  ),
                  PopupMenuItem(
                    child: Text('Show all'),
                    value: filterOptions.All,
                  ),
                ];
              }),
          Consumer<Cart>(
            builder: (_, cart, ch) => Badge(
              child: ch,
              value: cart.itemsCount.toString(),
            ),
            child: IconButton(
              icon: Icon(Icons.shopping_cart),
              onPressed: () {
                Navigator.of(context).pushNamed(CartScreen.routeName);
              },
            ),
          ),
        ],
      ),
      drawer: AppDrawer(),
      body: _isLoading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : ProductsGrid(_showOnlyFavorites),
    );
    return scaffold;
  }
}
