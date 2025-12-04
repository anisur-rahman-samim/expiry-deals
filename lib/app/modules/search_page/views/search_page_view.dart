// search_page_view.dart
import 'package:expiry_deals/app/modules/search_page/controllers/search_page_controller.dart';
import 'package:expiry_deals/common/app_color/app_colors.dart';
import 'package:expiry_deals/common/app_text_style/styles.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';


class SearchPageView extends StatelessWidget {
   SearchPageView({super.key});

   final SearchPageController controller = Get.put(SearchPageController());

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
        if (controller.searchQuery.value.isEmpty) {
          return _buildSearchHome();
        }

        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator(color: AppColors.mainColor));
        }

        if (controller.searchResults.isEmpty) {
          return _buildEmptyResults();
        }

        return _buildSearchResults();
      }),
    );
  }

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

  Widget _buildSearchHome() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [


          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Trending Now', style: h2.copyWith(fontSize: 18)),
            //  TextButton(onPressed: () {}, child: Text('See all', style: h4.copyWith(color: AppColors.mainColor))),
            ],
          ),
          const SizedBox(height: 16),

          GridView.count(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            crossAxisCount: 2,
            childAspectRatio: 0.78,
            crossAxisSpacing: 16,
            mainAxisSpacing: 16,
            children: List.generate(6, (i) => _trendingProductCard(index: i)),
          ),
        ],
      ),
    );
  }


  Widget _trendingProductCard({required int index}) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.06), blurRadius: 12, offset: const Offset(0, 6))],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
            child: Image.network(
              recommendedProductImageList[index],
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
                Text('Leather Jacket', style: h4, maxLines: 1, overflow: TextOverflow.ellipsis),
                const SizedBox(height: 6),
                Text('\$89.99', style: h3.copyWith(color: AppColors.mainColor, fontWeight: FontWeight.bold)),
              ],
            ),
          ),
        ],
      ),
    );
  }

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
        itemCount: controller.searchResults.length,
        itemBuilder: (context, index) {
          final product = controller.searchResults[index];
          return _productCard(product);
        },
      ),
    );
  }

  Widget _productCard(dynamic product) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.06), blurRadius: 12, offset: const Offset(0, 6))],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Stack(
            children: [
              ClipRRect(
                borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
                child: Image.network(
                  product['image'] ?? 'https://via.placeholder.com/300',
                  height: 140,
                  width: double.infinity,
                  fit: BoxFit.cover,
                ),
              ),
              Positioned(
                top: 10,
                right: 10,
                child: CircleAvatar(
                  radius: 18,
                  backgroundColor: Colors.white.withOpacity(0.9),
                  child: const Icon(Icons.favorite_border, size: 20),
                ),
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.all(14),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  product['title'] ?? 'Product Name',
                  style: h4,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 8),
                Text(
                  '\$${product['price']?.toStringAsFixed(2) ?? '0.00'}',
                  style: h3.copyWith(color: AppColors.mainColor, fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

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