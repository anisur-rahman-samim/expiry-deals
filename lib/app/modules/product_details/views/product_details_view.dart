import 'package:expiry_deals/app/modules/product_details/controllers/add_to_cart_controller.dart';
import 'package:expiry_deals/app/modules/product_details/controllers/product_details_controller.dart';
import 'package:expiry_deals/app/modules/store/views/store_view.dart';
import 'package:expiry_deals/common/app_color/app_colors.dart';
import 'package:expiry_deals/common/app_images/app_images.dart';
import 'package:expiry_deals/common/app_text_style/styles.dart';
import 'package:expiry_deals/common/size_box/custom_sizebox.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../home/model/product_model.dart';

class ProductDetailsView extends StatefulWidget {
  final String productId;

  const ProductDetailsView({super.key, required this.productId});

  @override
  State<ProductDetailsView> createState() => _ProductDetailsViewState();
}

class _ProductDetailsViewState extends State<ProductDetailsView> {
  final ProductDetailsController productDetailsController = Get.put(ProductDetailsController());
  final AddToCartController addToCartController = Get.put(AddToCartController());


  // State for managing the item quantity
  int quantity = 1;

  @override
  void initState() {
    productDetailsController.fetchSingleProduct(productId: widget.productId);
    super.initState();
  }

  // Method to increase the quantity with stock limit
  void increaseQuantity(int stock) {
    setState(() {
      if (quantity < stock) {
        quantity++;
      }
    });
  }

  // Method to decrease the quantity, ensuring it never goes below 1
  void decreaseQuantity() {
    setState(() {
      if (quantity > 1) {
        quantity--;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bgColor,
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
      //  foregroundColor: Colors.white,
      ),
      body: Obx(() {
        // Fetching product details here because this is reactive
        var productDetails = productDetailsController.singleProduct.value.data;

        int stock = productDetails?.stock ?? 0; // Get the available stock

        return Stack(
          children: [
            SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Main Product Image (Single Large Image)
                  Container(
                    height: 420,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: NetworkImage(productDetails?.images[0].url ?? ""),
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
                        Container(
                          padding: const EdgeInsets.all(18),
                          decoration: BoxDecoration(
                            color: AppColors.white,
                            borderRadius: BorderRadius.circular(18),
                            border: Border.all(color: AppColors.grayLight),
                            boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 10)],
                          ),
                          child: Row(
                            children: [
                              CircleAvatar(
                                radius: 26,
                                backgroundImage: NetworkImage(productDetails?.author?.shop?.logo ?? AppImages.noImage),
                              ),
                              const SizedBox(width: 16),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(productDetails?.author?.shop?.name ?? "", style: h3.copyWith(fontWeight: FontWeight.w600)),
                                  ],
                                ),
                              ),
                              OutlinedButton(
                                onPressed: () {
                                  Get.to(() => StoreView(shopId: productDetails?.author?.shop?.id ?? "",authorId: productDetails?.author?.id ?? "",));
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
                        ),
                        const SizedBox(height: 20),

                        // Product Title
                        Text(
                          productDetails?.name ?? "",
                          style: h2.copyWith(fontSize: 24),
                        ),
                        const SizedBox(height: 12),

                        // Price + Discount
                        Row(
                          children: [
                            Text(
                              '\$${productDetails?.discount}',
                              style: h2.copyWith(color: AppColors.mainColor, fontSize: 30),
                            ),
                            const SizedBox(width: 16),
                            Text(
                              '\$${productDetails?.price}',
                              style: h4.copyWith(
                                decoration: TextDecoration.lineThrough,
                                color: AppColors.hintColor,
                              ),
                            ),
                            const SizedBox(width: 16),
                          ],
                        ),
                        const SizedBox(height: 28),

                        // Product Description
                        Text(
                          'Product Description',
                          style: h2.copyWith(fontSize: 19),
                        ),
                        const SizedBox(height: 12),
                        Text(
                          productDetails?.details ?? "No Description Available",
                          style: h4.copyWith(height: 1.8, color: AppColors.textColor.withOpacity(0.9)),
                        ),

                        const SizedBox(height: 120), // Space for bottom bar
                      ],
                    ),
                  ),
                  sh100,
                  sh100,
                ],
              ),
            ),

            // Sticky Bottom Action Bar
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
                      color: Colors.black.withOpacity(0.12),
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
                            onTap: () => decreaseQuantity(),
                            borderRadius: BorderRadius.circular(50),
                            child: const Padding(
                              padding: EdgeInsets.all(8),
                              child: Icon(Icons.remove, size: 26, color: AppColors.black),
                            ),
                          ),
                          Text(
                            '$quantity Item${quantity > 1 ? 's' : ''}', // Dynamically showing item(s)
                            style: GoogleFonts.dmSans(
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                              color: AppColors.black,
                            ),
                          ),
                          InkWell(
                            onTap: () => increaseQuantity(stock),
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
                        Expanded(
                          child: InkWell(
                            onTap: () {
                              addToCartController.addToCart(productId: productDetails?.id ?? "", quantity: quantity,isBuyNow: false,authorId: productDetails?.author?.id ?? "");
                            },
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
                        Expanded(
                          child: InkWell(
                            onTap: () {
                              addToCartController.addToCart(productId: productDetails?.id ?? "", quantity: quantity,isBuyNow: true, authorId: productDetails?.author?.id ?? ""
                              );

                            },
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
        );
      }),
    );
  }
}
