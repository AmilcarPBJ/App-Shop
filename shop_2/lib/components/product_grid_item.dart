import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_2/models/auth.dart';
import 'package:shop_2/models/cart.dart';
import 'package:shop_2/models/product.dart';
import 'package:shop_2/utils/app_routes.dart';

class ProductGridItem extends StatelessWidget {
  const ProductGridItem({super.key});

  @override
  Widget build(BuildContext context) {
    final product = Provider.of<Product>(context, listen: false);
    final cart = Provider.of<Cart>(context, listen: false);
    final auth = Provider.of<Auth>(context, listen: false);

    return ClipRRect(
      borderRadius: BorderRadius.circular(10),
      child: GridTile(
        footer: GridTileBar(
          backgroundColor: Colors.black87,
          leading: Consumer<Product>(
            /*child: const Text("Esse child serve para chamares em algum ponto dentro consumer que não mudará com a renderização"),*/
            builder: (context, produto, child) => IconButton(
              /*body: child exemplo da utilização do child*/
              onPressed: () {
                produto.toggleFavorite(
                  auth.token ?? '', 
                  auth.userId ?? ''
                );
              },
              icon: Icon(
                  produto.isFavorite ? Icons.favorite : Icons.favorite_border),
              color: Theme.of(context).colorScheme.secondary,
            ),
          ),
          title: Text(
            product.name,
            textAlign: TextAlign.center,
          ),
          trailing: IconButton(
            onPressed: () {
              cart.addItem(product);
              ScaffoldMessenger.of(context).hideCurrentSnackBar();
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: const Text('Produto adicionado com sucesso!'),
                  duration: const Duration(seconds: 2),
                  action: SnackBarAction(
                      label: 'DESFAZER',
                      onPressed: () {
                        cart.removeSingleItem(product.id);
                      }),
                ),
              );
            },
            icon: const Icon(Icons.shopping_cart),
            color: Theme.of(context).colorScheme.secondary,
          ),
        ),
        child: GestureDetector(
          onTap: () {
            Navigator.of(context).pushNamed(
              AppRoutes.productDetail,
              arguments: product,
            );
          },
          child: Hero(
            tag: product.id,
            child: FadeInImage(
              placeholder: const AssetImage('assets/images/product-placeholder.png'), 
              image: NetworkImage(product.imageUrl),
              fit: BoxFit.cover,
            ),
          ),
          /*child: Image.network(
            product.imageUrl,
            fit: BoxFit.cover,
          ),*/
        ),
      ),
    );
  }
}
