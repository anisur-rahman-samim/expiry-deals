// category_product_view.dart
import 'package:expiry_deals/app/modules/home/controllers/category_product_controller.dart';
import 'package:expiry_deals/app/modules/home/model/category_product_model.dart';
import 'package:expiry_deals/app/modules/product_details/views/product_details_view.dart';
import 'package:expiry_deals/common/app_color/app_colors.dart';
import 'package:expiry_deals/common/app_text_style/styles.dart';
import 'package:expiry_deals/common/size_box/custom_sizebox.dart';
import 'package:expiry_deals/common/widgets/custom_loader.dart';
import 'package:flutter/material.dart';
import 'package:flutter/material.dart' as material;
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';


class CategoryProductView extends StatefulWidget {
  final String categoryId;
   CategoryProductView({super.key, required this.categoryId});

  @override
  State<CategoryProductView> createState() => _CategoryProductViewState();
}

class _CategoryProductViewState extends State<CategoryProductView> {

  final CategoryProductController categoryProductController = Get.put(CategoryProductController());


  @override
  void initState() {
    categoryProductController.fetchCategoryProducts(categoryId: widget.categoryId);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // Get category name from arguments
    final String categoryName = Get.arguments ?? 'Products';

    return Scaffold(
      backgroundColor: AppColors.bgColor,
      appBar: AppBar(
        title: Text(
          categoryName,
          style: GoogleFonts.dmSans(
            fontSize: 22,
            fontWeight: FontWeight.w700,
            color: AppColors.black,
          ),
        ),
        centerTitle: true,
        backgroundColor: AppColors.bgColor,
        elevation: 0,
        foregroundColor: AppColors.black,

      ),
      body: Obx(() => categoryProductController.isLoading.value ? Center(child: SpinKitDualRing(
        color: AppColors.white,
        size: 30.0,
      ),) :  categoryProductController.categoryProducts.isEmpty? Center(child: Text("Product not available"),) : RefreshIndicator(
        onRefresh: () async => await Future.delayed(const Duration(seconds: 1)),
        color: AppColors.mainColor,
        child: GridView.builder(
          padding: const EdgeInsets.all(16),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            childAspectRatio: 0.75,
            crossAxisSpacing: 16,
            mainAxisSpacing: 16,
          ),
          itemCount: categoryProductController.categoryProducts.length,
          itemBuilder: (context, index) {
            final product = categoryProductController.categoryProducts;
            return _productCard(product,index);
          },
        ),
      ),)
    );
  }

  Widget _productCard(List<CategoryProduct> product, int index) {
    return GestureDetector(
      onTap: () {
       Get.to(() => ProductDetailsView(productId: product[index].id ?? ""));
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
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Product Image
            Stack(
              children: [
                ClipRRect(
                  borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
                  child: material.Image.network(
                    product[index].images.first.url ?? "",
                    height: 160,
                    width: double.infinity,
                    fit: BoxFit.cover,
                  ),
                ),

                Positioned(
                  top: 16, left: 16,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(color: AppColors.red, borderRadius: BorderRadius.circular(20)),
                    child: Text('-${product[index].discount}% OFF', style: GoogleFonts.dmSans(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 12)),
                  ),
                ),

              ],
            ),

            // Product Details
            Padding(
              padding: const EdgeInsets.all(14),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    product[index].name ?? "",
                    style: h4.copyWith(fontWeight: FontWeight.w600),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),

                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Text(
                        '\$${((product[index].price ?? 0) * (1 - (product[index].discount ?? 0) / 100)).toStringAsFixed(2)}',
                        style: h3.copyWith(
                          color: AppColors.mainColor,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      sw5,
                      Text(
                        '\$${product[index].price.toStringAsFixed(2)}',
                        style: h3.copyWith(
                          color: AppColors.gray,
                          fontWeight: FontWeight.bold,
                        ),
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

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.category_outlined,
            size: 90,
            color: AppColors.gray,
          ),
          const SizedBox(height: 24),
          Text(
            'No products found',
            style: h2.copyWith(fontSize: 22),
          ),
          const SizedBox(height: 12),
          Text(
            'This category is empty right now',
            style: h4.copyWith(color: AppColors.hintColor),
          ),
        ],
      ),
    );
  }
}