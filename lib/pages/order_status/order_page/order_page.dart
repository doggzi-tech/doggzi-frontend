import 'package:doggzi/core/app_routes.dart';
import 'package:doggzi/models/order_model.dart';
import 'package:doggzi/pages/order_status/order_page/widgets/order_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:doggzi/controllers/cart_controller.dart';
import 'package:zoom_tap_animation/zoom_tap_animation.dart';
import '../../../widgets/custom_app_bar.dart';

class OrderPage extends GetView<CartController> {
  const OrderPage({super.key});

  String _formatDate(DateTime dt) {
    final months = [
      "",
      "January",
      "February",
      "March",
      "April",
      "May",
      "June",
      "July",
      "August",
      "September",
      "October",
      "November",
      "December"
    ];
    final days = [
      "",
      "Mon",
      "Tue",
      "Wed",
      "Thu",
      "Fri",
      "Sat",
      "Sun",
    ];
    final dayName = days[dt.weekday % 7];
    final monthName = months[dt.month];
    return "$dayName, ${dt.day.toString().padLeft(2, '0')} $monthName";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          CustomAppBar(
            title: "Orders",
            showBackButton: true,
          ),
          Expanded(
            child: Obx(() {
              if (controller.orders.isEmpty) {
                return Center(
                  child: Text(
                    "No orders found",
                    style: TextStyle(fontSize: 16.sp, color: Colors.grey),
                  ),
                );
              }

              return ListView.builder(
                itemCount: controller.orders.length,
                itemBuilder: (context, index) {
                  final order = controller.orders[index];
                  final date = order.deliveryDate;

                  if (order.status == OrderStatus.pending_confirmation ||
                      order.status == OrderStatus.delivered) {
                    return OrderCard(
                      title: 'Delivered on ${_formatDate(date)}',
                      order: order,
                    );
                  } else if (order.status == OrderStatus.cancelled ||
                      order.status == OrderStatus.failed) {
                    return OrderCard(
                      title: 'Cancelled on ${_formatDate(date)}',
                      order: order,
                    );
                  } else if (order.status == OrderStatus.out_for_delivery) {
                    return OrderCard(
                      title: 'Out for Delivery on ${_formatDate(date)}',
                      order: order,
                    );
                  }
                  return const SizedBox.shrink();
                },
              );
            }),
          ),
        ],
      ),
    );
  }
}
