// vendor_order_view.dart

import 'package:expiry_deals/app/modules/vendor_dashboard/vendor_order/views/vendor_order_details_view.dart';
import 'package:expiry_deals/common/app_color/app_colors.dart';
import 'package:expiry_deals/common/size_box/custom_sizebox.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import '../controllers/vendor_order_controller.dart';


class VendorOrderView extends GetView<VendorOrderController> {
  const VendorOrderView({super.key});

  @override
  Widget build(BuildContext context) {
    Get.put(VendorOrderController());

    return Scaffold(
      backgroundColor: AppColors.bgColor,
      appBar: AppBar(
        title: const Text('Orders'),
        centerTitle: true,
        backgroundColor: AppColors.mainColor,
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator(color: AppColors.mainColor));
        }

        if (controller.orders.isEmpty) {
          return Center(
            child: Column(
             children: [
               Icon(Icons.receipt_long_outlined, size: 80, color: Colors.grey),
               sh20,
               Text('No orders yet', style: TextStyle(fontSize: 18, color: Colors.grey[600])),
               sh10,
               Text('Customer orders will appear here', style: TextStyle(color: Colors.grey[500])),
             ],
            ),
          );
        }

        return ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: controller.orders.length,
          itemBuilder: (context, index) {
            final order = controller.orders[index];
            return _buildOrderCard(order);
          },
        );
      }),
    );
  }

  Widget _buildOrderCard(Order order) {
    final color = _getStatusColor(order.status);
    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.grayLight),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 12, offset: const Offset(0, 4))
        ],
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: () => Get.to(() => VendorOrderDetailsView(order: order)),
        child: Padding(
          padding: const EdgeInsets.all(18),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Order #${order.id}', style: GoogleFonts.dmSans(fontSize: 17, fontWeight: FontWeight.w600)),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 7),
                    decoration: BoxDecoration(
                      color: color.withOpacity(0.12),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      order.status.capitalizeFirst!,
                      style: GoogleFonts.dmSans(color: color, fontWeight: FontWeight.bold, fontSize: 13),
                    ),
                  ),
                ],
              ),
              sh10,
              Text(
                DateFormat('dd MMM yyyy • hh:mm a').format(order.orderDate),
                style: TextStyle(color: AppColors.hintColor, fontSize: 14),
              ),
              sh10,
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('${order.items.length} items', style: TextStyle(fontSize: 15, color: AppColors.textColor)),
                  Text(
                    '\$${order.total.toStringAsFixed(2)}',
                    style: GoogleFonts.dmSans(fontSize: 22, fontWeight: FontWeight.bold, color: AppColors.mainColor),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'delivered': return AppColors.green;
      case 'pending':
      case 'processing': return AppColors.orange;
      case 'shipped': return Colors.blue;
      case 'cancelled': return AppColors.red;
      default: return AppColors.gray;
    }
  }
}