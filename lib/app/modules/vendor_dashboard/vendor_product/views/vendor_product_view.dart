// vendor_product_view.dart

import 'package:expiry_deals/app/modules/vendor_dashboard/vendor_product/views/vendor_add_product_view.dart';
import 'package:expiry_deals/common/app_color/app_colors.dart';
import 'package:expiry_deals/common/size_box/custom_sizebox.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/vendor_product_controller.dart';

class VendorProductView extends GetView<VendorProductController> {
  const VendorProductView({super.key});

  @override
  Widget build(BuildContext context) {
    Get.put(VendorProductController());

    return Scaffold(
      backgroundColor: AppColors.bgColor,
      appBar: AppBar(
        title: const Text('My Products'),
        centerTitle: true,
        backgroundColor: AppColors.mainColor,
        foregroundColor: AppColors.white,
        elevation: 0,
      ),
      // Use Stack to custom-position the FAB
      body: Stack(
        children: [
          // Main Content
          Obx(() {
            if (controller.isLoading.value) {
              return const Center(
                child: CircularProgressIndicator(color: AppColors.mainColor),
              );
            }

            if (controller.products.isEmpty) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.inventory_2_outlined, size: 80, color: Colors.grey[400]),
                    sh20,
                    Text('No products yet', style: TextStyle(fontSize: 18, color: Colors.grey[600])),
                    sh10,
                    Text('Tap + Add Product to get started', style: TextStyle(color: Colors.grey[500])),
                  ],
                ),
              );
            }

            return GridView.builder(
              padding: const EdgeInsets.all(16),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 0.75,
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
              ),
              itemCount: controller.products.length,
              itemBuilder: (context, index) {
                final product = controller.products[index];
                return _buildProductCard(product);
              },
            );
          }),

          // Custom Positioned FAB — 300px from bottom
          Positioned(
            bottom: 150, // exactly 300px up from bottom
            right: 20,
            child: FloatingActionButton.extended(
              onPressed: () {
                Get.to(() => VendorAddProductView());
              },
              backgroundColor: AppColors.mainColor,
              elevation: 8,
              highlightElevation: 12,
              icon: const Icon(Icons.add, color: Colors.white),
              label: const Text(
                'Add Product',
                style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProductCard(dynamic product) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Image + Edit Button
          ClipRRect(
            borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
            child: Stack(
              children: [
                SizedBox(
                  height: 140,
                  width: double.infinity,
                  child: Image.network(
                    product.imageUrl ?? '',
                    fit: BoxFit.cover,
                    loadingBuilder: (context, child, loadingProgress) {
                      if (loadingProgress == null) return child;
                      return Container(color: Colors.grey[200]);
                    },
                    errorBuilder: (_, __, ___) => Container(
                      color: Colors.grey[200],
                      child: Icon(Icons.image, size: 60, color: Colors.grey[400]),
                    ),
                  ),
                ),
                // Edit Icon
                Positioned(
                  top: 8,
                  right: 8,
                  child: GestureDetector(
                    onTap: () => Get.toNamed('/vendor/edit-product', arguments: product),
                    child: Container(
                      padding: const EdgeInsets.all(6),
                      decoration: BoxDecoration(
                        color: AppColors.white,
                        shape: BoxShape.circle,
                        boxShadow: [BoxShadow(color: Colors.black26, blurRadius: 6)],
                      ),
                      child: Icon(Icons.edit, size: 18, color: AppColors.mainColor),
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Details
          Padding(
            padding: const EdgeInsets.fromLTRB(12, 12, 12, 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  product.name ?? 'Product Name',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textColor,
                    height: 1.3,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                sh10,
                Text(
                  '\$${product.price?.toStringAsFixed(2) ?? '0.00'}',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: AppColors.mainColor,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}