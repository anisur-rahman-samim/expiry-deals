import 'package:expiry_deals/app/modules/store/views/store_view.dart';
import 'package:expiry_deals/common/app_color/app_colors.dart';
import 'package:expiry_deals/common/app_text_style/styles.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

class ProductDetailsView extends StatelessWidget {
  ProductDetailsView({super.key});

  final List<String> productImageList = [
    "https://www.dhresource.com/webp/m/0x0/f2/albu/g21/M00/1F/F5/rBVaq2DCDRGABLbyAADQ8DkUmO8389.jpg",
    "https://i.pinimg.com/736x/af/38/16/af3816f775f479ab6fb7dfaf30d3e553.jpg",
    "https://img.freepik.com/free-photo/woman-leaning-white-wooden-board-talking-phone-while-smiling_1157-2023.jpg",
    "https://img.freepik.com/free-photo/young-attractive-woman-blue-winter-jacket_1303-20115.jpg",
    "https://media.istockphoto.com/id/641684768/photo/pretty-girl-in-a-leather-jacket-on-white-background.jpg?s=612x612&w=is&k=20&c=p1Cbfw4L-mKS3eRGpk4DD3QQi3XvdqH2Ot28aOBR2xQ=",
    "https://www.dhresource.com/webp/m/0x0/f2/albu/g21/M00/1F/F5/rBVaq2DCDRGABLbyAADQ8DkUmO8389.jpg"
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bgColor,
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        foregroundColor: Colors.white,
      ),
      body: Stack(
        children: [
          SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Main Product Image (Single Large Image)
                Container(
                  height: 420,
                  width: double.infinity,
                  decoration: const BoxDecoration(
                    image: DecorationImage(
                      image: NetworkImage(
                        "https://img.freepik.com/free-photo/young-attractive-woman-blue-winter-jacket_1303-20115.jpg?w=740",
                      ),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),

                // Content Area
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(20),
                  decoration: const BoxDecoration(
                    color: AppColors.bgColor,
                    borderRadius: BorderRadius.vertical(top: Radius.circular(32)),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Vendor Card
                      _buildVendorCard(),
                      const SizedBox(height: 20),

                      // Product Title
                      Text(
                        'Premium Leather Jacket for Women',
                        style: h2.copyWith(fontSize: 24),
                      ),
                      const SizedBox(height: 12),

                      // Price + Discount
                      Row(
                        children: [
                          Text(
                            '\$89.99',
                            style: h2.copyWith(color: AppColors.mainColor, fontSize: 30),
                          ),
                          const SizedBox(width: 16),
                          Text(
                            '\$189.99',
                            style: h4.copyWith(
                              decoration: TextDecoration.lineThrough,
                              color: AppColors.hintColor,
                            ),
                          ),
                          const SizedBox(width: 16),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                            decoration: BoxDecoration(
                              color: AppColors.red,
                              borderRadius: BorderRadius.circular(30),
                            ),
                            child: Text(
                              '-53% OFF',
                              style: GoogleFonts.dmSans(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 14,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 28),

                      // Product Description (Direct - No Tabs!)
                      Text(
                        'Product Description',
                        style: h2.copyWith(fontSize: 19),
                      ),
                      const SizedBox(height: 12),
                      Text(
                        'Elevate your style with this premium genuine leather jacket. Crafted from 100% cowhide leather with a soft inner lining for maximum comfort. Features include zippered pockets, adjustable waist belt, and a detachable hood. Perfect for winter, casual outings, and making a bold fashion statement.',
                        style: h4.copyWith(height: 1.8, color: AppColors.textColor.withValues(alpha: 0.9),),
                      ),
                      const SizedBox(height: 32),

                      // You Might Also Like (using your productImageList)
                      Text(
                        'You Might Also Like',
                        style: h2.copyWith(fontSize: 19),
                      ),
                      const SizedBox(height: 16),
                      SizedBox(
                        height: 260,
                        child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: productImageList.length,
                          itemBuilder: (context, index) {
                            return _relatedProductCard(productImageList[index]);
                          },
                        ),
                      ),
                      const SizedBox(height: 120), // Space for bottom bar
                    ],
                  ),
                ),
              ],
            ),
          ),

          // Sticky Bottom Action Bar (Custom Containers)
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: AppColors.white,
                borderRadius: const BorderRadius.vertical(top: Radius.circular(32)),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.12),
                    blurRadius: 20,
                    offset: const Offset(0, -5),
                  ),
                ],
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Quantity Selector
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                    decoration: BoxDecoration(
                      border: Border.all(color: AppColors.grayLight, width: 1.5),
                      borderRadius: BorderRadius.circular(50),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        InkWell(
                          onTap: () {},
                          borderRadius: BorderRadius.circular(50),
                          child: const Padding(
                            padding: EdgeInsets.all(8),
                            child: Icon(Icons.remove, size: 26, color: AppColors.black),
                          ),
                        ),
                        Text(
                          '1 Item',
                          style: GoogleFonts.dmSans(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                            color: AppColors.black,
                          ),
                        ),
                        InkWell(
                          onTap: () {},
                          borderRadius: BorderRadius.circular(50),
                          child: Container(
                            padding: const EdgeInsets.all(8),
                            decoration: const BoxDecoration(
                              color: AppColors.mainColor,
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(Icons.add, size: 26, color: Colors.white),
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 20),

                  // Buttons Row
                  Row(
                    children: [
                      // Add to Cart Button (Custom Container)
                      Expanded(
                        child: InkWell(
                          onTap: () {},
                          borderRadius: BorderRadius.circular(18),
                          child: Container(
                            padding: const EdgeInsets.symmetric(vertical: 20),
                            decoration: BoxDecoration(
                              color: AppColors.mainColor,
                              borderRadius: BorderRadius.circular(18),
                            ),
                            child: Center(
                              child: Text(
                                'Add to Cart',
                                style: GoogleFonts.dmSans(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w700,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),

                      const SizedBox(width: 16),

                      // Buy Now Button (Custom Container)
                      Expanded(
                        child: InkWell(
                          onTap: () {},
                          borderRadius: BorderRadius.circular(18),
                          child: Container(
                            padding: const EdgeInsets.symmetric(vertical: 20),
                            decoration: BoxDecoration(
                              color: AppColors.black,
                              borderRadius: BorderRadius.circular(18),
                            ),
                            child: Center(
                              child: Text(
                                'Buy Now',
                                style: GoogleFonts.dmSans(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w700,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Vendor Card
  Widget _buildVendorCard() {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: AppColors.grayLight),
        boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.04), blurRadius: 10)],
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: 26,
            backgroundImage: NetworkImage('https://i.pravatar.cc/150?img=5'),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Fashion Elite Store', style: h3.copyWith(fontWeight: FontWeight.w600)),
                Row(
                  children: [
                    const Icon(Icons.star, color: Colors.amber, size: 17),
                    Text(' 4.9', style: GoogleFonts.dmSans(fontSize: 14, fontWeight: FontWeight.w600)),
                    Text(' • 45.2k+ Products', style: h5.copyWith(color: AppColors.hintColor)),
                  ],
                ),
              ],
            ),
          ),
          OutlinedButton(
            onPressed: () {
              Get.to(() => StoreView());
            },
            style: OutlinedButton.styleFrom(
              side: BorderSide(color: AppColors.mainColor, width: 1.5),
              foregroundColor: AppColors.mainColor,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: Text('Visit Store', style: GoogleFonts.dmSans(fontWeight: FontWeight.w600)),
            ),
          ),
        ],
      ),
    );
  }

  // Related Product Card using productImageList
  Widget _relatedProductCard(String imageUrl) {
    return Container(
      width: 170,
      margin: const EdgeInsets.only(right: 16),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.06), blurRadius: 12, offset: const Offset(0, 6))],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
            child: Image.network(
              imageUrl,
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
}