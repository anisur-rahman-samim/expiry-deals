// store_view.dart
import 'package:expiry_deals/app/modules/home/model/near_me_stores_model.dart';
import 'package:expiry_deals/app/modules/product_details/views/product_details_view.dart';
import 'package:expiry_deals/app/modules/store/controllers/single_store_controller.dart';
import 'package:expiry_deals/app/modules/store/controllers/store_wise_product_controller.dart';
import 'package:expiry_deals/app/modules/store/model/single_store_model.dart';
import 'package:expiry_deals/app/modules/store/model/store_wise_product_model.dart' as SWProduct;
import 'package:expiry_deals/common/app_color/app_colors.dart';
import 'package:expiry_deals/common/app_images/app_images.dart';
import 'package:expiry_deals/common/app_text_style/styles.dart';
import 'package:expiry_deals/common/size_box/custom_sizebox.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';


class StoreView extends StatefulWidget {
  final String shopId;
  final String authorId;
  const StoreView({super.key, required this.shopId, required this.authorId});

  @override
  State<StoreView> createState() => _StoreViewState();
}

class _StoreViewState extends State<StoreView> {
  final SingleStoreController singleStoreController = Get.put(SingleStoreController());
  final StoreWiseProductController storeWiseProductController = Get.put(StoreWiseProductController());

  @override
  void initState() {
    singleStoreController.fetchSingleStoreProduct(shopId: widget.shopId);
    storeWiseProductController.fetchStoreWiseProduct(shopId: widget.authorId);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bgColor,
      body: DefaultTabController(
        length: 2,
        child: NestedScrollView(
          headerSliverBuilder: (context, innerBoxIsScrolled) => [
           Obx(() =>  SliverAppBar(
             expandedHeight: 250,
             floating: false,
             pinned: true,
             backgroundColor: AppColors.bgColor,
             elevation: 0,
             iconTheme: const IconThemeData(
               color: Colors.white, // Back arrow color
             ),
             flexibleSpace: FlexibleSpaceBar(
               collapseMode: CollapseMode.parallax,
               background: _buildStoreHeader(shop: singleStoreController.singleStore.value),
             ),
             bottom: _buildTabBar(innerBoxIsScrolled),
           ),)
          ],
          body: Obx(() => TabBarView(
            children: [
              _buildProductsTab(productList: storeWiseProductController.storeWiseProduct),
              _buildAboutTab(shop: singleStoreController.singleStore.value),
            ],
          ),)
        ),
      ),
    );
  }

  Widget _buildStoreHeader({required SingleShopModel shop}) {
    return Stack(
      children: [
        // Store Banner
        Container(
          height: 320,
          width: double.infinity,
          decoration:  BoxDecoration(
            image: DecorationImage(
              image: NetworkImage(
                  shop.data?.banner ?? AppImages.noImage
               // 'https://img.freepik.com/free-photo/fashion-store-interior-with-clothes-hangers_23-2151050859.jpg?w=1800',
              ),
              fit: BoxFit.cover,
            ),
          ),
        ),
        // Gradient Overlay
        Container(
          height: 320,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [Colors.black.withValues(alpha: 0.6), Colors.transparent, Colors.black.withValues(alpha: 0.8),],
            ),
          ),
        ),
        // Store Info
        Positioned(
          bottom: 20,
          left: 20,
          right: 20,
          child: Row(
            children: [
              // Store Logo
              Container(
                width: 90,
                height: 90,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: Colors.white, width: 4),
                  image:  DecorationImage(
                    image: NetworkImage(shop.data?.logo ?? AppImages.noImage),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      shop.data?.name ?? "",
                      style: GoogleFonts.dmSans(
                        fontSize: 26,
                        fontWeight: FontWeight.w800,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 6),

                  ],
                ),
              ),

            ],
          ),
        ),
      ],
    );
  }

  PreferredSizeWidget _buildTabBar(bool innerBoxIsScrolled) {
    return PreferredSize(
      preferredSize: const Size.fromHeight(60),
      child: Container(
        color: AppColors.bgColor,
        child: TabBar(
          labelColor: AppColors.mainColor,
          unselectedLabelColor: AppColors.hintColor,
          labelStyle: GoogleFonts.dmSans(fontSize: 16, fontWeight: FontWeight.w600),
          indicatorColor: AppColors.mainColor,
          indicatorWeight: 2,
          tabs:  [
            Tab(text: 'All Products'),
            Tab(text: 'About'),

          ],
        ),
      ),
    );
  }

  Widget _buildProductsTab({required List<SWProduct.StoreWiseProduct> productList}) {
    return RefreshIndicator(
      onRefresh: () async => await Future.delayed(const Duration(seconds: 1)),
      color: AppColors.mainColor,
      child: Obx(() => productList.isEmpty? Center(child: Text("No product available"),) : GridView.builder(
        padding: const EdgeInsets.all(16),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            childAspectRatio: 0.78,
            crossAxisSpacing: 16,
            mainAxisSpacing: 16,
            mainAxisExtent: 250
        ),
        itemCount: productList.length,
        itemBuilder: (context, index) => _productCard(productList: productList, index: index),
      ),)
    );
  }

  Widget _productCard({required List<SWProduct.StoreWiseProduct> productList, required int index}) {
    return GestureDetector(
      onTap: (){
        Get.to(() => ProductDetailsView(productId: productList[index].id ?? "",));
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
            Stack(
              children: [
                ClipRRect(
                  borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
                  child: Image.network(
                    productList[index].images[0].url ?? AppImages.noImage,
                    height: 160,
                    width: double.infinity,
                    fit: BoxFit.cover,
                  ),
                ),

              ],
            ),
            Padding(
              padding: const EdgeInsets.all(14),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(productList[index].name ?? "", style: h4, maxLines: 1, overflow: TextOverflow.ellipsis),
                  const SizedBox(height: 6),
                  Row(
                    children: [
                      Text('\$${productList[index].discount ?? ""}', style: h3.copyWith(color: AppColors.mainColor, fontWeight: FontWeight.bold)),
                   sw5,
                      Text('\$${productList[index].price ?? ""}' ,style: h3.copyWith(color: AppColors.gray, fontWeight: FontWeight.bold)),
                    ],
                  ),
                  const SizedBox(height: 6),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAboutTab({required SingleShopModel shop}) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('About Store', style: h2.copyWith(fontSize: 20)),
          const SizedBox(height: 16),
          Text(
            shop.data?.description ?? "No description available",
            style: h4.copyWith(height: 1.7, color: AppColors.textColor.withValues(alpha: 0.9),),
          ),
          const SizedBox(height: 24),
          _infoRow(Icons.location_on, '${shop.data?.address ?? "No location"}'),
          // _infoRow(Icons.phone, '${shop.data?.author}'),
          // _infoRow(Icons.email, 'support@fashionelite.com'),
          _infoRow(Icons.access_time, 'Open • ${shop.data?.openingHours ?? "N/A"}'),
        ],
      ),
    );
  }

  Widget _infoRow(IconData icon, String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Row(
        children: [
          Icon(icon, color: AppColors.mainColor, size: 22),
          const SizedBox(width: 16),
          Text(text, style: h4),
        ],
      ),
    );
  }
}