import 'package:expiry_deals/app/modules/browse/views/browse_view.dart';
import 'package:expiry_deals/app/modules/cart/views/cart_view.dart';
import 'package:expiry_deals/app/modules/home/views/home_view.dart';
import 'package:expiry_deals/app/modules/profile/views/profile_view.dart';
import 'package:expiry_deals/common/app_color/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:crystal_navigation_bar/crystal_navigation_bar.dart';
import '../controllers/dashboard_controller.dart';


class DashboardView extends GetView<DashboardController> {
   DashboardView({super.key});

  // List of pages
  static final List<Widget> _pages = [
    HomeView(),
    const BrowseView(),
    CartView(),
    ProfileView(),
  ];

  // Icons for the bar
  final List<CrystalNavigationBarItem> _items = [
    CrystalNavigationBarItem(
      unselectedIcon: Icons.home_outlined,
      icon: Icons.home,

    ),
    CrystalNavigationBarItem(
      unselectedIcon: Icons.storefront_outlined,
      icon: Icons.storefront,
    ),
    CrystalNavigationBarItem(
      unselectedIcon: Icons.shopping_cart_outlined,
      icon: Icons.shopping_cart,
    ),
    CrystalNavigationBarItem(
      unselectedIcon: Icons.person_outline,
      icon: Icons.person,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    Get.put(DashboardController());
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