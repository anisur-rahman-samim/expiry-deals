import 'package:expiry_deals/app/modules/home/controllers/search_product_controller.dart';
import 'package:expiry_deals/app/modules/home/model/search_product_model.dart' as searchProduct;
import 'package:expiry_deals/app/modules/product_details/views/product_details_view.dart';
import 'package:expiry_deals/common/app_color/app_colors.dart';
import 'package:expiry_deals/common/app_images/app_images.dart';
import 'package:expiry_deals/common/app_text_style/styles.dart';
import 'package:expiry_deals/common/size_box/custom_sizebox.dart';
import 'package:expiry_deals/common/widgets/adaptive_loading.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

class SearchPageView extends StatelessWidget {
  SearchPageView({super.key});

  final SearchProductController controller = Get.put(SearchProductController());

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return Scaffold(
      backgroundColor: scheme.surface,
      appBar: AppBar(
        backgroundColor: scheme.surface,
        elevation: 0,
        scrolledUnderElevation: 0,
        titleSpacing: 12,
        title: _buildSearchBar(context),
      ),
      body: Obx(() {
        controller.similarProducts.length;
        controller.showingSimilarFallback.value;

        if (controller.isLoading.value) {
          return const Center(child: AdaptiveLoading());
        }

        if (controller.searchQuery.value.isEmpty) {
          return _buildSearchResults();
        }

        if (controller.searchProducts.isEmpty) {
          return _buildEmptyResults();
        }

        return _buildSearchResults();
      }),
    );
  }

  Widget _buildSearchBar(BuildContext context) {
    return Container(
      height: 48,
      padding: const EdgeInsets.symmetric(horizontal: 4),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: AppColors.grayLight.withValues(alpha: 0.9),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: TextField(
        controller: controller.searchController,
        onChanged: controller.onSearchChanged,
        textInputAction: TextInputAction.search,
        textAlignVertical: TextAlignVertical.center,
        style: h4.copyWith(fontSize: 16),
        decoration: InputDecoration(
          isDense: true,
          hintText: 'Search products',
          hintStyle: h4.copyWith(color: AppColors.hintColor, fontSize: 16),
          border: InputBorder.none,
          prefixIcon: const Icon(Icons.search_rounded, color: AppColors.hintColor, size: 22),
          prefixIconConstraints: const BoxConstraints(minWidth: 44, minHeight: 44),
          suffixIcon: Obx(() => controller.searchQuery.value.isNotEmpty
              ? IconButton(
                  icon: const Icon(Icons.clear_rounded, color: AppColors.hintColor, size: 22),
                  onPressed: controller.clearSearch,
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(minWidth: 44, minHeight: 44),
                )
              : const SizedBox()),
        ),
      ),
    );
  }

  Widget _buildSearchResults() {
    return RefreshIndicator(
      onRefresh: () async => controller.fetchSearchProducts(search: controller.searchQuery.value),
      color: AppColors.mainColor,
      child: GridView.builder(
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          childAspectRatio: 0.78,
          crossAxisSpacing: 14,
          mainAxisSpacing: 14,
        ),
        itemCount: controller.searchProducts.length,
        itemBuilder: (context, index) {
          return productCard(controller.searchProducts[index]);
        },
      ),
    );
  }

  Widget productCard(searchProduct.SearchProduct product) {
    return Material(
      color: AppColors.white,
      borderRadius: BorderRadius.circular(16),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: () {
          Get.to(() => ProductDetailsView(productId: product.id ?? ''));
        },
        child: Ink(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: AppColors.grayLight.withValues(alpha: 0.65)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Stack(
                children: [
                  ClipRRect(
                    borderRadius: const BorderRadius.vertical(top: Radius.circular(15)),
                    child: Image.network(
                      product.images.isNotEmpty
                          ? product.images[0].url ?? AppImages.noImage
                          : AppImages.noImage,
                      height: 140,
                      width: double.infinity,
                      fit: BoxFit.cover,
                    ),
                  ),
                  Positioned(
                    top: 10,
                    left: 10,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                      decoration: BoxDecoration(
                        color: AppColors.red,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        '-${product.discount}% OFF',
                        style: GoogleFonts.dmSans(
                          color: Colors.white,
                          fontWeight: FontWeight.w700,
                          fontSize: 11,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(12, 12, 12, 14),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      product.name ?? 'Product Name',
                      style: h4.copyWith(fontWeight: FontWeight.w600, fontSize: 14),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Text(
                          '\$${((product.price ?? 0) * (1 - (product.discount ?? 0) / 100)).toStringAsFixed(2)}',
                          style: h3.copyWith(
                            color: AppColors.mainColor,
                            fontWeight: FontWeight.w700,
                            fontSize: 15,
                          ),
                        ),
                        sw5,
                        Text(
                          '\$${product.price?.toStringAsFixed(2) ?? '0.00'}',
                          style: h3.copyWith(
                            color: AppColors.gray,
                            fontWeight: FontWeight.w500,
                            fontSize: 13,
                            decoration: TextDecoration.lineThrough,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildEmptyResults() {
    return RefreshIndicator(
      onRefresh: () async =>
          controller.fetchSearchProducts(search: controller.searchQuery.value),
      color: AppColors.mainColor,
      child: Builder(
        builder: (context) {
          final similar = controller.similarProducts;
          return CustomScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            slivers: [
              SliverToBoxAdapter(
                child: Padding(
                  padding: EdgeInsets.only(top: Get.height * 0.08),
                  child: Column(
                    children: [
                      Container(
                        width: 88,
                        height: 88,
                        decoration: BoxDecoration(
                          color: AppColors.mainColor.withValues(alpha: 0.12),
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          Icons.search_rounded,
                          size: 36,
                          color: AppColors.mainColor.withValues(alpha: 0.85),
                        ),
                      ),
                      const SizedBox(height: 24),
                      Text(
                        similar.isEmpty ? 'No products found' : 'No exact matches',
                        style: h2.copyWith(fontSize: 22, fontWeight: FontWeight.w700),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 10),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 28),
                        child: Text(
                          similar.isEmpty
                              ? 'Try different keywords or check spelling.'
                              : 'We couldn’t match that exactly — here are a few picks you might like.',
                          style: h4.copyWith(
                            color: AppColors.hintColor,
                            fontSize: 15,
                            height: 1.45,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                      if (similar.isNotEmpty) ...[
                        const SizedBox(height: 32),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          child: Row(
                            children: [
                              Container(
                                width: 4,
                                height: 22,
                                decoration: BoxDecoration(
                                  color: AppColors.mainColor,
                                  borderRadius: BorderRadius.circular(2),
                                ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Text(
                                  'You might like',
                                  style: h2.copyWith(
                                    fontSize: 18,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
              ),
              if (similar.isNotEmpty)
                SliverPadding(
                  padding: const EdgeInsets.fromLTRB(16, 12, 16, 32),
                  sliver: SliverGrid(
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      childAspectRatio: 0.78,
                      crossAxisSpacing: 14,
                      mainAxisSpacing: 14,
                    ),
                    delegate: SliverChildBuilderDelegate(
                      (context, index) => productCard(similar[index]),
                      childCount: similar.length,
                    ),
                  ),
                ),
            ],
          );
        },
      ),
    );
  }
}
