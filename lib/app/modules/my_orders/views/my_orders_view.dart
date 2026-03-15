import 'package:expiry_deals/app/modules/my_orders/model/my_order_model.dart';
import 'package:expiry_deals/app/modules/my_orders/views/order_details_view.dart';
import 'package:expiry_deals/common/app_color/app_colors.dart';
import 'package:expiry_deals/common/app_text_style/styles.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import '../controllers/my_orders_controller.dart';

class MyOrdersView extends GetView<MyOrdersController> {
  const MyOrdersView({super.key});

  @override
  Widget build(BuildContext context) {
    Get.put(MyOrdersController());

    return Scaffold(
      backgroundColor: AppColors.bgColor,
      appBar: AppBar(
        title: Text('My Orders', style: h2.copyWith(fontSize: 18)),
        centerTitle: true,
        backgroundColor: AppColors.bgColor,
        elevation: 0,
        foregroundColor: AppColors.black,
      ),
      body: DefaultTabController(
        length: 5,
        child: Column(
          children: [
            // TabBar
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                color: AppColors.grayLight.withOpacity(0.3),
                borderRadius: BorderRadius.circular(12),
              ),
              child: TabBar(
                isScrollable: true,
                dividerColor: Colors.transparent,
                labelColor: Colors.white,
                unselectedLabelColor: AppColors.textColor,
                labelStyle: GoogleFonts.dmSans(fontWeight: FontWeight.w600, fontSize: 13),
                indicator: BoxDecoration(color: AppColors.mainColor, borderRadius: BorderRadius.circular(12)),
                indicatorSize: TabBarIndicatorSize.tab,
                indicatorPadding: const EdgeInsets.all(4),
                tabs: const [
                  Tab(text: 'All'),
                  Tab(text: 'Pending'),
                  Tab(text: 'Ongoing'),
                  Tab(text: 'Delivered'),
                  Tab(text: 'Cancelled'),
                ],
              ),
            ),

            Expanded(
              child: Obx(() {
                if (controller.isLoading.value) {
                  return const Center(child: CircularProgressIndicator(color: AppColors.mainColor));
                }

                return TabBarView(
                  children: [
                    _buildList(controller.allOrders),
                    _buildList(controller.pendingOrders),
                    _buildList(controller.ongoingOrders),
                    _buildList(controller.deliveredOrders),
                    _buildList(controller.cancelledOrders),
                  ],
                );
              }),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildList(List<MyOrder> orders) {
    if (orders.isEmpty) {
      return RefreshIndicator(
        onRefresh: controller.fetchOrders,
        color: AppColors.mainColor,
        child: ListView(
          physics: const AlwaysScrollableScrollPhysics(),
          children: [
            SizedBox(height: Get.height * 0.2),
            Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.shopping_bag_outlined, size: 80, color: AppColors.gray),
                  const SizedBox(height: 16),
                  Text('No orders here', style: h2.copyWith(color: AppColors.textColor)),
                  Text('Time to start shopping!', style: h4.copyWith(color: AppColors.hintColor)),
                ],
              ),
            ),
          ],
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: controller.fetchOrders,
      color: AppColors.mainColor,
      child: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: orders.length,
        itemBuilder: (_, i) => _buildOrderCard(orders[i]),
      ),
    );
  }

  Widget _buildOrderCard(MyOrder order) {
    final color = _getStatusColor(order.status);
    final statusText = _getStatusDisplay(order.status);

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.grayLight),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 10,
            offset: const Offset(0, 4),
          )
        ],
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: () => Get.to(() => OrderDetailsView(order: order)),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Order ${order.datumId ?? order.id?.substring(order.id!.length - 8) ?? '—'}',
                    style: h3.copyWith(fontWeight: FontWeight.w600),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: color.withOpacity(0.08),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      statusText,
                      style: GoogleFonts.dmSans(
                        color: color,
                        fontWeight: FontWeight.w600,
                        fontSize: 12,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Text(
                DateFormat('dd MMM yyyy • hh:mm a').format(order.createdAt!),
                style: h5.copyWith(color: AppColors.hintColor),
              ),
              const SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    '${order.items.length} item${order.items.length != 1 ? 's' : ''}',
                    style: h4,
                  ),
                  Text(
                    '\$${order.totalPrice?.toStringAsFixed(2) ?? '0.00'}',
                    style: h1.copyWith(color: AppColors.mainColor, fontSize: 20),
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
        return Colors.blue;
      case 'pending':
        return AppColors.orange;
      case 'cancelled':
        return AppColors.red;
      default:
        return AppColors.gray;
    }
  }

  String _getStatusDisplay(String? status) {
    if (status == null) return 'Unknown';
    switch (status.toLowerCase()) {
      case 'pending':
        return 'Pending';
      case 'ongoing':
        return 'Ongoing';
      case 'delivered':
        return 'Delivered';
      case 'cancelled':
        return 'Cancelled';
      default:
        return status.capitalizeFirst ?? status;
    }
  }
}