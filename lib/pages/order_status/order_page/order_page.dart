
import 'package:doggzi/core/app_routes.dart';
import 'package:doggzi/pages/order_status/order_page/widgets/order_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:doggzi/controllers/cart_controller.dart';
import '../../../models/order_model.dart';
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
            trailingIcon: (Icons.notifications),
            onTrailingIconTap: (){Get.toNamed(AppRoutes.notifications);},
            isTrailingIconVisible: true,
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

              // Group orders by status and delivery date
              final deliveredGroups = <String, List<OrderModel>>{};
              final cancelledGroups = <String, List<OrderModel>>{};
              for (final order in controller.orders) {
                final label = _formatDate(order.deliveryDate);
                if (order.status == OrderStatus.pending_confirmation) {
                  deliveredGroups.putIfAbsent(label, () => []).add(order);
                } else if (order.status == OrderStatus.cancelled) {
                  cancelledGroups.putIfAbsent(label, () => []).add(order);
                }
              }

              return ListView(
                reverse: true,
                padding: EdgeInsets.symmetric(horizontal: 13.w, vertical: 35.h),
                children: [
                  // Delivered group
                  ...deliveredGroups.entries.map((group) => OrderCard(
                    title: 'Delivered on ${group.key}',
                    order: group.value,
                  )),
                  // Cancelled group
                  ...cancelledGroups.entries.map((group) => OrderCard(
                    title: 'Cancelled on ${group.key}',
                    order: group.value,
                  )),
                ],
              );
            }),
          ),
        ],
      ),
    );
  }
} 



