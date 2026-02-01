// vendor_home_view.dart

import 'package:expiry_deals/common/app_color/app_colors.dart';
import 'package:expiry_deals/common/app_text_style/styles.dart';
import 'package:expiry_deals/common/size_box/custom_sizebox.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:fl_chart/fl_chart.dart';
import '../controllers/vendor_home_controller.dart';


class VendorHomeView extends GetView<VendorHomeController> {
  const VendorHomeView({super.key});

  @override
  Widget build(BuildContext context) {
    Get.put(VendorHomeController());

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
          onRefresh: ()async{},
          child: Obx(() => ListView(
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
                  style: TextStyle(color: AppColors.hintColor, fontSize: 14)),
              sh20,

              // Stats Cards
              _buildStatsRow(),
              sh30,

              // Earnings Summary + Dropdown
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
                  // Text(
                  //   'See more',
                  //   style: h3
                  // ),
                ],
              ),
              sh16,



              sh40,
            ],
          )),
        ),
      ),
    );
  }

  Widget _buildStatsRow() {
    return Column(
      children: [
        Row(
          children: [
            Expanded(child: _statCard("Total Revenue", controller.totalRevenue.value, Icons.account_balance_wallet, AppColors.mainColor)),
            sw10,
            Expanded(child: _statCard("Total Products", controller.totalProducts.value, Icons.fiber_manual_record, AppColors.green)),
          ],
        ),
        sh10,
        // Row(
        //   children: [
        //     Expanded(child: _statCard("Active Products", controller.activeProducts.value, Icons.inventory_2, AppColors.orange)),
        //     sw10,
        //     Expanded(child: _statCard("Pending Orders", controller.pendingOrders.value, Icons.pending_actions, AppColors.red)),
        //   ],
        // ),
      ],
    );
  }

  Widget _statCard(String title, String value, IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 12,
            offset: const Offset(0, 4),
          )
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: color, size: 32),
          sh14,
          Text(
            value,
            style: const TextStyle(fontSize: 26, fontWeight: FontWeight.bold, color: AppColors.textColor),
          ),
          sh5,
          Text(title, style: TextStyle(fontSize: 13, color: AppColors.hintColor)),
        ],
      ),
    );
  }




}