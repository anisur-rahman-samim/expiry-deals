import 'package:expiry_deals/app/modules/vendor_dashboard/controllers/vendor_dashboard_controller.dart';
import 'package:expiry_deals/app/modules/vendor_dashboard/vendor_home/views/vendor_home_view.dart';
import 'package:expiry_deals/app/modules/vendor_dashboard/vendor_order/views/vendor_order_view.dart';
import 'package:expiry_deals/app/modules/vendor_dashboard/vendor_product/views/vendor_product_view.dart';
import 'package:expiry_deals/app/modules/vendor_dashboard/vendor_profile/views/vendor_profile_view.dart';
import 'package:expiry_deals/common/app_color/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:crystal_navigation_bar/crystal_navigation_bar.dart';


class VendorDashboardView extends GetView<VendorDashboardController> {
   VendorDashboardView({super.key});

  // List of pages
  static final List<Widget> _pages = [
    VendorHomeView(),
     VendorProductView(),
     VendorOrderView(),
     VendorProfileView(),
     
  ];

  // Icons for the bar
  final List<CrystalNavigationBarItem> _items = [
    CrystalNavigationBarItem(
      unselectedIcon: Icons.home_outlined,
      icon: Icons.home,

    ),
    CrystalNavigationBarItem(
      unselectedIcon: Icons.add,
      icon: Icons.add,
    ),
    CrystalNavigationBarItem(
      unselectedIcon: Icons.list_alt,
      icon: Icons.list_alt,
    ),
    CrystalNavigationBarItem(
      unselectedIcon: Icons.person_outline,
      icon: Icons.person,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    Get.put(VendorDashboardController());
    return Scaffold(
      extendBody: true, // Important: allows the body to go behind the nav bar
      body: Obx(() => IndexedStack(
        index: controller.currentIndex.value,
        children: _pages,
      )),
      bottomNavigationBar: Obx(() => CrystalNavigationBar(
        currentIndex: controller.currentIndex.value,
        onTap: controller.changePage,
        items: _items,
        backgroundColor: AppColors.blackNav,
        unselectedItemColor: Colors.grey,
        selectedItemColor: AppColors.white,
        splashColor: AppColors.white,
        splashBorderRadius: 40,
        indicatorColor: AppColors.mainColor,
        curve: Curves.easeInOut,
        duration: const Duration(milliseconds: 400),
        height: 70,
        borderRadius: 40.0,
      ),)
    );
  }
}