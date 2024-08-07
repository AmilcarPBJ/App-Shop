import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_2/components/app_drawer.dart';
import 'package:shop_2/components/product_item.dart';
import 'package:shop_2/models/product_list.dart';
import 'package:shop_2/utils/app_routes.dart';

class ProductsPage extends StatelessWidget {
  const ProductsPage({super.key});

  Future<void> _refreshProducts(BuildContext context) {
    return Provider.of<ProductList>(
      context,
      listen: false,
    ).loadProducts();
  }

  @override
  Widget build(BuildContext context) {
    final ProductList products = Provider.of(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Gerenciar Produtos'),
        backgroundColor: Theme.of(context).colorScheme.primary,
        actions: [
          IconButton(
            onPressed: () {
              Navigator.of(context).pushNamed(
                AppRoutes.productForm,
              );
            },
            icon: const Icon(Icons.add),
          )
        ],
      ),
      drawer: const AppDrawer(),
      backgroundColor: Colors.white,
      body: RefreshIndicator(
        onRefresh: () => _refreshProducts(context),
        child: Padding(
          padding: const EdgeInsets.all(8),
          child: ListView.builder(
            itemCount: products.itemsCount,
            itemBuilder: (ctx, i) => Column(
              children: [
                ProductItem(products.items[i]),
                Divider(
                  color: Colors.grey[200],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
