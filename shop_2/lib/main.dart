import 'package:flutter/material.dart';
import 'package:shop_2/models/auth.dart';
import 'package:shop_2/models/cart.dart';
import 'package:shop_2/models/order_list.dart';
import 'package:shop_2/models/product_list.dart';
import 'package:shop_2/pages/auth_or_home_page.dart';
import 'package:shop_2/pages/cart_page.dart';
import 'package:shop_2/pages/orders_page.dart';
import 'package:shop_2/pages/product_detail_page.dart';
import 'package:shop_2/pages/product_form_page.dart';
import 'package:shop_2/pages/products_page.dart';
import 'package:shop_2/utils/app_routes.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => Auth(),
        ),
        ChangeNotifierProxyProvider<Auth, ProductList>(
          create: (_) => ProductList(),
          update: (ctx, auth, previous) {
            return ProductList(
              auth.token ?? '',
              auth.userId ?? '',
              previous?.items ?? [],
            );
          },
        ),
        ChangeNotifierProxyProvider<Auth, OrderList>(
          create: (_) => OrderList(),
          update: (ctx, auth, previous) {
            return OrderList(
              auth.token ?? '',
              auth.userId ?? '', 
              previous?.items ?? []);
          },
        ),
        ChangeNotifierProvider(
          create: (_) => Cart(),
        ),
      ],
      child: MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSwatch().copyWith(
            primary: Colors.purple,
            secondary: Colors.deepOrange,
          ),
          textTheme: const TextTheme(
            headlineMedium: TextStyle(
              color: Colors.white,
            ),
          ),
          fontFamily: 'Lato',
        ),
        //home: const ProductsOverviewPage(),
        routes: {
          AppRoutes.authOrHome: (context) => const AuthOrHomePage(),
          AppRoutes.productDetail: (context) => const ProductDetailPage(),
          AppRoutes.cart: (context) => const CartPage(),
          AppRoutes.orders: (context) => const OrdersPage(),
          AppRoutes.products: (context) => const ProductsPage(),
          AppRoutes.productForm: (context) => const ProductFormPage(),
        },
        debugShowCheckedModeBanner: false,
      ),
    );
  }
}
