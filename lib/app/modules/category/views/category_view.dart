// category_view.dart
import 'package:expiry_deals/app/modules/category/views/category_product_view.dart';
import 'package:expiry_deals/common/app_color/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';


class CategoryView extends StatelessWidget {
  const CategoryView({super.key});

  // Category Data: name + icon + color (optional)
  final List<Map<String, dynamic>> categories = const [
    {'name': 'T-Shirts', 'icon': Icons.checkroom, 'color': Colors.orange},
    {'name': 'Shirts', 'icon': Icons.checkroom_outlined, 'color': Colors.blue},
    {'name': 'Jeans', 'icon': Icons.checkroom_rounded, 'color': Colors.indigo},
    {'name': 'Shoes', 'icon': Icons.shopping_bag, 'color': Colors.purple},
    {'name': 'Dresses', 'icon': Icons.accessibility_new, 'color': Colors.pink},
    {'name': 'Jackets', 'icon': Icons.ac_unit, 'color': Colors.red},
    {'name': 'Bags', 'icon': Icons.shopping_basket, 'color': Colors.green},
    {'name': 'Watches', 'icon': Icons.watch_later, 'color': Colors.teal},
    {'name': 'Sunglasses', 'icon': Icons.visibility, 'color': Colors.amber},
    {'name': 'Jewelry', 'icon': Icons.diamond, 'color': Colors.cyan},
    {'name': 'Hats', 'icon': Icons.person_outline, 'color': Colors.brown},
    {'name': 'Belts', 'icon': Icons.linear_scale, 'color': Colors.grey},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bgColor,
      appBar: AppBar(
        title: Text(
          'All Categories',
          style: GoogleFonts.dmSans(fontSize: 22, fontWeight: FontWeight.w700),
        ),
        centerTitle: true,
        backgroundColor: AppColors.bgColor,
        elevation: 0,
        foregroundColor: AppColors.black,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: GridView.builder(
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 4, // 4 columns
            childAspectRatio: 0.9, // Square + text
            crossAxisSpacing: 16,
            mainAxisSpacing: 16,
          ),
          itemCount: categories.length,
          itemBuilder: (context, index) {
            final category = categories[index];
            return _categoryGridItem(
              name: category['name'],
              icon: category['icon'],
              color: category['color'],
            );
          },
        ),
      ),
    );
  }

  Widget _categoryGridItem({
    required String name,
    required IconData icon,
    required Color color,
  }) {
    return GestureDetector(
      onTap: () {
        Get.to(() =>  CategoryProductView(), arguments: name);
      },
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: AppColors.grayLight.withValues(alpha: 0.5),),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.6),
              blurRadius: 12,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Icon with Background Circle
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.15),
                shape: BoxShape.circle,
              ),
              child: Icon(
                icon,
                size: 32,
                color: color,
              ),
            ),
            const SizedBox(height: 12),

            // Category Name
            Text(
              name,
              style: GoogleFonts.dmSans(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: AppColors.black,
              ),
              textAlign: TextAlign.center,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }
}