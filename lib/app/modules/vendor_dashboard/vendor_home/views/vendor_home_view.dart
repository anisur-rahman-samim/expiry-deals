// vendor_home_view.dart

import 'package:expiry_deals/app/modules/vendor_dashboard/vendor_order/controllers/vendor_order_controller.dart';
import 'package:expiry_deals/app/modules/vendor_dashboard/vendor_order/model/my_vendor_order_model.dart';
import 'package:expiry_deals/app/modules/vendor_dashboard/vendor_order/views/vendor_order_details_view.dart';
import 'package:expiry_deals/common/app_color/app_colors.dart';
import 'package:expiry_deals/common/app_text_style/styles.dart';
import 'package:expiry_deals/common/size_box/custom_sizebox.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import '../../vendor_order/views/vendor_order_view.dart';
import '../controllers/vendor_home_controller.dart';


class VendorHomeView extends GetView<VendorHomeController> {
  const VendorHomeView({super.key});

  @override
  Widget build(BuildContext context) {
    // Get the already existing VendorOrderController
    Get.put(VendorHomeController());
    final orderController = Get.put(VendorOrderController(), permanent: true);

    return Scaffold(
      backgroundColor: AppColors.bgColor,
      appBar: AppBar(
        title: const Text('Dashboard'),
        centerTitle: true,
        elevation: 0,
        backgroundColor: AppColors.mainColor,
        foregroundColor: AppColors.white,
      ),
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: () async {
            await orderController.refreshOrders();
            await controller.fetchVendorDashboard();
          },
          color: AppColors.mainColor,
          child: Obx(() {
            // You can show loading from orderController too
            if (orderController.isLoading.value) {
              return const Center(child: CircularProgressIndicator());
            }

            final recentOrders = orderController.orders;

            return ListView(
              padding: const EdgeInsets.all(16),
              children: [
                // Welcome
                Text(
                  'Welcome back, Vendor!',
                  style: Theme.of(context).textTheme.headlineSmall!.copyWith(
                    fontWeight: FontWeight.bold,
                    color: AppColors.textColor,
                  ),
                ),
                sh8,
                Text(
                  "Here's your store performance at a glance",
                  style: TextStyle(color: AppColors.hintColor, fontSize: 14),
                ),
                sh20,

                // Stats Cards
                _buildStatsRow(),
                sh30,

                // Recent Orders Section
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      'Recent Orders',
                      style: Theme.of(context).textTheme.titleLarge!.copyWith(
                        fontWeight: FontWeight.bold,
                        color: AppColors.textColor,
                      ),
                    ),
                    if (recentOrders.isNotEmpty)
                      TextButton(
                        onPressed: () => Get.to(() => VendorOrderView()),
                        child: Text(
                          'View All',
                          style: TextStyle(color: AppColors.mainColor),
                        ),
                      ),
                  ],
                ),
                sh16,

                // Show last 6 orders (most recent first)
                if (recentOrders.isEmpty)
                  _buildEmptyOrders()
                else
                  ...recentOrders
                      .take(6)
                      .map((order) => _buildRecentOrderCard(order))
                      .toList(),

                sh40,
              ],
            );
          }),
        ),
      ),
    );
  }

  Widget _buildStatsRow() {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: _statCard(
                "Total revenue",
                controller.totalRevenue.value,
                Icons.account_balance_wallet_rounded,
                AppColors.mainColor,
                caption: "All-time sales (not your wallet balance)",
              ),
            ),
            sw10,
            Expanded(
              child: _statCard(
                "Total Products",
                controller.totalProducts.value,
                Icons.inventory_2_rounded,
                AppColors.green,
              ),
            ),
          ],
        ),

      ],
    );
  }

  Widget _statCard(
    String title,
    String value,
    IconData icon,
    Color color, {
    String? caption,
  }) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: color, size: 32),
          sh14,
          Text(
            value,
            style: GoogleFonts.dmSans(
              fontSize: 26,
              fontWeight: FontWeight.bold,
              color: AppColors.textColor,
            ),
          ),
          sh5,
          Text(
            title,
            style: GoogleFonts.dmSans(
              fontSize: 14,
              color: AppColors.hintColor,
            ),
          ),
          if (caption != null) ...[
            sh8,
            Text(
              caption,
              style: GoogleFonts.dmSans(
                fontSize: 11,
                color: AppColors.hintColor,
                height: 1.3,
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildRecentOrderCard(MyVendorOrder order) {
    final date = DateFormat('dd MMM yyyy • hh:mm a').format(order.createdAt ?? DateTime.now());
    final statusColor = _getStatusColor(order.status ?? '');

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      color: AppColors.white,
      elevation: 1,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: () => Get.to(() => VendorOrderDetailsView(order: order)),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Order ${order.datumId ?? order.id?.substring(order.id!.length - 5) ?? '—'}',
                    style: GoogleFonts.dmSans(fontSize: 16, fontWeight: FontWeight.w600),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: statusColor.withOpacity(0.15),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      (order.status ?? 'Unknown').capitalizeFirst ?? 'Unknown',
                      style: TextStyle(
                        color: statusColor,
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
              sh8,
              Text(
                date,
                style: TextStyle(color: AppColors.hintColor, fontSize: 13),
              ),
              sh10,
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    '${order.items.length} item${order.items.length != 1 ? 's' : ''}',
                    style: const TextStyle(fontSize: 14),
                  ),
                  Text(
                    '\$${order.totalPrice?.toStringAsFixed(2) ?? '0.00'}',
                    style: GoogleFonts.dmSans(
                      fontSize: 16,
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

  Widget _buildEmptyOrders() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 32),
      child: Center(
        child: Column(
          children: [
            Icon(Icons.receipt_long_outlined, size: 60, color: Colors.grey[400]),
            sh16,
            Text(
              'No recent orders yet',
              style: TextStyle(fontSize: 16, color: Colors.grey[700]),
            ),
          ],
        ),
      ),
    );
  }

  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'delivered':
        return AppColors.green;
      case 'ongoing':
        return Colors.blue;
      case 'pending':
        return AppColors.orange;
      case 'cancelled':
        return AppColors.red;
      default:
        return AppColors.gray;
    }
  }

// Your existing _buildStatsRow() and _statCard() ...
// ...
}