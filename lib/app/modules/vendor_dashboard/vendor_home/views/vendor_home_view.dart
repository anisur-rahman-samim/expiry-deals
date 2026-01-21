// vendor_home_view.dart

import 'package:expiry_deals/common/app_color/app_colors.dart';
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
          onRefresh: controller.fetchDashboardData,
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
                    'Earnings Summary',
                    style: Theme.of(context).textTheme.titleLarge!.copyWith(
                      fontWeight: FontWeight.bold,
                      color: AppColors.textColor,
                    ),
                  ),
                  _buildPeriodDropdown(),
                ],
              ),
              sh16,

              // Chart Card
              _buildEarningsChartCard(),

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
            Expanded(child: _statCard("Total Orders", controller.totalOrders.value, Icons.shopping_cart, AppColors.green)),
          ],
        ),
        sh10,
        Row(
          children: [
            Expanded(child: _statCard("Active Products", controller.activeProducts.value, Icons.inventory_2, AppColors.orange)),
            sw10,
            Expanded(child: _statCard("Pending Orders", controller.pendingOrders.value, Icons.pending_actions, AppColors.red)),
          ],
        ),
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

  Widget _buildPeriodDropdown() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.grayLight),
        boxShadow: [
          BoxShadow(color: Colors.black.withValues(alpha: 0.05), blurRadius: 8, offset: const Offset(0, 2))
        ],
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
            value: controller.selectedPeriod.value,
            icon: Icon(Icons.keyboard_arrow_down_rounded, color: AppColors.mainColor),
            iconSize: 24,
            elevation: 4,
            borderRadius: BorderRadius.circular(12),
            dropdownColor: AppColors.white,
            style: TextStyle(color: AppColors.textColor, fontWeight: FontWeight.w600),
        onChanged: (String? newValue) {
          if (newValue != null) controller.changePeriod(newValue);
        },
        items: const [
          DropdownMenuItem(value: 'weekly', child: Text('This Week')),
          DropdownMenuItem(value: 'monthly', child: Text('This Month')),
          DropdownMenuItem(value: 'yearly', child: Text('This Year')),
        ],
      ),
    ),
    );
  }

  Widget _buildEarningsChartCard() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(color: Colors.black.withValues(alpha: 0.06), blurRadius: 16, offset: const Offset(0, 6))
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                controller.currentPeriodEarnings.value,
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: AppColors.mainColor,
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: AppColors.green.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  controller.currentPeriodGrowth.value,
                  style: TextStyle(color: AppColors.green, fontWeight: FontWeight.bold, fontSize: 13),
                ),
              ),
            ],
          ),
          sh8,
          Text(_getPeriodSubtitle(), style: TextStyle(color: AppColors.hintColor, fontSize: 13)),
          sh20,

          // Chart
          SizedBox(
            height: controller.selectedPeriod.value == 'yearly' ? 260 : 230,
            child: LineChart(
              LineChartData(
                gridData: const FlGridData(show: false),
                titlesData: FlTitlesData(
                  topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                  rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                  leftTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      reservedSize: 38,
                      interval: 1,
                      getTitlesWidget: (value, meta) {
                        final labels = _getBottomLabels();
                        final index = value.toInt();
                        if (index < 0 || index >= labels.length) return const SizedBox.shrink();
                        return SideTitleWidget(
                          meta: meta,
                          space: 10,
                          child: Text(
                            labels[index],
                            style: TextStyle(fontSize: 12, color: AppColors.hintColor),
                          ),
                        );
                      },
                    ),
                  ),
                ),
                borderData: FlBorderData(show: false),
                lineTouchData: LineTouchData(
                  enabled: true,
                  touchTooltipData: LineTouchTooltipData(
                  //  tooltipBgColor: AppColors.blackNav.withOpacity(0.9),
                  //  tooltipRoundedRadius: 8,
                    getTooltipItems: (spots) => spots.map((spot) => LineTooltipItem(
                      '\$${(spot.y/1000).toStringAsFixed(1)}k',
                      const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                    )).toList(),
                  ),
                ),
                lineBarsData: [
                  LineChartBarData(
                    spots: controller.earningsSpots,
                    isCurved: true,
                    color: AppColors.mainColor,
                    barWidth: 5,
                    dotData: const FlDotData(show: true),
                    belowBarData: BarAreaData(
                      show: true,
                      color: AppColors.mainColor.withValues(alpha: 0.15),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  String _getPeriodSubtitle() {
    switch (controller.selectedPeriod.value) {
      case 'weekly': return 'Last 7 days';
      case 'monthly': return 'Last 30 days';
      case 'yearly': return 'Last 12 months';
      default: return '';
    }
  }

  List<String> _getBottomLabels() {
    switch (controller.selectedPeriod.value) {
      case 'weekly':
        return const ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
      case 'monthly':
      case 'yearly':
        return const ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];
      default:
        return [];
    }
  }
}