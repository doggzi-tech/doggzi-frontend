import 'package:doggzi/core/app_routes.dart';
import 'package:doggzi/models/cart.dart';
import 'package:doggzi/models/order_model.dart';
import 'package:doggzi/pages/order_status/order_page/widgets/order_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:doggzi/controllers/cart_controller.dart';
import 'package:zoom_tap_animation/zoom_tap_animation.dart';
import '../../../widgets/custom_app_bar.dart';

class OrderPage extends GetView<CartController> {
   OrderPage({super.key});

  final cartController = Get.find<CartController>();

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
          const CustomAppBar(
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

                  return ZoomTapAnimation(
                    onTap: () {
                      cartController.showOrderDetails(order);
                    },
                    child: () {
                      if (order.status == OrderStatus.pending_confirmation ||
                          order.status == OrderStatus.delivered) {
                        return OrderCard(
                          title: 'Delivered on ${_formatDate(date)}',
                          order: order,
                        );
                      } else if (order.status == OrderStatus.cancelled ||
                          order.status == OrderStatus.failed ||order.status==OrderStatus.pending_payment) {
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
                      else if (order.status == OrderStatus.preparing) {
                        return OrderCard(
                          title: 'Preparing on ${_formatDate(date)}',
                          order: order,
                        );
                      }
                      return const SizedBox.shrink();
                    }(),
                  );
                },
              );
            }),
          ),
        ],
      ),
    );
  }
}
