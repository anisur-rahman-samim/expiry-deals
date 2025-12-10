// vendor_home_controller.dart

import 'package:fl_chart/fl_chart.dart';
import 'package:get/get.dart';

class VendorHomeController extends GetxController {
  // ─────────────────────────────────────
  // Dashboard Stats
  // ─────────────────────────────────────
  var totalRevenue = '\$124,850'.obs;
  var totalOrders = '342'.obs;
  var activeProducts = '89'.obs;
  var pendingOrders = '12'.obs;

  // Current period total & growth (changes based on selected period)
  var currentPeriodEarnings = '\$18,450'.obs;
  var currentPeriodGrowth = '+12.5%'.obs;

  // ─────────────────────────────────────
  // Chart Period Selection
  // ─────────────────────────────────────
  final selectedPeriod = 'weekly'.obs; // 'weekly' | 'monthly' | 'yearly'

  // Dynamic chart data
  var earningsSpots = <FlSpot>[].obs;

  // ─────────────────────────────────────
  // Lifecycle
  // ─────────────────────────────────────
  @override
  void onInit() {
    super.onInit();
    _loadInitialData();
    fetchDashboardData(); // You can merge this with real API later
  }

  // ─────────────────────────────────────
  // Public Methods
  // ─────────────────────────────────────
  void changePeriod(String period) {
    if (selectedPeriod.value == period) return;

    selectedPeriod.value = period;
    _updateChartAndSummary();
  }

  Future<void> fetchDashboardData() async {
    // Simulate API call
    await Future.delayed(const Duration(milliseconds: 800));

    // ───── Your real API data will go here ─────
    totalRevenue.value = '\$148,920';
    totalOrders.value = '398';
    activeProducts.value = '104';
    pendingOrders.value = '8';

    // Update chart & summary based on current selected period
    _updateChartAndSummary();
  }

  // ─────────────────────────────────────
  // Private Helpers
  // ─────────────────────────────────────
  void _loadInitialData() {
    // Default = weekly
    selectedPeriod.value = 'weekly';
    _updateChartAndSummary();
  }

  void _updateChartAndSummary() {
    switch (selectedPeriod.value) {
      case 'weekly':
        earningsSpots.value = [
          const FlSpot(0, 2100),
          const FlSpot(1, 2800),
          const FlSpot(2, 1900),
          const FlSpot(3, 3400),
          const FlSpot(4, 4200),
          const FlSpot(5, 3800),
          const FlSpot(6, 4600),
        ];
        currentPeriodEarnings.value = '\$18,450';
        currentPeriodGrowth.value = '+12.5%';
        break;

      case 'monthly':
        earningsSpots.value = [
          const FlSpot(0, 8200),
          const FlSpot(1, 9500),
          const FlSpot(2, 8800),
          const FlSpot(3, 11200),
          const FlSpot(4, 10500),
          const FlSpot(5, 12800),
          const FlSpot(6, 14100),
          const FlSpot(7, 13500),
          const FlSpot(8, 15200),
          const FlSpot(9, 16800),
          const FlSpot(10, 15900),
          const FlSpot(11, 18200),
        ];
        currentPeriodEarnings.value = '\$147,000';
        currentPeriodGrowth.value = '+28.3%';
        break;

      case 'yearly':
        earningsSpots.value = [
          const FlSpot(0, 98000),
          const FlSpot(1, 112000),
          const FlSpot(2, 105000),
          const FlSpot(3, 138000),
          const FlSpot(4, 129000),
          const FlSpot(5, 156000),
          const FlSpot(6, 172000),
          const FlSpot(7, 165000),
          const FlSpot(8, 188000),
          const FlSpot(9, 205000),
          const FlSpot(10, 198000),
          const FlSpot(11, 225000),
        ];
        currentPeriodEarnings.value = '\$1,891,000';
        currentPeriodGrowth.value = '+47.8%';
        break;
    }
  }
}