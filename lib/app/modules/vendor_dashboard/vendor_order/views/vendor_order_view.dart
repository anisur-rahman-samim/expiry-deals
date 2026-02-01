import 'package:expiry_deals/app/modules/vendor_dashboard/vendor_order/model/my_vendor_order_model.dart';
import 'package:expiry_deals/app/modules/vendor_dashboard/vendor_order/views/vendor_order_details_view.dart';
import 'package:expiry_deals/common/app_color/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import '../controllers/vendor_order_controller.dart';

class VendorOrderView extends GetView<VendorOrderController> {
  const VendorOrderView({super.key});

  @override
  Widget build(BuildContext context) {
    // Note: If you use GetX bindings or route bindings, you can remove Get.put()
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
          return const Center(
            child: CircularProgressIndicator(color: AppColors.mainColor),
          );
        }

        if (controller.errorMessage.isNotEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.error_outline_rounded, size: 70, color: Colors.red.shade400),
                const SizedBox(height: 16),
                Text(
                  'Something went wrong',
                  style: TextStyle(fontSize: 18, color: Colors.red.shade700),
                ),
                const SizedBox(height: 8),
                Text(
                  controller.errorMessage.value,
                  textAlign: TextAlign.center,
                  style: const TextStyle(color: Colors.grey),
                ),
                const SizedBox(height: 24),
                ElevatedButton(
                  onPressed: controller.fetchOrders,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.mainColor,
                  ),
                  child: const Text('Try Again'),
                ),
              ],
            ),
          );
        }

        if (controller.orders.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.receipt_long_outlined, size: 80, color: Colors.grey[400]),
                const SizedBox(height: 20),
                Text(
                  'No orders yet',
                  style: TextStyle(fontSize: 18, color: Colors.grey[700]),
                ),
                const SizedBox(height: 8),
                Text(
                  'Customer orders will appear here',
                  style: TextStyle(color: Colors.grey[500]),
                ),
              ],
            ),
          );
        }

        return RefreshIndicator(
          onRefresh: controller.refreshOrders,
          color: AppColors.mainColor,
          child: ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: controller.orders.length,
            itemBuilder: (context, index) {
              final order = controller.orders[index];
              return _buildOrderCard(order);
            },
          ),
        );
      }),
    );
  }

  Widget _buildOrderCard(MyVendorOrder order) {
    final color = _getStatusColor(order.status ?? '');
    final date = controller.formatDate(order.createdAt);
    final statusText = controller.getStatusDisplay(order.status);

    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.grayLight),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 12,
            offset: const Offset(0, 4),
          )
        ],
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: () {
          Get.to(() => VendorOrderDetailsView(order: order));
        },
        child: Padding(
          padding: const EdgeInsets.all(18),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Order No. ${order.datumId ?? order.id?.substring(order.id!.length - 8) ?? '—'}',
                    style: GoogleFonts.dmSans(fontSize: 17, fontWeight: FontWeight.w600),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 7),
                    decoration: BoxDecoration(
                      color: color.withOpacity(0.12),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      statusText,
                      style: GoogleFonts.dmSans(
                        color: color,
                        fontWeight: FontWeight.bold,
                        fontSize: 13,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              Text(
                date,
                style: TextStyle(color: AppColors.hintColor, fontSize: 14),
              ),
              const SizedBox(height: 12),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    '${order.items.length} item${order.items.length == 1 ? '' : 's'}',
                    style: const TextStyle(fontSize: 15, color: AppColors.textColor),
                  ),
                  Text(
                    '\$${order.totalPrice?.toStringAsFixed(2) ?? '0.00'}',
                    style: GoogleFonts.dmSans(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: AppColors.mainColor,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Color _getStatusColor(String? status) {
    switch (status?.toLowerCase()) {
      case 'delivered':
        return AppColors.green;
      case 'ongoing':
        return Colors.blue;           // active / in progress
      case 'pending':
        return AppColors.orange;
      case 'cancelled':
        return AppColors.red;
      default:
        return AppColors.gray;
    }
  }
}