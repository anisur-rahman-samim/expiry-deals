import 'package:expiry_deals/app/modules/category/views/category_product_view.dart';
import 'package:expiry_deals/app/modules/category/views/category_view.dart';
import 'package:expiry_deals/app/modules/product_details/views/product_details_view.dart';
import 'package:expiry_deals/app/modules/profile/controllers/profile_controller.dart';
import 'package:expiry_deals/app/modules/search_page/views/search_page_view.dart';
import 'package:expiry_deals/app/modules/store/views/store_view.dart';
import 'package:expiry_deals/app/modules/vendor_dashboard/vendor_product/controllers/category_controller.dart';
import 'package:expiry_deals/common/app_color/app_colors.dart';
import 'package:expiry_deals/common/app_text_style/styles.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import '../controllers/home_controller.dart';


class HomeView extends GetView<HomeController> {
   HomeView({super.key});

  final productImageList =[
    "https://www.dhresource.com/webp/m/0x0/f2/albu/g21/M00/1F/F5/rBVaq2DCDRGABLbyAADQ8DkUmO8389.jpg",
    "https://i.pinimg.com/736x/af/38/16/af3816f775f479ab6fb7dfaf30d3e553.jpg",
    "https://img.freepik.com/free-photo/woman-leaning-white-wooden-board-talking-phone-while-smiling_1157-2023.jpg?semt=ais_hybrid&w=740&q=80",
    "https://img.freepik.com/free-photo/young-attractive-woman-blue-winter-jacket_1303-20115.jpg?semt=ais_hybrid&w=740&q=80",
    "https://media.istockphoto.com/id/641684768/photo/pretty-girl-in-a-leather-jacket-on-white-background.jpg?s=612x612&w=is&k=20&c=p1Cbfw4L-mKS3eRGpk4DD3QQi3XvdqH2Ot28aOBR2xQ=",
    "https://www.dhresource.com/webp/m/0x0/f2/albu/g21/M00/1F/F5/rBVaq2DCDRGABLbyAADQ8DkUmO8389.jpg"
  ];


   final recommendedProductImageList =[
      "https://img.freepik.com/free-photo/young-attractive-woman-blue-winter-jacket_1303-20115.jpg?semt=ais_hybrid&w=740&q=80",
     "https://media.istockphoto.com/id/641684768/photo/pretty-girl-in-a-leather-jacket-on-white-background.jpg?s=612x612&w=is&k=20&c=p1Cbfw4L-mKS3eRGpk4DD3QQi3XvdqH2Ot28aOBR2xQ=",
     "https://www.dhresource.com/webp/m/0x0/f2/albu/g21/M00/1F/F5/rBVaq2DCDRGABLbyAADQ8DkUmO8389.jpg"
         "https://www.dhresource.com/webp/m/0x0/f2/albu/g21/M00/1F/F5/rBVaq2DCDRGABLbyAADQ8DkUmO8389.jpg",
     "https://i.pinimg.com/736x/af/38/16/af3816f775f479ab6fb7dfaf30d3e553.jpg",
     "https://img.freepik.com/free-photo/woman-leaning-white-wooden-board-talking-phone-while-smiling_1157-2023.jpg?semt=ais_hybrid&w=740&q=80",
     "https://img.freepik.com/free-photo/young-attractive-woman-blue-winter-jacket_1303-20115.jpg?semt=ais_hybrid&w=740&q=80",
     "https://media.istockphoto.com/id/641684768/photo/pretty-girl-in-a-leather-jacket-on-white-background.jpg?s=612x612&w=is&k=20&c=p1Cbfw4L-mKS3eRGpk4DD3QQi3XvdqH2Ot28aOBR2xQ=",
     "https://www.dhresource.com/webp/m/0x0/f2/albu/g21/M00/1F/F5/rBVaq2DCDRGABLbyAADQ8DkUmO8389.jpg",
     "https://i.pinimg.com/736x/af/38/16/af3816f775f479ab6fb7dfaf30d3e553.jpg",
     "https://img.freepik.com/free-photo/woman-leaning-white-wooden-board-talking-phone-while-smiling_1157-2023.jpg?semt=ais_hybrid&w=740&q=80",

   ];
   
   final ProfileController profileController = Get.put(ProfileController());
   final CategoryDataController categoryDataController = Get.put(CategoryDataController());


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
                   child: ClipOval(child: Image.network( profileController.profileData.value.data?.profile ?? 'https://upload.wikimedia.org/wikipedia/commons/thumb/a/ac/No_image_available.svg/2048px-No_image_available.svg.png', fit: BoxFit.cover)),
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
              // === Category Chips ===
             SizedBox(
               height: 40,
               child: Obx(() => ListView.builder(
                   shrinkWrap: true,
                   scrollDirection: Axis.horizontal,
                   itemCount: categoryDataController.categories.length,
                   itemBuilder: (context,index){
                     var item = categoryDataController.categories[index];
                     return       _categoryChip(item.name??"");
                   }),)
             ),
              const SizedBox(height: 24),

              // === Special Offer Section ===
              _sectionHeader('Special Offer', () {}),
              const SizedBox(height: 12),

              SizedBox(
                height: 200,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: 4,
                  itemBuilder: (ctx, i) => _specialOfferCard(index: i),
                ),
              ),
              const SizedBox(height: 32),

              // === Near Me Stores Section ===
              _sectionHeader('Near Me Stores', () {
                // Navigate to all stores near me
              }),
              const SizedBox(height: 16),

              SizedBox(
                height: 100,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: 6,
                  itemBuilder: (context, index) => _nearMeStoreCard(),
                ),
              ),
              const SizedBox(height: 32),

              // === Recommended for You ===
              _sectionHeader('Recommended for You', () {}),
              const SizedBox(height: 12),
              GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  childAspectRatio: 0.78,
                  crossAxisSpacing: 16,
                  mainAxisSpacing: 16,
                ),
                itemCount: 6,
                itemBuilder: (ctx, i) => _productCard(i),
              ),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }

  Widget _categoryChip(String title, {bool isSelected = false}) {
    return GestureDetector(
      onTap: () {
        Get.to(() =>  CategoryProductView(), arguments: title);
      },
      child: Container(
        margin: const EdgeInsets.only(right: 12),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.mainColor : AppColors.white,
          borderRadius: BorderRadius.circular(30),
          border: Border.all(color: isSelected ? AppColors.mainColor : AppColors.grayLight),
        ),
        child: Text(
          title,
          style: GoogleFonts.dmSans(
            color: isSelected ? Colors.white : AppColors.textColor,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }

  Widget _sectionHeader(String title, VoidCallback onTap) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(title, style: h2.copyWith(fontSize: 18)),
        TextButton(onPressed: onTap, child: Text('See all', style: h4.copyWith(color: AppColors.mainColor))),
      ],
    );
  }

   Widget _nearMeStoreCard() {
     return GestureDetector(
       onTap: (){
         Get.to(() => StoreView());
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
                 image: const DecorationImage(
                   image: NetworkImage('https://i.pravatar.cc/300?img=12'),
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
                     'Fashion Hub Outlet',
                     style: h3.copyWith(fontWeight: FontWeight.w600),
                     maxLines: 1,
                     overflow: TextOverflow.ellipsis,
                   ),
                   const SizedBox(height: 6),
                   Row(
                     children: [
                       Icon(Icons.location_on, size: 16, color: AppColors.hintColor),
                       const SizedBox(width: 4),
                       Text('2.4 km away', style: h5.copyWith(color: AppColors.hintColor)),
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

  Widget _specialOfferCard({required index}) {
    return GestureDetector(
      onTap: (){
        Get.to(() => ProductDetailsView());
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
              child: Image.network(productImageList[index], height: 200, width: double.infinity, fit: BoxFit.cover),
            ),
            Positioned(
              top: 16, left: 16,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(color: AppColors.red, borderRadius: BorderRadius.circular(20)),
                child: Text('-60% OFF', style: GoogleFonts.dmSans(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 12)),
              ),
            ),
            // Positioned(
            //   top: 16, right: 16,
            //   child: CircleAvatar(backgroundColor: Colors.white.withOpacity(0.8), child: const Icon(Icons.favorite_border, color: AppColors.black)),
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
                    Text('Modern Light Clothes', style: GoogleFonts.dmSans(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w600)),
                    Text('T-Shirt', style: h5.copyWith(color: Colors.white70)),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('\$12.99', style: GoogleFonts.dmSans(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 18)),
                        Row(children: [
                          const Icon(Icons.star, color: Colors.amber, size: 16),
                          Text('5.0', style: GoogleFonts.dmSans(color: Colors.white)),
                        ]),
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

  Widget _productCard(int index) {
    final discounts = ['-30%', '-20%', '-50%'];
    final discount = index < 3 ? discounts[index] : null;
    return GestureDetector(
      onTap: (){
        Get.to(() => ProductDetailsView());
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
                      recommendedProductImageList[index],
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
                        index == 0 ? 'Wireless Bluetooth Earbuds' : 'Modern Light Clothes',
                        style: h3,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      Text('T-shirt', style: h5.copyWith(color: AppColors.hintColor)),
                      const SizedBox(height: 8),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('\$${index == 0 ? '49.99' : '12.99'}', style: h3.copyWith(color: AppColors.mainColor, fontWeight: FontWeight.bold)),
                          Row(children: const [
                            Icon(Icons.star, color: Colors.amber, size: 16),
                            SizedBox(width: 4),
                            Text('5.0', style: TextStyle(fontSize: 12)),
                          ]),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
            if (discount != null)
              Positioned(
                top: 12, left: 12,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(color: AppColors.red, borderRadius: BorderRadius.circular(20)),
                  child: Text(discount, style: GoogleFonts.dmSans(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 11)),
                ),
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