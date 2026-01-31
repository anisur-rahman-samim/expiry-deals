import 'package:expiry_deals/app/modules/category/views/category_product_view.dart';
import 'package:expiry_deals/app/modules/category/views/category_view.dart';
import 'package:expiry_deals/app/modules/home/controllers/near_me_stores_controller.dart';
import 'package:expiry_deals/app/modules/home/controllers/product_controller.dart';
import 'package:expiry_deals/app/modules/home/controllers/special_product_controller.dart';
import 'package:expiry_deals/app/modules/home/model/near_me_stores_model.dart';
import 'package:expiry_deals/app/modules/home/model/product_model.dart' as allProduct;
import 'package:expiry_deals/app/modules/home/model/special_product_model.dart' as sProduct;
import 'package:expiry_deals/app/modules/product_details/views/product_details_view.dart';
import 'package:expiry_deals/app/modules/profile/controllers/profile_controller.dart';
import 'package:expiry_deals/app/modules/search_page/views/search_page_view.dart';
import 'package:expiry_deals/app/modules/store/views/store_view.dart';
import 'package:expiry_deals/app/modules/vendor_dashboard/vendor_product/controllers/category_controller.dart';
import 'package:expiry_deals/common/app_color/app_colors.dart';
import 'package:expiry_deals/common/app_images/app_images.dart';
import 'package:expiry_deals/common/app_text_style/styles.dart';
import 'package:expiry_deals/common/size_box/custom_sizebox.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import '../controllers/home_controller.dart';


class HomeView extends GetView<HomeController> {
   HomeView({super.key});
   
   final ProfileController profileController = Get.put(ProfileController());
   final CategoryDataController categoryDataController = Get.put(CategoryDataController());

   final ProductController productController = Get.put(ProductController());
   final SpecialProductController specialProductController = Get.put(SpecialProductController());

   final NearMeStoresController nearMeStoresController = Get.put(NearMeStoresController());


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bgColor,
      body: SafeArea(
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
                 Obx(() =>  CircleAvatar(
                   radius: 24,
                   backgroundColor: AppColors.grayLight,
                   backgroundImage: NetworkImage(profileController.profileData.value.data?.profile ?? AppImages.noImage),
                 //  child: ClipOval(child: Image.network( , fit: BoxFit.contain)),
                 ),)
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

              // === Near Me Stores Section ===
              _sectionHeader('Near Me Stores', () {
                // Navigate to all stores near me
              }),
              const SizedBox(height: 16),

              SizedBox(
                height: 100,
                child: Obx(() => nearMeStoresController.nearMeStores.isEmpty ? Center(child: Text("No Store Available"),) : ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: nearMeStoresController.nearMeStores.length,
                  itemBuilder: (context, index) => _nearMeStoreCard(nearStores: nearMeStoresController.nearMeStores, index: index),
                ),)
              ),
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
              const SizedBox(height: 24),
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

   Widget _nearMeStoreCard({required List<NearMeStores> nearStores, required int index}) {
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
                   Row(
                     children: [
                       Icon(Icons.location_on, size: 16, color: AppColors.hintColor),
                       const SizedBox(width: 4),
                       Text('${nearStores[index].distanceKm?.toStringAsFixed(2)} km away', style: h5.copyWith(color: AppColors.hintColor)),
                     ],
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
            // Positioned(
            //   top: 16, left: 16,
            //   child: Container(
            //     padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            //     decoration: BoxDecoration(color: AppColors.red, borderRadius: BorderRadius.circular(20)),
            //     child: Text('-60% OFF', style: GoogleFonts.dmSans(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 12)),
            //   ),
            // ),
          
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
                    Text(productList[index].name ?? "", style: GoogleFonts.dmSans(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w600)),
                    Text(productList[index].author?.shop?.name ?? "", style: h5.copyWith(color: Colors.white70)),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Text('\$${productList[index].discount}', style: GoogleFonts.dmSans(color: AppColors.orange, fontWeight: FontWeight.bold, fontSize: 18)),
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
   // final discounts = ['-30%', '-20%', '-50%'];
   // final discount = index < 3 ? discounts[index] : null;
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
                              Text('\$${ productList[index].discount}', style: h3.copyWith(color: AppColors.mainColor, fontWeight: FontWeight.bold)),
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

            // Positioned(
            //   top: 12, right: 12,
            //   child: CircleAvatar(
            //     radius: 16,
            //     backgroundColor: Colors.white.withOpacity(0.9),
            //     child: const Icon(Icons.favorite_border, size: 18, color: AppColors.black),
            //   ),
            // ),
          ],
        ),
      ),
    );
  }
}