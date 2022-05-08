import 'package:flutter/material.dart';
import 'package:fourth_learning_project/Widgets/app_drawer.dart';
import 'package:fourth_learning_project/Widgets/user_product_item.dart';
import 'package:fourth_learning_project/providers/product_provider.dart';
import 'package:fourth_learning_project/screens/edit_product_screen.dart';
import 'package:provider/provider.dart';

class UserProductsScreen extends StatelessWidget {
  const UserProductsScreen({Key key}) : super(key: key);
  static const routeName = '/user-products';

  @override
  Widget build(BuildContext context) {
    print('rebuilding...');
    /*  final productsData = Provider.of<ProductProvider>(context); */
    return Scaffold(
      drawer: AppDrawer(),
      appBar: AppBar(
        title: const Text('Your Products'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () {
              Navigator.of(context).pushNamed(EditProductScreen.routerName);
            },
          ),
        ],
      ),
      body: FutureBuilder(
        future: Provider.of<ProductProvider>(context, listen: false)
            .fetchAndsetProducts(true),
        builder: (ctx, snapshot) => snapshot.connectionState ==
                ConnectionState.waiting
            ? Center(
                child: CircularProgressIndicator(),
              )
            : RefreshIndicator(
                onRefresh: () async =>
                    await Provider.of<ProductProvider>(context, listen: false)
                        .fetchAndsetProducts(true),
                child: Consumer<ProductProvider>(
                  builder: (ctx, productsData, _) => Padding(
                    padding: EdgeInsets.all(8),
                    child: ListView.builder(
                      itemBuilder: (ctx, index) {
                        return Column(children: [
                          UserProductItem(
                            id: productsData.getItems[index].id,
                            title: productsData.getItems[index].title,
                            imageUrl: productsData.getItems[index].imageUrl,
                          ),
                          Divider(),
                        ]);
                      },
                      itemCount: productsData.getItems.length,
                    ),
                  ),
                ),
              ),
      ),
    );
  }
}
