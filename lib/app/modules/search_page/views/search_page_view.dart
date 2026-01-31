import 'package:expiry_deals/app/modules/home/controllers/search_product_controller.dart';
import 'package:expiry_deals/app/modules/home/model/search_product_model.dart' as searchProduct;
import 'package:expiry_deals/app/modules/product_details/views/product_details_view.dart';
import 'package:expiry_deals/app/modules/search_page/controllers/search_page_controller.dart';
import 'package:expiry_deals/common/app_color/app_colors.dart';
import 'package:expiry_deals/common/app_images/app_images.dart';
import 'package:expiry_deals/common/app_text_style/styles.dart';
import 'package:expiry_deals/common/size_box/custom_sizebox.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SearchPageView extends StatelessWidget {
  SearchPageView({super.key});

  final SearchProductController controller = Get.put(SearchProductController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bgColor,
      appBar: AppBar(
        backgroundColor: AppColors.bgColor,
        elevation: 0,
        title: _buildSearchBar(),
        centerTitle: false,
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator(color: AppColors.mainColor));
        }

        if (controller.searchQuery.value.isEmpty) {
          // If search query is empty, show all products
          return _buildSearchResults();
        }

        if (controller.searchProducts.isEmpty) {
          return _buildEmptyResults();
        }

        return _buildSearchResults();
      }),
    );
  }

  // Search Bar widget
  Widget _buildSearchBar() {
    return Container(
      height: 48,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(30),
        border: Border.all(color: AppColors.grayLight),
      ),
      child: TextField(
        controller: controller.searchController,
        onChanged: controller.onSearchChanged,
        decoration: InputDecoration(
          hintText: 'Search products...',
          hintStyle: h4.copyWith(color: AppColors.hintColor),
          border: InputBorder.none,
          prefixIcon: const Icon(Icons.search, color: AppColors.hintColor),
          suffixIcon: Obx(() => controller.searchQuery.value.isNotEmpty
              ? IconButton(
            icon: const Icon(Icons.clear, color: AppColors.hintColor),
            onPressed: controller.clearSearch,
          )
              : const SizedBox()),
        ),
      ),
    );
  }





  // Show search results based on user query
  Widget _buildSearchResults() {
    return RefreshIndicator(
      onRefresh: () async => await Future.delayed(const Duration(seconds: 1)),
      color: AppColors.mainColor,
      child: GridView.builder(
        padding: const EdgeInsets.all(16),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          childAspectRatio: 0.78,
          crossAxisSpacing: 16,
          mainAxisSpacing: 16,
        ),
        itemCount: controller.searchProducts.length,
        itemBuilder: (context, index) {
          final product = controller.searchProducts[index];
          return productCard(product);
        },
      ),
    );
  }

  // Display individual product card
  Widget productCard(searchProduct.SearchProduct product) {
    return GestureDetector(
      onTap: (){
        Get.to(() => ProductDetailsView(productId: product.id ?? ""));
      },
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.06), blurRadius: 12, offset: const Offset(0, 6))],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
                  borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
                  child: Image.network(
                    product.images.isNotEmpty ? product.images[0].url ?? AppImages.noImage : AppImages.noImage,
                    height: 140,
                    width: double.infinity,
                    fit: BoxFit.cover,
                  ),
                ),
            Padding(
              padding: const EdgeInsets.all(14),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    product.name ?? 'Product Name',
                    style: h4,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 8),
                 Row(
                   children: [
                     Text(
                       '\$${product.discount?.toStringAsFixed(2) ?? '0.00'}',
                       style: h3.copyWith(color: AppColors.mainColor, fontWeight: FontWeight.bold),
                     ),
                     sw5,
                     Text(
                       '\$${product.price?.toStringAsFixed(2) ?? '0.00'}',
                       style: h3.copyWith(color: AppColors.gray, fontWeight: FontWeight.bold),
                     ),
                   ],
                 )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Show message when no products are found
  Widget _buildEmptyResults() {
    return RefreshIndicator(
      onRefresh: () async {},
      child: ListView(
        physics: const AlwaysScrollableScrollPhysics(),
        children: [
          SizedBox(height: Get.height * 0.2),
          Center(
            child: Column(
              children: [
                Icon(Icons.search_off, size: 90, color: AppColors.gray),
                const SizedBox(height: 24),
                Text('No products found', style: h2.copyWith(fontSize: 22)),
                const SizedBox(height: 12),
                Text('Try searching with different keywords', style: h4.copyWith(color: AppColors.hintColor)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
