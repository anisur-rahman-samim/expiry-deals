// category_view.dart
import 'package:expiry_deals/app/modules/category/views/category_product_view.dart';
import 'package:expiry_deals/app/modules/vendor_dashboard/vendor_product/model/category_model.dart';
import 'package:expiry_deals/common/app_color/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';


class CategoryView extends StatelessWidget {
  final List<Category> categoryList;
  const CategoryView({super.key, required this.categoryList});







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
          itemCount: categoryList.length,
          itemBuilder: (context, index) {
            final category = categoryList[index];
            return _categoryGridItem(
              id: category.id ?? "",
              name: category.name ?? "",
              icon: category.banner ?? "",
              color: AppColors.grayLight,
            );
          },
        ),
      ),
    );
  }

  Widget _categoryGridItem({
    required String id,
    required String name,
    required String icon,
    required Color color,
  }) {
    return GestureDetector(
      onTap: () {
        Get.to(() =>  CategoryProductView(categoryId: id,), arguments: name);
      },
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: AppColors.grayLight.withValues(alpha: 0.5),),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.06),
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
              child: Image.network(icon,scale: 1,)
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