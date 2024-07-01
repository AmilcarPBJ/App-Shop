import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_2/components/app_drawer.dart';
import 'package:shop_2/components/order.dart';
import 'package:shop_2/models/order_list.dart';

class OrdersPage extends StatelessWidget {
  const OrdersPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Meus Pedidos'),
      ),
      drawer: const AppDrawer(),
      body: FutureBuilder(
          future: Provider.of<OrderList>(context, listen: false).loadOrders(),
          builder: (ctx, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            } else if(snapshot.hasError) {
              return const Center(
                child: Text('Ocorreu um erro!'),
              );
            } else {
              return Consumer<OrderList>(
                builder: (context, orders, child) => ListView.builder(
                  itemCount: orders.itemsCount,
                  itemBuilder: (ctx, i) => OrderWidget(order: orders.items[i]),
                ),
              );
            }
          }),
    );
  }
}
