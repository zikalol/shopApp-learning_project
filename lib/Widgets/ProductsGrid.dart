import 'package:flutter/material.dart';
import 'package:fourth_learning_project/providers/product_provider.dart';
import 'package:provider/provider.dart';
import 'Product_item.dart';

class ProductsGrid extends StatelessWidget {

  final bool showProducts;

  ProductsGrid(this.showProducts);

  @override
  Widget build(BuildContext context) {
    final productData = Provider.of<ProductProvider>(context);
    final products = showProducts ? productData.favoriteItems : productData.getItems;

    return GridView.builder(
      padding: const EdgeInsets.all(10),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 3 / 2,
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
      ),
      itemBuilder: (ctx, index) {
        return ChangeNotifierProvider.value(
          value: products[index],
          child: ProductItem(
              /* id: products[index].id,
              title: products[index].title,
              imageUrl: products[index].imageUrl */
              ),
        );
      },
      itemCount: products.length,
    );
  }
}
