import 'package:expiry_deals/app/modules/auth/views/login_view.dart';
import 'package:expiry_deals/app/modules/category/views/category_product_view.dart';
import 'package:expiry_deals/app/modules/category/views/category_view.dart';
import 'package:expiry_deals/app/modules/home/controllers/home_deals_controller.dart';
import 'package:expiry_deals/app/modules/home/controllers/near_me_stores_controller.dart';
import 'package:expiry_deals/app/modules/home/controllers/product_controller.dart';
import 'package:expiry_deals/app/modules/home/controllers/special_product_controller.dart';
import 'package:expiry_deals/app/modules/favorites/controllers/favorites_controller.dart';
import 'package:expiry_deals/app/modules/home/views/deals_list_view.dart';
import 'package:expiry_deals/common/widgets/expiry_countdown_bar.dart';
import 'package:expiry_deals/app/modules/home/model/near_me_stores_model.dart';
import 'package:expiry_deals/app/modules/home/model/product_model.dart' as allProduct;
import 'package:expiry_deals/app/modules/home/model/special_product_model.dart' as sProduct;
import 'package:expiry_deals/app/modules/home/widgets/near_me_map_preview.dart';
import 'package:expiry_deals/app/modules/home/widgets/near_me_shimmer_placeholder.dart';
import 'package:expiry_deals/app/modules/product_details/views/product_details_view.dart';
import 'package:expiry_deals/app/modules/profile/controllers/profile_controller.dart';
import 'package:expiry_deals/app/modules/profile/views/profile_photo_preview_view.dart';
import 'package:expiry_deals/app/modules/search_page/views/search_page_view.dart';
import 'package:expiry_deals/app/modules/store/views/store_view.dart';
import 'package:expiry_deals/app/routes/app_pages.dart';
import 'package:expiry_deals/app/modules/vendor_dashboard/vendor_product/controllers/category_controller.dart';
import 'package:expiry_deals/common/app_color/app_colors.dart';
import 'package:expiry_deals/common/app_images/app_images.dart';
import 'package:expiry_deals/common/app_text_style/styles.dart';
import 'package:expiry_deals/common/size_box/custom_sizebox.dart';
import 'package:expiry_deals/common/widgets/search_radius_mile_control.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import '../controllers/home_controller.dart';


class HomeView extends GetView<HomeController> {
   HomeView({super.key});
   
   final ProfileController profileController = Get.put(ProfileController());
   final CategoryDataController categoryDataController = Get.put(CategoryDataController());

   final ProductController productController = Get.put(ProductController());
   final HomeDealsController homeDealsController = Get.put(HomeDealsController());
   final SpecialProductController specialProductController = Get.put(SpecialProductController());

   final NearMeStoresController nearMeStoresController = Get.put(NearMeStoresController());


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bgColor,
      body: SafeArea(
        child: NotificationListener<ScrollNotification>(
          onNotification: (ScrollNotification n) {
            final m = n.metrics;
            if (m.maxScrollExtent <= 0) return false;
            if (m.pixels >= m.maxScrollExtent - 480) {
              productController.loadMoreRecommended();
            }
            return false;
          },
          child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [

              // === Header: Hello + Profile ===
              Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Hello, Welcome', style: h5.copyWith(color: AppColors.hintColor)),
                     Obx(() =>    Text(profileController.profileData.value.data?.name?? "", style: h2.copyWith(fontSize: 20)),)
                      ],
                    ),
                  ),
                  IconButton(
                    onPressed: () => Get.toNamed(Routes.NOTIFICATIONS),
                    icon: const Icon(Icons.notifications_outlined),
                    color: AppColors.black,
                  ),
                  Obx(
                    () => Material(
                      color: Colors.transparent,
                      child: InkWell(
                        onTap: () =>
                            Get.to(() => const ProfilePhotoPreviewView()),
                        customBorder: const CircleBorder(),
                        child: CircleAvatar(
                          radius: 24,
                          backgroundColor: AppColors.grayLight,
                          backgroundImage: NetworkImage(
                            profileController.profileData.value.data?.profile ??
                                AppImages.noImage,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),

              // === Search Bar ===
              GestureDetector(
                onTap: (){
                  Get.to(() => SearchPageView());
                },
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 0),
                  height: 56, // approximate height of TextField
                  decoration: BoxDecoration(
                    color: AppColors.white,
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.05),
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: Text(
                          'Search clothes ...',
                          style: h4.copyWith(color: AppColors.hintColor),
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: AppColors.mainColor,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: const Icon(Icons.search, color: Colors.white),
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 24),
              _sectionHeader('Categories', () {
               Get.to(() => CategoryView(categoryList: categoryDataController.categories,));
              }),
              sh10,
              // === Category Chips ===
             SizedBox(
               height: 80,
               child: Obx(() => ListView.builder(
                   shrinkWrap: true,
                   scrollDirection: Axis.horizontal,
                   itemCount: categoryDataController.categories.length,
                   itemBuilder: (context,index){
                     var item = categoryDataController.categories[index];
                     return       _categoryChip(item.id ?? "",item.name??"", item.banner ?? "");
                   }),)
             ),
              const SizedBox(height: 24),

              // === Special Offer Section ===
              _sectionHeader('Special Offer', () {}),
              const SizedBox(height: 12),

              SizedBox(
                height: 200,
                child: Obx(() => ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: specialProductController.specialProducts.length,
                  itemBuilder: (ctx, i) {
                    var item = specialProductController.specialProducts;
                    return _specialOfferCard(index: i, productList: item);
                  },
                ),)
              ),
              const SizedBox(height: 32),

              // === Discount strips + ending soon (grouped after load) ===
              Obx(() {
                if (homeDealsController.isLoading.value) {
                  return _dealPicksLoadingCard();
                }
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _expiringSoonStripCard(),
                    const SizedBox(height: 16),
                    _dealPicksCard(
                      mega: homeDealsController.megaOff,
                      hot: homeDealsController.hotDeals,
                      value: homeDealsController.valueDeals,
                      best: homeDealsController.bestSelling,
                    ),
                  ],
                );
              }),
              const SizedBox(height: 8),

              // === Stores near me ===
              _nearMeStoresSection(),
              const SizedBox(height: 32),

              // === Recommended for You ===
              _sectionHeader('Recommended for You', () {}),
              const SizedBox(height: 12),
             Obx(() =>  GridView.builder(
               shrinkWrap: true,
               physics: const NeverScrollableScrollPhysics(),
               gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                 crossAxisCount: 2,
                 childAspectRatio: 0.78,
                 crossAxisSpacing: 16,
                 mainAxisSpacing: 16,
               ),
               itemCount: productController.products.length,
               itemBuilder: (ctx, i) => _productCard(index: i, productList: productController.products),
             ),),
              Obx(() {
                if (!productController.isLoadingMore.value) {
                  return const SizedBox.shrink();
                }
                return const Padding(
                  padding: EdgeInsets.only(top: 16),
                  child: Center(
                    child: SizedBox(
                      width: 24,
                      height: 24,
                      child: CircularProgressIndicator(
                        color: AppColors.mainColor,
                        strokeWidth: 2.5,
                      ),
                    ),
                  ),
                );
              }),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    ),
    );
  }

  Widget _dealPicksLoadingCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 36),
      margin: const EdgeInsets.only(bottom: 4),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: AppColors.grayLight.withValues(alpha: 0.85),
        ),
      ),
      child: Column(
        children: [
          Icon(
            Icons.sell_outlined,
            size: 28,
            color: AppColors.mainColor.withValues(alpha: 0.45),
          ),
          const SizedBox(height: 12),
          Text(
            'Loading deals…',
            style: h5.copyWith(color: AppColors.hintColor),
          ),
          const SizedBox(height: 16),
          const SizedBox(
            width: 26,
            height: 26,
            child: CircularProgressIndicator(
              color: AppColors.mainColor,
              strokeWidth: 2.5,
            ),
          ),
        ],
      ),
    );
  }

  Widget _dealPicksCard({
    required List<allProduct.Products> mega,
    required List<allProduct.Products> hot,
    required List<allProduct.Products> value,
    required List<allProduct.Products> best,
  }) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: 4),
      padding: const EdgeInsets.fromLTRB(14, 14, 14, 10),
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
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: AppColors.mainColor.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Icon(
                  Icons.sell_outlined,
                  size: 20,
                  color: AppColors.mainColor,
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Deal picks',
                      style: GoogleFonts.dmSans(
                        fontSize: 17,
                        fontWeight: FontWeight.w800,
                        letterSpacing: -0.35,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      'Biggest savings first',
                      style: h5.copyWith(
                        color: AppColors.hintColor,
                        fontSize: 12,
                        height: 1.25,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          _dealBandBody(
            shortTitle: '70%+ off',
            products: mega,
            onSeeAll: () => Get.to(
              () => const DealsListView(
                title: 'Mega deals (70%+ off)',
                minDiscount: 70,
                sort: '-discount',
              ),
            ),
          ),
          _dealDivider(),
          _dealBandBody(
            shortTitle: '50–69%',
            products: hot,
            onSeeAll: () => Get.to(
              () => const DealsListView(
                title: '50% – 69% off',
                minDiscount: 50,
                maxDiscount: 69.99,
                sort: '-discount',
              ),
            ),
          ),
          _dealDivider(),
          _dealBandBody(
            shortTitle: '30–49%',
            products: value,
            onSeeAll: () => Get.to(
              () => const DealsListView(
                title: '30% – 49% off',
                minDiscount: 30,
                maxDiscount: 49.99,
                sort: '-discount',
              ),
            ),
          ),
          _dealDivider(),
          _dealBandBody(
            shortTitle: 'Best sellers',
            products: best,
            onSeeAll: () => Get.to(
              () => const DealsListView(
                title: 'Best selling',
                sort: '-totalSell',
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// Home strip: products with `expiredAt` in the next 24h (backend filter).
  Widget _expiringSoonStripCard() {
    final list = homeDealsController.expiringSoon;
    if (list.isEmpty) return const SizedBox.shrink();

    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: 4),
      padding: const EdgeInsets.fromLTRB(14, 14, 14, 10),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: AppColors.mainColor.withValues(alpha: 0.35),
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
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.orange.withValues(alpha: 0.14),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(
                  Icons.timer_outlined,
                  size: 20,
                  color: Colors.orange.shade800,
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Ending soon',
                      style: GoogleFonts.dmSans(
                        fontSize: 17,
                        fontWeight: FontWeight.w800,
                        letterSpacing: -0.35,
                      ),
                    ),
                    Text(
                      'Within 24 hours · live countdown on tiles',
                      style: h5.copyWith(
                        color: AppColors.hintColor,
                        fontSize: 12,
                        height: 1.25,
                      ),
                    ),
                  ],
                ),
              ),
              TextButton(
                onPressed: () => Get.to(
                  () => const DealsListView(
                    title: 'Ending soon',
                    expiringWithinHours: 24,
                    sort: 'expiredAt',
                  ),
                ),
                style: TextButton.styleFrom(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 10),
                  minimumSize: const Size(64, 44),
                  tapTargetSize: MaterialTapTargetSize.padded,
                  foregroundColor: AppColors.mainColor,
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      'See all',
                      style: h4.copyWith(
                        color: AppColors.mainColor,
                        fontWeight: FontWeight.w600,
                        fontSize: 13,
                      ),
                    ),
                    const Icon(Icons.chevron_right_rounded, size: 20),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          SizedBox(
            height: 212,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              physics: const BouncingScrollPhysics(),
              padding: const EdgeInsets.only(right: 6),
              itemCount: list.length,
              separatorBuilder: (_, __) => const SizedBox(width: 12),
              itemBuilder: (context, i) => SizedBox(
                width: 156,
                child: _stripProductCard(
                  list[i],
                  showExpiryCountdown: true,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _dealDivider() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Divider(
        height: 1,
        thickness: 1,
        color: AppColors.grayLight.withValues(alpha: 0.55),
      ),
    );
  }

  Widget _dealSectionHeader({
    required String title,
    required VoidCallback onSeeAll,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Container(
          width: 2,
          height: 16,
          decoration: BoxDecoration(
            color: AppColors.mainColor.withValues(alpha: 0.85),
            borderRadius: BorderRadius.circular(2),
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: Text(
            title,
            style: GoogleFonts.dmSans(
              fontSize: 14.5,
              fontWeight: FontWeight.w700,
              letterSpacing: -0.15,
              height: 1.2,
              color: AppColors.black.withValues(alpha: 0.88),
            ),
          ),
        ),
        TextButton(
          onPressed: onSeeAll,
          style: TextButton.styleFrom(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 10),
            minimumSize: const Size(64, 44),
            tapTargetSize: MaterialTapTargetSize.padded,
            foregroundColor: AppColors.mainColor,
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'See all',
                style: h4.copyWith(
                  color: AppColors.mainColor,
                  fontWeight: FontWeight.w600,
                  fontSize: 13,
                ),
              ),
              const Icon(
                Icons.chevron_right_rounded,
                size: 20,
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _dealEmptyHint() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            Icons.hourglass_empty_rounded,
            size: 17,
            color: AppColors.hintColor.withValues(alpha: 0.9),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              'Nothing here yet',
              style: h5.copyWith(
                color: AppColors.hintColor,
                fontSize: 13,
                height: 1.35,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _dealBandBody({
    required String shortTitle,
    required List<allProduct.Products> products,
    required VoidCallback onSeeAll,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _dealSectionHeader(title: shortTitle, onSeeAll: onSeeAll),
        const SizedBox(height: 10),
        if (products.isEmpty)
          _dealEmptyHint()
        else
          SizedBox(
            height: 212,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              physics: const BouncingScrollPhysics(),
              padding: const EdgeInsets.only(right: 6),
              itemCount: products.length,
              separatorBuilder: (_, __) => const SizedBox(width: 12),
              itemBuilder: (context, i) => SizedBox(
                width: 156,
                child: _stripProductCard(products[i]),
              ),
            ),
          ),
      ],
    );
  }

  DateTime? _parseProductExpiry(dynamic v) {
    if (v == null) return null;
    if (v is DateTime) return v;
    if (v is String && v.isNotEmpty) return DateTime.tryParse(v);
    return null;
  }

  Widget _stripProductCard(
    allProduct.Products p, {
    bool showExpiryCountdown = false,
  }) {
    final img = p.images.isNotEmpty
        ? (p.images.first.url ?? AppImages.noImage)
        : AppImages.noImage;
    final discount = p.discount ?? 0;
    final showDiscountBadge = discount > 0;
    final expiryAt = _parseProductExpiry(p.expiredAt);
    return DecoratedBox(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Material(
        color: AppColors.white,
        clipBehavior: Clip.antiAlias,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(14),
          side: BorderSide(
            color: AppColors.grayLight.withValues(alpha: 0.65),
          ),
        ),
        child: InkWell(
          onTap: () => Get.to(
            () => ProductDetailsView(productId: p.id ?? ''),
          ),
          borderRadius: BorderRadius.circular(14),
          child: Stack(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Stack(
                      fit: StackFit.expand,
                      children: [
                        ClipRRect(
                          borderRadius: const BorderRadius.vertical(
                            top: Radius.circular(13),
                          ),
                          child: Image.network(
                            img,
                            width: double.infinity,
                            fit: BoxFit.cover,
                            errorBuilder: (_, __, ___) => ColoredBox(
                              color: AppColors.grayLight,
                              child: Icon(
                                Icons.image_outlined,
                                color: AppColors.hintColor,
                              ),
                            ),
                          ),
                        ),
                        if (showExpiryCountdown &&
                            expiryAt != null &&
                            expiryAt.isAfter(DateTime.now()))
                          Positioned(
                            left: 0,
                            right: 0,
                            bottom: 0,
                            child: ExpiryCountdownBar(expiresAt: expiryAt),
                          ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(9, 8, 9, 10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          p.name ?? '',
                          style: h4.copyWith(
                            fontWeight: FontWeight.w600,
                            fontSize: 13,
                            height: 1.25,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 5),
                        Row(
                          children: [
                            Text(
                              '\$${((p.price ?? 0) * (1 - discount / 100)).toStringAsFixed(2)}',
                              style: h3.copyWith(
                                color: AppColors.mainColor,
                                fontWeight: FontWeight.w800,
                                fontSize: 14,
                              ),
                            ),
                            sw5,
                            if (showDiscountBadge)
                              Text(
                                '\$${p.price}',
                                style: h4.copyWith(
                                  color: AppColors.gray,
                                  decoration: TextDecoration.lineThrough,
                                  fontSize: 11,
                                ),
                              ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              if (showDiscountBadge)
                Positioned(
                  top: 8,
                  left: 8,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 3,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.red,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      '-${discount.round()}% OFF',
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
        ),
      ),
    );
  }

  Widget _categoryChip(String id,String title, String image, {bool isSelected = false}) {
    return GestureDetector(
      onTap: () {
        Get.to(() =>  CategoryProductView(categoryId: id,), arguments: title);
      },
      child: Container(
        width: 80,
        margin: const EdgeInsets.only(right: 12),
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.mainColor : AppColors.white,
          borderRadius: BorderRadius.circular(30),
          border: Border.all(color: isSelected ? AppColors.mainColor : AppColors.grayLight),
        ),
        child: Column(
          children: [
            Image.network(image,width: 30,height: 30,),
            sh5,
            Text(
              title,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: h4,
            ),
          ],
        ),
      ),
    );
  }

  Widget _sectionHeader(String title, VoidCallback onTap) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(title, style: h2.copyWith(fontSize: 18)),
       // TextButton(onPressed: onTap, child: Text('See all', style: h4.copyWith(color: AppColors.mainColor))),
      ],
    );
  }

  Widget _nearMeStoresSection() {
    return Obx(() {
      final c = nearMeStoresController;

      if (c.isHomeNearMeLoading.value) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Expanded(
                  child: Text(
                    'Stores near me',
                    style: h2.copyWith(fontSize: 18),
                  ),
                ),
                SearchRadiusMileButton(controller: c),
              ],
            ),
            const SizedBox(height: 16),
            const NearMeShimmerPlaceholder(),
          ],
        );
      }

      Widget headerActions() {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Expanded(
                  child: Text(
                    'Stores near me',
                    style: h2.copyWith(fontSize: 18),
                  ),
                ),
                SearchRadiusMileButton(controller: c),
              ],
            ),
            const SizedBox(height: 4),
            Align(
              alignment: Alignment.centerRight,
              child: Wrap(
                alignment: WrapAlignment.end,
                children: [
                  TextButton(
                    onPressed: () => Get.toNamed(
                      Routes.NEAR_ME_MAP,
                      arguments: const {'browseAll': false},
                    ),
                    child: Text(
                      'View on map',
                      style: h4.copyWith(color: AppColors.mainColor),
                    ),
                  ),
                  TextButton(
                    onPressed: () => Get.toNamed(
                      Routes.NEAR_ME_MAP,
                      arguments: const {'browseAll': true},
                    ),
                    child: Text(
                      'View all',
                      style: h4.copyWith(color: AppColors.mainColor),
                    ),
                  ),
                ],
              ),
            ),
          ],
        );
      }

      switch (c.homeNearMeStatus.value) {
        case NearMeDisplayStatus.needsAuth:
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              headerActions(),
              const SizedBox(height: 12),
              Text(
                'Sign in to see stores near you.',
                style: h4.copyWith(color: AppColors.hintColor),
              ),
              const SizedBox(height: 12),
              TextButton(
                onPressed: () => Get.to(() => LoginView()),
                child: Text('Sign in', style: h4.copyWith(color: AppColors.mainColor)),
              ),
            ],
          );
        case NearMeDisplayStatus.locationDenied:
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              headerActions(),
              const SizedBox(height: 12),
              Text(
                'Turn on location to see stores near you.',
                style: h4.copyWith(color: AppColors.hintColor),
              ),
              const SizedBox(height: 12),
              OutlinedButton.icon(
                onPressed: () => c.fetchNearMeStores(),
                icon: const Icon(Icons.refresh_rounded, size: 20),
                label: const Text('Retry'),
              ),
            ],
          );
        case NearMeDisplayStatus.loadFailed:
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              headerActions(),
              const SizedBox(height: 12),
              Text(
                c.lastErrorMessage.value.isNotEmpty
                    ? c.lastErrorMessage.value
                    : 'Could not load nearby stores.',
                style: h4.copyWith(color: AppColors.hintColor),
              ),
              const SizedBox(height: 12),
              OutlinedButton.icon(
                onPressed: () => c.fetchNearMeStores(),
                icon: const Icon(Icons.refresh_rounded, size: 20),
                label: const Text('Retry'),
              ),
            ],
          );
        case NearMeDisplayStatus.noShopsNearby:
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              headerActions(),
              const SizedBox(height: 12),
              Text(
                'No shops in your area yet.',
                style: h4.copyWith(color: AppColors.hintColor),
              ),
              const SizedBox(height: 8),
              TextButton(
                onPressed: () => Get.toNamed(
                  Routes.NEAR_ME_MAP,
                  arguments: const {'browseAll': true},
                ),
                child: Text(
                  'Browse all stores',
                  style: h4.copyWith(
                    color: AppColors.mainColor,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          );
        case NearMeDisplayStatus.ready:
          final stores = c.nearMeStores;
          if (stores.isEmpty) {
            return const SizedBox.shrink();
          }
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              headerActions(),
              const SizedBox(height: 12),
              NearMeMapPreview(controller: c, stores: stores.toList()),
              const SizedBox(height: 16),
              SizedBox(
                height: 100,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: stores.length,
                  itemBuilder: (context, index) => _nearMeStoreCard(
                    nearStores: stores,
                    index: index,
                    ctrl: c,
                  ),
                ),
              ),
            ],
          );
        case NearMeDisplayStatus.loading:
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Expanded(
                    child: Text(
                      'Stores near me',
                      style: h2.copyWith(fontSize: 18),
                    ),
                  ),
                  SearchRadiusMileButton(controller: c),
                ],
              ),
              const SizedBox(height: 16),
              const NearMeShimmerPlaceholder(),
            ],
          );
      }
    });
  }

   Widget _nearMeStoreCard({
    required List<NearMeStores> nearStores,
    required int index,
    required NearMeStoresController ctrl,
  }) {
     return GestureDetector(
       onTap: (){
         Get.to(() => StoreView(shopId: nearStores[index].id ?? "", authorId: nearStores[index].author?.id ?? "",));
       },
       child: Container(
         width: 300,
         margin: const EdgeInsets.only(right: 16),
         padding: const EdgeInsets.all(16),
         decoration: BoxDecoration(
           color: AppColors.white,
           borderRadius: BorderRadius.circular(20),
           border: Border.all(color: AppColors.grayLight),
           boxShadow: [
             BoxShadow(
               color: Colors.black.withValues(alpha: 0.06),
               blurRadius: 12,
               offset: const Offset(0, 6),
             ),
           ],
         ),
         child: Row(
           children: [
             // Store Logo
             Container(
               width: 80,
               height: 80,
               decoration: BoxDecoration(
                 borderRadius: BorderRadius.circular(16),
                 image:  DecorationImage(
                   image: NetworkImage(nearStores[index].logo ?? AppImages.noImage),
                   fit: BoxFit.cover,
                 ),
               ),
             ),
             const SizedBox(width: 16),

             // Store Details
             Expanded(
               child: Column(
                 crossAxisAlignment: CrossAxisAlignment.start,
                 mainAxisAlignment: MainAxisAlignment.center,
                 children: [
                   Text(
               nearStores[index].name ?? "",
                     style: h3.copyWith(fontWeight: FontWeight.w600),
                     maxLines: 1,
                     overflow: TextOverflow.ellipsis,
                   ),
                   const SizedBox(height: 6),
                   if (ctrl.distanceLabel(nearStores[index]).isNotEmpty)
                     Text(
                       ctrl.distanceLabel(nearStores[index]),
                       style: h5.copyWith(color: AppColors.hintColor),
                     ),
                   const SizedBox(height: 8),

                 ],
               ),
             ),

             // Visit Button
             Container(
               padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
               decoration: BoxDecoration(
                 color: AppColors.mainColor,
                 borderRadius: BorderRadius.circular(30),
               ),
               child: Text(
                 'Visit',
                 style: GoogleFonts.dmSans(
                   color: Colors.white,
                   fontWeight: FontWeight.w600,
                   fontSize: 14,
                 ),
               ),
             ),
           ],
         ),
       ),
     );
   }

  Widget _specialOfferCard({required List<sProduct.SpecialProducts> productList, required index}) {
    return GestureDetector(
      onTap: (){
        Get.to(() => ProductDetailsView(productId: productList[index].id ?? "",));
      },
      child: Container(
        width: 280,
        margin: const EdgeInsets.only(right: 16),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Colors.black.withValues(alpha: 0.05),
                Colors.black.withValues(alpha: 0.8),  // dark black
              ],
            ),
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
            ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: Image.network(productList[index].images[0].url ?? "", height: 200, width: double.infinity, fit: BoxFit.cover),
            ),
            Positioned(
              top: 16, left: 16,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(color: AppColors.red, borderRadius: BorderRadius.circular(20)),
                child: Text('-${productList[index].discount}% OFF', style: GoogleFonts.dmSans(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 12)),
              ),
            ),
          
            Positioned(
              bottom: 0, left: 0, right: 0,
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  borderRadius: const BorderRadius.vertical(bottom: Radius.circular(20)),
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.black.withValues(alpha: 0.0), // lighter black at the top
                      Colors.black.withValues(alpha: 0.9), // darker black at the bottom
                    ],
                  ),
                ),

                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(productList[index].name ?? "", style: GoogleFonts.dmSans(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w600),maxLines: 1,overflow: TextOverflow.ellipsis,),
                    Text(productList[index].author?.shop?.name ?? "", style: h5.copyWith(color: Colors.white70)),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Text(
                                '\$${((productList[index].price ?? 0) * (1 - (productList[index].discount ?? 0) / 100)).toStringAsFixed(2)}',
                                style: GoogleFonts.dmSans(color: AppColors.orange, fontWeight: FontWeight.bold, fontSize: 18)),
                           sw5,
                            Text(
                              '\$${productList[index].price}',
                              style: GoogleFonts.dmSans(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 12,
                                decoration: TextDecoration.lineThrough,
                              ),
                            ),

                          ],
                        ),
                        const Icon(Icons.shopping_bag, color: Colors.amber, size: 16),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _productCard({required index, required List<allProduct.Products> productList}) {
    return GestureDetector(
      onTap: (){
        Get.to(() => ProductDetailsView(productId: productList[index].id ?? "",));
      },
      child: Container(
        decoration: BoxDecoration(color: AppColors.white, borderRadius: BorderRadius.circular(20), boxShadow: [
          BoxShadow(color: Colors.black.withValues(alpha: 0.05), blurRadius: 10, offset: const Offset(0, 4)),
        ]),
        child: Stack(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: ClipRRect(
                    borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
                    child: Image.network(
                      productList[index].images[0].url ?? AppImages.noImage,
                      width: double.infinity,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),

                Padding(
                  padding: const EdgeInsets.all(12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                      productList[index].name ?? "",
                        style: h3,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      Text(  productList[index].author?.shop?.name ?? "", style: h5.copyWith(color: AppColors.hintColor)),
                      const SizedBox(height: 8),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              Text(
                                  '\$${((productList[index].price ?? 0) * (1 - (productList[index].discount ?? 0) / 100)).toStringAsFixed(2)}',
                                  style: h3.copyWith(color: AppColors.mainColor, fontWeight: FontWeight.bold)),
                             sw5,
                              Text('\$${ productList[index].price}', style: h3.copyWith(color: AppColors.gray, fontWeight: FontWeight.bold)),
                            ],
                          ),
                          Icon(Icons.shopping_bag, color: Colors.amber, size: 16),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
            Positioned(
              top: 16, left: 16,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(color: AppColors.red, borderRadius: BorderRadius.circular(20)),
                child: Text('-${productList[index].discount}% OFF', style: GoogleFonts.dmSans(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 12)),
              ),
            ),

            Positioned(
              top: 10,
              right: 10,
              child: Obx(() {
                final fav = Get.find<FavoritesController>();
                final id = productList[index].id ?? '';
                final saved = fav.ids.contains(id);
                return Material(
                  color: Colors.white.withValues(alpha: 0.94),
                  shape: const CircleBorder(),
                  elevation: 1,
                  shadowColor: Colors.black26,
                  clipBehavior: Clip.antiAlias,
                  child: InkWell(
                    onTap: () => fav.toggle(id),
                    customBorder: const CircleBorder(),
                    child: Padding(
                      padding: const EdgeInsets.all(8),
                      child: Icon(
                        saved
                            ? Icons.favorite_rounded
                            : Icons.favorite_border_rounded,
                        size: 18,
                        color: saved
                            ? const Color(0xFFFF6B6B)
                            : AppColors.black.withValues(alpha: 0.65),
                      ),
                    ),
                  ),
                );
              }),
            ),
          ],
        ),
      ),
    );
  }
}