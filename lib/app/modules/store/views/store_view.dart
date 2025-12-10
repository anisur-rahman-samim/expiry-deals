// store_view.dart
import 'package:expiry_deals/app/modules/product_details/views/product_details_view.dart';
import 'package:expiry_deals/common/app_color/app_colors.dart';
import 'package:expiry_deals/common/app_text_style/styles.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';


class StoreView extends StatelessWidget {
  const StoreView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bgColor,
      body: DefaultTabController(
        length: 2,
        child: NestedScrollView(
          headerSliverBuilder: (context, innerBoxIsScrolled) => [
            SliverAppBar(
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
                background: _buildStoreHeader(),
              ),
              bottom: _buildTabBar(innerBoxIsScrolled),
            ),
          ],
          body: TabBarView(
            children: [
              _buildProductsTab(),
              _buildAboutTab(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStoreHeader() {
    return Stack(
      children: [
        // Store Banner
        Container(
          height: 320,
          width: double.infinity,
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: NetworkImage(
                'https://img.freepik.com/free-photo/fashion-store-interior-with-clothes-hangers_23-2151050859.jpg?w=1800',
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
                  image: const DecorationImage(
                    image: NetworkImage('https://i.pravatar.cc/300?img=16'),
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
                      'Fashion Elite Store',
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

  Widget _buildProductsTab() {
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
          mainAxisExtent: 250
        ),
        itemCount: 12,
        itemBuilder: (context, index) => _productCard(),
      ),
    );
  }

  Widget _productCard() {
    return GestureDetector(
      onTap: (){
        Get.to(() => ProductDetailsView());
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
                    'https://i.pinimg.com/736x/af/38/16/af3816f775f479ab6fb7dfaf30d3e553.jpg',
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
                  Text('Leather Jacket', style: h4, maxLines: 1, overflow: TextOverflow.ellipsis),
                  const SizedBox(height: 6),
                  Text('\$89.99', style: h3.copyWith(color: AppColors.mainColor, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 6),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAboutTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('About Store', style: h2.copyWith(fontSize: 20)),
          const SizedBox(height: 16),
          Text(
            'Fashion Elite Store has been providing premium quality fashion items since 2018. We specialize in leather jackets, designer wear, and trendy accessories. Trusted by over 45k+ happy customers worldwide.',
            style: h4.copyWith(height: 1.7, color: AppColors.textColor.withValues(alpha: 0.9),),
          ),
          const SizedBox(height: 24),
          _infoRow(Icons.location_on, 'Lagos, Nigeria'),
          _infoRow(Icons.phone, '+234 801 234 5678'),
          _infoRow(Icons.email, 'support@fashionelite.com'),
          _infoRow(Icons.access_time, 'Open • 9:00 AM - 10:00 PM'),
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