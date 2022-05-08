import 'package:flutter/material.dart';
import 'package:fourth_learning_project/providers/auth.dart';
import 'package:fourth_learning_project/providers/cart.dart';
import 'package:fourth_learning_project/providers/product.dart';
import 'package:fourth_learning_project/screens/Product_detail_screen.dart';
import 'package:provider/provider.dart';

class ProductItem extends StatelessWidget {
  /* final String imageUrl;
  final String title;
  final String id;

  ProductItem({
    @required this.id,
    @required this.title,
    @required this.imageUrl,
  }); */

  @override
  Widget build(BuildContext context) {
    final product = Provider.of<Product>(context);
    final cart = Provider.of<Cart>(context, listen: false);
    final authData = Provider.of<Auth>(context, listen: false);
    return ClipRRect(
      borderRadius: BorderRadius.circular(10),
      child: GestureDetector(
        onTap: () {
          Navigator.of(context)
              .pushNamed(ProductDetailScreen.routeName, arguments: product.id);
        },
        child: GridTile(
          child: Hero(
            tag: product.id,
            child: Image.network(
              product.imageUrl,
              fit: BoxFit.cover,
            ),
          ),
          footer: GridTileBar(
            backgroundColor: Colors.black87,
            leading: IconButton(
                icon: Icon(product.isFavorite
                    ? Icons.favorite
                    : Icons.favorite_border),
                color: Theme.of(context).accentColor,
                onPressed: () async {
                  product
                      .toggleFavourite(authData.token, authData.userId)
                      .catchError((onError) {
                    print('test');
                    showDialog(
                      context: context,
                      builder: (ctx) => AlertDialog(
                        title: Text('An error occured !'),
                        content: Text('something went wrong'),
                        actions: [
                          FlatButton(
                              onPressed: () {
                                Navigator.of(ctx).pop();
                              },
                              child: Text('Ok'))
                        ],
                      ),
                    );
                  });
                }),
            title: Text(
              product.title,
              textAlign: TextAlign.center,
            ),
            trailing: IconButton(
                icon: Icon(Icons.shopping_cart),
                color: Theme.of(context).accentColor,
                onPressed: () {
                  cart.addItem(product.id, product.price, product.title);
                  Scaffold.of(context).hideCurrentSnackBar();
                  Scaffold.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                        'Added Item to cart !',
                      ),
                      duration: Duration(seconds: 2),
                      action: SnackBarAction(
                          label: 'UNDO',
                          onPressed: () {
                            cart.removeSingleItem(product.id);
                          }),
                    ),
                  );
                }),
          ),
        ),
      ),
    );
  }
}
