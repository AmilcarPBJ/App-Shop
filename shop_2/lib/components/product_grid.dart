import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_2/components/product_grid_item.dart';
import 'package:shop_2/models/product.dart';
import 'package:shop_2/models/product_list.dart';

class ProductGrid extends StatelessWidget {

  final bool showFavoriteOnly;

  const ProductGrid(this.showFavoriteOnly, {super.key});

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<ProductList>(context);
    final List<Product> loadedProducts = showFavoriteOnly ? provider.favoriteItems : provider.items;

    return GridView.builder(
      padding: const EdgeInsets.all(10),
      itemCount: loadedProducts.length,
      itemBuilder: ((context, index) => ChangeNotifierProvider.value(
          value: loadedProducts[index],
          // ignore: prefer_const_constructors
          child: ProductGridItem(),
      )),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          childAspectRatio: 3 / 2,
          crossAxisSpacing: 10,
          mainAxisSpacing: 10),
    );
  }
}
