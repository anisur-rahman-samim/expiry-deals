import 'package:expiry_deals/app/modules/auth/views/login_view.dart';
import 'package:expiry_deals/app/modules/browse/controllers/browse_controller.dart';
import 'package:expiry_deals/app/modules/home/controllers/near_me_stores_controller.dart';
import 'package:expiry_deals/app/modules/home/model/near_me_stores_model.dart';
import 'package:expiry_deals/app/modules/product_details/views/product_details_view.dart';
import 'package:expiry_deals/app/modules/store/model/store_wise_product_model.dart'
    hide Image;
import 'package:expiry_deals/app/modules/store/views/store_view.dart';
import 'package:expiry_deals/common/app_color/app_colors.dart';
import 'package:expiry_deals/common/app_images/app_images.dart';
import 'package:expiry_deals/common/app_text_style/styles.dart';
import 'package:expiry_deals/common/helper/local_store.dart';
import 'package:expiry_deals/common/app_constant/app_constant.dart';
import 'package:expiry_deals/common/widgets/adaptive_loading.dart';
import 'package:expiry_deals/common/widgets/search_radius_mile_control.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

class BrowseView extends StatelessWidget {
  const BrowseView({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(BrowseController());
    final nearMe = Get.isRegistered<NearMeStoresController>()
        ? Get.find<NearMeStoresController>()
        : Get.put(NearMeStoresController());

    final token = LocalStorage.getData(key: AppConstant.token);
    final signedIn = token != null && token is String && token.isNotEmpty;

    return Scaffold(
      backgroundColor: AppColors.bgColor,
      appBar: AppBar(
        title: Text(
          'Browse stores',
          style: GoogleFonts.dmSans(fontSize: 17, fontWeight: FontWeight.w600),
        ),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          if (signedIn)
            Obx(
              () => Padding(
                padding: const EdgeInsets.fromLTRB(16, 8, 16, 4),
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 14,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.white,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: AppColors.grayLight.withValues(alpha: 0.85),
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.04),
                        blurRadius: 12,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Text(
                        'Browse by',
                        style: h4.copyWith(
                          fontWeight: FontWeight.w700,
                          fontSize: 15,
                          letterSpacing: -0.2,
                        ),
                      ),
                      const SizedBox(height: 10),
                      SegmentedButton<bool>(
                        style: SegmentedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 10,
                          ),
                          minimumSize: const Size(0, 44),
                          selectedBackgroundColor: AppColors.mainColor
                              .withValues(alpha: 0.18),
                          selectedForegroundColor: AppColors.mainColor,
                          foregroundColor: AppColors.black,
                        ),
                        segments: const [
                          ButtonSegment<bool>(
                            value: false,
                            label: Text('Nearby'),
                            icon: Icon(Icons.near_me_outlined, size: 18),
                          ),
                          ButtonSegment<bool>(
                            value: true,
                            label: Text('Everywhere'),
                            icon: Icon(Icons.public_outlined, size: 18),
                          ),
                        ],
                        selected: {nearMe.browseEverywhere.value},
                        onSelectionChanged: (Set<bool> next) async {
                          final v = next.first;
                          if (v == nearMe.browseEverywhere.value) return;
                          await nearMe.setBrowseEverywhere(v);
                          await controller.refreshAll();
                        },
                      ),
                      if (!nearMe.browseEverywhere.value) ...[
                        const SizedBox(height: 12),
                        Row(
                          children: [
                            Expanded(
                              child: Text(
                                'Search radius',
                                style: h4.copyWith(
                                  fontWeight: FontWeight.w500,
                                  fontSize: 14,
                                  color: AppColors.hintColor,
                                ),
                              ),
                            ),
                            SearchRadiusMileButton(controller: nearMe),
                          ],
                        ),
                      ] else ...[
                        const SizedBox(height: 8),
                        Text(
                          'Stores from all locations (no distance limit on this list). Up to 50 per page.',
                          style: h4.copyWith(
                            color: AppColors.hintColor,
                            fontSize: 12,
                            height: 1.35,
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
              ),
            ),
          Expanded(
            child: Obx(() {
              if (nearMe.isBrowseLoading.value &&
                  nearMe.browseAllStores.isEmpty) {
                return const Center(child: AdaptiveLoading());
              }

              final token = LocalStorage.getData(key: AppConstant.token);
              if (token == null || token.isEmpty) {
                return Center(
                  child: Padding(
                    padding: const EdgeInsets.all(24),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Sign in to browse stores and products near you.',
                          textAlign: TextAlign.center,
                          style: h4.copyWith(color: AppColors.hintColor),
                        ),
                        const SizedBox(height: 16),
                        TextButton(
                          onPressed: () => Get.to(() => LoginView()),
                          child: Text(
                            'Sign in',
                            style: h4.copyWith(color: AppColors.mainColor),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }

              if (nearMe.browseAllStores.isEmpty) {
                final err = nearMe.lastErrorMessage.value;
                final needsLocation = err.contains('Location is required');
                return Center(
                  child: Padding(
                    padding: const EdgeInsets.all(24),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          needsLocation
                              ? Icons.location_off_outlined
                              : Icons.storefront_outlined,
                          size: 64,
                          color: AppColors.gray,
                        ),
                        const SizedBox(height: 16),
                        Text(
                          needsLocation && err.isNotEmpty
                              ? err
                              : (err.isNotEmpty
                                    ? err
                                    : 'No stores in your area for this search radius. Try increasing it above.'),
                          style: h4.copyWith(color: AppColors.hintColor),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 16),
                        OutlinedButton.icon(
                          onPressed: () => controller.refreshAll(),
                          icon: const Icon(Icons.refresh_rounded, size: 20),
                          label: const Text('Retry'),
                        ),
                      ],
                    ),
                  ),
                );
              }

              return RefreshIndicator(
                color: AppColors.mainColor,
                onRefresh: () => controller.refreshAll(),
                child: ListView.builder(
                  padding: const EdgeInsets.fromLTRB(16, 8, 16, 100),
                  itemCount: nearMe.browseAllStores.length,
                  itemBuilder: (context, index) {
                    final store = nearMe.browseAllStores[index];
                    final authorId = store.author?.id ?? '';
                    return _storeBlock(
                      controller: controller,
                      store: store,
                      authorId: authorId,
                      nearMe: nearMe,
                    );
                  },
                ),
              );
            }),
          ),
        ],
      ),
    );
  }

  Widget _storeBlock({
    required BrowseController controller,
    required NearMeStores store,
    required String authorId,
    required NearMeStoresController nearMe,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 28),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          GestureDetector(
            onTap: () {
              final sid = store.id;
              final aid = store.author?.id;
              if (sid == null || aid == null) return;
              Get.to(() => StoreView(shopId: sid, authorId: aid));
            },
            child: Row(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(14),
                  child: Image.network(
                    store.logo ?? AppImages.noImage,
                    width: 52,
                    height: 52,
                    fit: BoxFit.cover,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        store.name ?? 'Store',
                        style: h2.copyWith(fontSize: 17),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      if (nearMe.distanceLabel(store).isNotEmpty)
                        Text(
                          nearMe.distanceLabel(store),
                          style: h4.copyWith(
                            color: AppColors.hintColor,
                            fontSize: 12,
                          ),
                        ),
                    ],
                  ),
                ),
                Icon(Icons.chevron_right, color: AppColors.hintColor),
              ],
            ),
          ),
          const SizedBox(height: 12),
          Obx(() {
            final loading = controller.loadingAuthorIds.contains(authorId);
            final products = authorId.isEmpty
                ? <StoreWiseProduct>[]
                : (controller.productsByAuthorId[authorId] ?? []);

            if (loading && products.isEmpty) {
              return SizedBox(
                height: 200,
                child: Center(
                  child: SizedBox(
                    width: 28,
                    height: 28,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: AppColors.mainColor,
                    ),
                  ),
                ),
              );
            }

            if (products.isEmpty) {
              return Padding(
                padding: const EdgeInsets.only(left: 4, bottom: 8),
                child: Text(
                  'No products listed',
                  style: h4.copyWith(color: AppColors.hintColor, fontSize: 13),
                ),
              );
            }

            return SizedBox(
              height: 200,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                itemCount: products.length,
                separatorBuilder: (_, __) => const SizedBox(width: 12),
                itemBuilder: (context, i) {
                  return _productTile(products[i]);
                },
              ),
            );
          }),
        ],
      ),
    );
  }

  Widget _productTile(StoreWiseProduct p) {
    final img = p.images.isNotEmpty
        ? (p.images[0].url ?? AppImages.noImage)
        : AppImages.noImage;
    final rawDiscount = p.discount;
    final discountPct = rawDiscount is num ? rawDiscount.toDouble() : 0.0;
    final price = p.price is num ? (p.price as num).toDouble() : 0.0;
    final hasDiscount = discountPct > 0;
    final salePrice = hasDiscount ? price * (1 - discountPct / 100) : price;

    return GestureDetector(
      onTap: () => Get.to(() => ProductDetailsView(productId: p.id ?? '')),
      child: Container(
        width: 140,
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.06),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              children: [
                ClipRRect(
                  borderRadius: const BorderRadius.vertical(
                    top: Radius.circular(16),
                  ),
                  child: Image.network(
                    img,
                    height: 110,
                    width: 140,
                    fit: BoxFit.cover,
                  ),
                ),
                if (hasDiscount)
                  Positioned(
                    top: 8,
                    left: 8,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.red,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        '-${discountPct.toStringAsFixed(0)}%',
                        style: GoogleFonts.dmSans(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 10,
                        ),
                      ),
                    ),
                  ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.all(10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    p.name ?? '',
                    style: h4.copyWith(fontSize: 13),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '\$${salePrice.toStringAsFixed(2)}',
                    style: h3.copyWith(
                      color: AppColors.mainColor,
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
