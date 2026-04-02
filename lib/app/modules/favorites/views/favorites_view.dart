import 'package:expiry_deals/app/modules/favorites/controllers/favorites_controller.dart';
import 'package:expiry_deals/app/modules/home/model/product_model.dart' as allProduct;
import 'package:expiry_deals/app/modules/product_details/views/product_details_view.dart';
import 'package:expiry_deals/common/app_color/app_colors.dart';
import 'package:expiry_deals/common/app_images/app_images.dart';
import 'package:expiry_deals/common/app_text_style/styles.dart';
import 'package:expiry_deals/common/size_box/custom_sizebox.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

class FavoritesView extends StatefulWidget {
  const FavoritesView({super.key});

  @override
  State<FavoritesView> createState() => _FavoritesViewState();
}

class _FavoritesViewState extends State<FavoritesView> {
  final FavoritesController fav = Get.find<FavoritesController>();

  @override
  void initState() {
    super.initState();
    fav.refreshProducts();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bgColor,
      appBar: AppBar(
        title: Text(
          'Saved',
          style: GoogleFonts.dmSans(fontSize: 18, fontWeight: FontWeight.w700),
        ),
        backgroundColor: AppColors.bgColor,
        foregroundColor: AppColors.black,
        elevation: 0,
      ),
      body: Obx(() {
        if (fav.ids.isEmpty) {
          return Center(
            child: Padding(
              padding: const EdgeInsets.all(32),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.favorite_outline_rounded,
                    size: 56,
                    color: AppColors.hintColor.withValues(alpha: 0.6),
                  ),
                  sh16,
                  Text(
                    'No saved items yet',
                    style: h3.copyWith(color: AppColors.black),
                  ),
                  sh8,
                  Text(
                    'Tap the heart on a product to save it here.',
                    textAlign: TextAlign.center,
                    style: h5.copyWith(color: AppColors.hintColor),
                  ),
                ],
              ),
            ),
          );
        }
        if (fav.isLoadingList.value && fav.products.isEmpty) {
          return const Center(
            child: CircularProgressIndicator(color: AppColors.mainColor),
          );
        }
        return RefreshIndicator(
          color: AppColors.mainColor,
          onRefresh: () => fav.refreshProducts(),
          child: GridView.builder(
            padding: const EdgeInsets.all(16),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              childAspectRatio: 0.78,
              crossAxisSpacing: 16,
              mainAxisSpacing: 16,
            ),
            itemCount: fav.products.length,
            itemBuilder: (ctx, i) =>
                _FavoriteTile(product: fav.products[i], fav: fav),
          ),
        );
      }),
    );
  }
}

class _FavoriteTile extends StatelessWidget {
  const _FavoriteTile({
    required this.product,
    required this.fav,
  });

  final allProduct.Products product;
  final FavoritesController fav;

  @override
  Widget build(BuildContext context) {
    final img = product.images.isNotEmpty
        ? (product.images.first.url ?? AppImages.noImage)
        : AppImages.noImage;
    final id = product.id ?? '';

    return GestureDetector(
      onTap: () => Get.to(() => ProductDetailsView(productId: id)),
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(18),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.05),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Stack(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: ClipRRect(
                    borderRadius:
                        const BorderRadius.vertical(top: Radius.circular(18)),
                    child: Image.network(
                      img,
                      width: double.infinity,
                      fit: BoxFit.cover,
                      errorBuilder: (_, __, ___) => ColoredBox(
                        color: AppColors.grayLight,
                        child: Icon(Icons.image_outlined, color: AppColors.hintColor),
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        product.name ?? '',
                        style: h4.copyWith(fontWeight: FontWeight.w600),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 6),
                      Text(
                        '\$${((product.price ?? 0) * (1 - (product.discount ?? 0) / 100)).toStringAsFixed(2)}',
                        style: h3.copyWith(
                          color: AppColors.mainColor,
                          fontWeight: FontWeight.w800,
                          fontSize: 15,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            Positioned(
              top: 8,
              right: 8,
              child: Material(
                color: Colors.white.withValues(alpha: 0.95),
                shape: const CircleBorder(),
                clipBehavior: Clip.antiAlias,
                child: InkWell(
                  onTap: () async {
                    await fav.toggle(id);
                    await fav.refreshProducts();
                  },
                  child: const Padding(
                    padding: EdgeInsets.all(6),
                    child: Icon(
                      Icons.favorite_rounded,
                      size: 18,
                      color: AppColors.red,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
