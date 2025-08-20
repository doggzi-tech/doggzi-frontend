import 'package:doggzi/controllers/cart_controller.dart';
import 'package:doggzi/widgets/custom_app_bar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class OrderPage extends GetView<CartController> {
  const OrderPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          CustomAppBar(
            title: "Orders",
            showBackButton: true,
          ),
          controller.orders.isEmpty
              ? Center(
                  child: Text(
                    "No orders found",
                    style: TextStyle(fontSize: 18, color: Colors.grey),
                  ),
                )
              : Expanded(
                  child: ListView.builder(
                    itemCount: controller.orders.length,
                    itemBuilder: (context, index) {
                      final order = controller.orders[index];
                      return Text(
                          "Order #${order.id} - Total: ${order.address!.receiverName.toString()}");
                    },
                  ),
                ),
        ],
      ),
    );
  }
}
