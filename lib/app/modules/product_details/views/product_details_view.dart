import 'package:expiry_deals/app/modules/cart/views/cart_view.dart';
import 'package:expiry_deals/app/modules/favorites/controllers/favorites_controller.dart';
import 'package:expiry_deals/app/modules/home/model/search_product_model.dart' as sp;
import 'package:expiry_deals/app/modules/product_details/controllers/add_to_cart_controller.dart';
import 'package:expiry_deals/app/modules/product_details/controllers/product_details_controller.dart';
import 'package:expiry_deals/app/modules/store/views/store_view.dart';
import 'package:expiry_deals/common/app_color/app_colors.dart';
import 'package:expiry_deals/common/app_images/app_images.dart';
import 'package:expiry_deals/common/app_text_style/styles.dart';
import 'package:expiry_deals/common/size_box/custom_sizebox.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:share_plus/share_plus.dart';

class ProductDetailsView extends StatefulWidget {
  final String productId;

  const ProductDetailsView({super.key, required this.productId});

  @override
  State<ProductDetailsView> createState() => _ProductDetailsViewState();
}

class _ProductDetailsViewState extends State<ProductDetailsView> {
  late final ProductDetailsController productDetailsController;
  final AddToCartController addToCartController = Get.put(AddToCartController());

  late final PageController _heroPageController;
  int _heroPageIndex = 0;

  // State for managing the item quantity
  int quantity = 1;

  @override
  void initState() {
    super.initState();
    _heroPageController = PageController();
    productDetailsController = Get.put(
      ProductDetailsController(),
      tag: widget.productId,
    );
    productDetailsController.fetchSingleProduct(productId: widget.productId);
  }

  @override
  void dispose() {
    _heroPageController.dispose();
    if (Get.isRegistered<ProductDetailsController>(tag: widget.productId)) {
      Get.delete<ProductDetailsController>(tag: widget.productId);
    }
    super.dispose();
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

  /// Dark circular chip so back/cart stay visible on white or busy hero images.
  Widget _heroChromeButton({
    required VoidCallback onPressed,
    required Widget child,
    String? tooltip,
  }) {
    final button = Material(
      color: Colors.black.withValues(alpha: 0.52),
      shape: const CircleBorder(),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        customBorder: const CircleBorder(),
        onTap: onPressed,
        child: SizedBox(
          width: 44,
          height: 44,
          child: Center(child: child),
        ),
      ),
    );
    if (tooltip == null || tooltip.isEmpty) return button;
    return Tooltip(message: tooltip, child: button);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bgColor,
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        automaticallyImplyLeading: false,
        leadingWidth: 60,
        leading: Padding(
          padding: const EdgeInsets.only(left: 8),
          child: Align(
            alignment: Alignment.centerLeft,
            child: _heroChromeButton(
              tooltip: 'Back',
              onPressed: () => Get.back(),
              child: const Icon(
                Icons.arrow_back_rounded,
                color: Colors.white,
                size: 22,
              ),
            ),
          ),
        ),
        actions: [
          Obx(() {
            final fav = Get.find<FavoritesController>();
            final id = widget.productId;
            final saved = fav.ids.contains(id);
            return Padding(
              padding: const EdgeInsets.only(right: 4),
              child: _heroChromeButton(
                tooltip: saved ? 'Remove from saved' : 'Save',
                onPressed: () => fav.toggle(id),
                child: Icon(
                  saved ? Icons.favorite_rounded : Icons.favorite_border_rounded,
                  color: saved ? const Color(0xFFFF6B6B) : Colors.white,
                  size: 22,
                ),
              ),
            );
          }),
          Obx(() {
            final d = productDetailsController.singleProduct.value.data;
            if (d == null) {
              return const SizedBox(width: 44);
            }
            return Padding(
              padding: const EdgeInsets.only(right: 4),
              child: _heroChromeButton(
                tooltip: 'Share',
                onPressed: () {
                  final name = d.name ?? 'Product';
                  final raw = d.discount;
                  final disc = raw is num ? raw.toDouble() : 0.0;
                  final line = disc > 0
                      ? '$name — ${disc.round()}% off on Expiry Deals'
                      : '$name on Expiry Deals';
                  Share.share(line, subject: name);
                },
                child: const Icon(
                  Icons.share_outlined,
                  color: Colors.white,
                  size: 22,
                ),
              ),
            );
          }),
          Obx(() {
            final cart = addToCartController.cartController;
            final totalQty = cart.cartItems.fold<int>(
              0,
              (sum, e) => sum + (e.quantity ?? 0),
            );
            return Padding(
              padding: const EdgeInsets.only(right: 8),
              child: _heroChromeButton(
                tooltip: 'Cart',
                onPressed: () => Get.to(() => const CartView()),
                child: Stack(
                  clipBehavior: Clip.none,
                  alignment: Alignment.center,
                  children: [
                    const Icon(
                      Icons.shopping_cart_outlined,
                      color: Colors.white,
                      size: 22,
                    ),
                    if (totalQty > 0)
                      Positioned(
                        right: -2,
                        top: -4,
                        child: Container(
                          constraints: const BoxConstraints(minWidth: 18, minHeight: 18),
                          padding: const EdgeInsets.symmetric(horizontal: 5),
                          decoration: BoxDecoration(
                            color: AppColors.red,
                            borderRadius: BorderRadius.circular(9),
                            border: Border.all(color: Colors.white, width: 1.5),
                          ),
                          alignment: Alignment.center,
                          child: Text(
                            totalQty > 99 ? '99+' : '$totalQty',
                            style: GoogleFonts.dmSans(
                              fontSize: 10,
                              fontWeight: FontWeight.w800,
                              color: Colors.white,
                              height: 1,
                            ),
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            );
          }),
        ],
      ),
      body: Obx(() {
        // Fetching product details here because this is reactive
        var productDetails = productDetailsController.singleProduct.value.data;

        int stock = productDetails?.stock ?? 0; // Get the available stock

        final imgs = productDetails?.images ?? [];
        final imageUrls = imgs
            .map((e) => e.url ?? '')
            .where((u) => u.isNotEmpty)
            .toList();

        return productDetailsController.isLoading.value ? Center(child: SpinKitDualRing(
          color: AppColors.mainColor,
          size: 30.0,
        )) : Stack(
          children: [
            SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Product images — swipe when multiple; safe when none
                  Stack(
                    children: [
                      SizedBox(
                        height: 420,
                        width: double.infinity,
                        child: imageUrls.isEmpty
                            ? ColoredBox(
                                color: AppColors.grayLight,
                                child: Center(
                                  child: Image.network(
                                    AppImages.noImage,
                                    fit: BoxFit.contain,
                                    height: 120,
                                  ),
                                ),
                              )
                            : PageView.builder(
                                controller: _heroPageController,
                                onPageChanged: (i) =>
                                    setState(() => _heroPageIndex = i),
                                itemCount: imageUrls.length,
                                itemBuilder: (context, i) => Image.network(
                                  imageUrls[i],
                                  fit: BoxFit.cover,
                                  width: double.infinity,
                                  errorBuilder: (_, __, ___) => ColoredBox(
                                    color: AppColors.grayLight,
                                    child: Icon(
                                      Icons.broken_image_outlined,
                                      size: 48,
                                      color: AppColors.hintColor,
                                    ),
                                  ),
                                ),
                              ),
                      ),
                      if (imageUrls.length > 1)
                        Positioned(
                          bottom: 20,
                          left: 0,
                          right: 0,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: List.generate(
                              imageUrls.length,
                              (i) => Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 3),
                                child: Container(
                                  width: 7,
                                  height: 7,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: _heroPageIndex == i
                                        ? Colors.white
                                        : Colors.white.withValues(alpha: 0.45),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      Positioned(
                        top: 100, right: 30,
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                          decoration: BoxDecoration(color: AppColors.red, borderRadius: BorderRadius.circular(20)),
                          child: Text('-${productDetails?.discount}% OFF', style: GoogleFonts.dmSans(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 12)),
                        ),
                      ),
                    ],
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
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withValues(alpha: 0.04),
                                blurRadius: 10,
                              ),
                            ],
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
                              '\$${((productDetails?.price ?? 0) * (1 - (productDetails?.discount ?? 0) / 100)).toStringAsFixed(2)}',
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
                          style: h4.copyWith(
                            height: 1.8,
                            color: AppColors.textColor.withValues(alpha: 0.9),
                          ),
                        ),

                        const SizedBox(height: 28),
                        Obx(() {
                          final loading = productDetailsController
                              .similarLoading.value;
                          final list =
                              productDetailsController.similarProducts;
                          if (loading && list.isEmpty) {
                            return const Padding(
                              padding: EdgeInsets.symmetric(vertical: 20),
                              child: Center(
                                child: SizedBox(
                                  width: 26,
                                  height: 26,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2.5,
                                    color: AppColors.mainColor,
                                  ),
                                ),
                              ),
                            );
                          }
                          if (list.isEmpty) return const SizedBox.shrink();
                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Container(
                                    width: 4,
                                    height: 22,
                                    decoration: BoxDecoration(
                                      color: AppColors.mainColor,
                                      borderRadius: BorderRadius.circular(2),
                                    ),
                                  ),
                                  const SizedBox(width: 10),
                                  Text(
                                    'You may also like',
                                    style: h2.copyWith(
                                      fontSize: 20,
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 14),
                              SizedBox(
                                // Card: 148/1.05 image + padding + 2-line title + price (~218px); leave headroom for font metrics
                                height: 228,
                                child: ListView.separated(
                                  scrollDirection: Axis.horizontal,
                                  itemCount: list.length,
                                  separatorBuilder: (_, __) =>
                                      const SizedBox(width: 12),
                                  itemBuilder: (context, i) {
                                    return _SimilarProductCard(
                                      product: list[i],
                                    );
                                  },
                                ),
                              ),
                            ],
                          );
                        }),

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

                    // Buttons + inline loading (never use GetX overlay for "adding" — it can stick)
                    Obx(() {
                      final busy = addToCartController.isLoading.value;
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Stack(
                            alignment: Alignment.center,
                            children: [
                              Row(
                                children: [
                                  Expanded(
                                    child: Material(
                                      color: Colors.transparent,
                                      child: InkWell(
                                        onTap: busy
                                            ? null
                                            : () {
                                                addToCartController.addToCart(
                                                  productId: productDetails?.id ?? "",
                                                  quantity: quantity,
                                                  isBuyNow: false,
                                                  authorId: productDetails?.author?.id ?? "",
                                                );
                                              },
                                        borderRadius: BorderRadius.circular(18),
                                        child: Ink(
                                          padding: const EdgeInsets.symmetric(vertical: 20),
                                          decoration: BoxDecoration(
                                            color: AppColors.mainColor,
                                            borderRadius: BorderRadius.circular(18),
                                          ),
                                          child: Center(
                                            child: Text(
                                              'Add to cart',
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
                                  ),
                                  const SizedBox(width: 16),
                                  Expanded(
                                    child: Material(
                                      color: Colors.transparent,
                                      child: InkWell(
                                        onTap: busy
                                            ? null
                                            : () {
                                                addToCartController.addToCart(
                                                  productId: productDetails?.id ?? "",
                                                  quantity: quantity,
                                                  isBuyNow: true,
                                                  authorId: productDetails?.author?.id ?? "",
                                                );
                                              },
                                        borderRadius: BorderRadius.circular(18),
                                        child: Ink(
                                          padding: const EdgeInsets.symmetric(vertical: 20),
                                          decoration: BoxDecoration(
                                            color: AppColors.black,
                                            borderRadius: BorderRadius.circular(18),
                                          ),
                                          child: Center(
                                            child: Text(
                                              'Buy now',
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
                                  ),
                                ],
                              ),
                              if (busy)
                                Positioned.fill(
                                  child: Container(
                                    decoration: BoxDecoration(
                                      color: Colors.black.withValues(alpha: 0.25),
                                      borderRadius: BorderRadius.circular(18),
                                    ),
                                    alignment: Alignment.center,
                                    child: SizedBox(
                                      width: 28,
                                      height: 28,
                                      child: CircularProgressIndicator(
                                        strokeWidth: 2.5,
                                        color: AppColors.mainColor,
                                      ),
                                    ),
                                  ),
                                ),
                            ],
                          ),
                          if (busy) ...[
                            const SizedBox(height: 14),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                SizedBox(
                                  width: 18,
                                  height: 18,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                    color: AppColors.mainColor,
                                  ),
                                ),
                                const SizedBox(width: 10),
                                Text(
                                  'Adding to cart…',
                                  style: GoogleFonts.dmSans(
                                    fontSize: 15,
                                    fontWeight: FontWeight.w600,
                                    color: AppColors.mainColor,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ],
                      );
                    }),
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

class _SimilarProductCard extends StatelessWidget {
  const _SimilarProductCard({required this.product});

  final sp.SearchProduct product;

  @override
  Widget build(BuildContext context) {
    final imgUrl = product.images.isNotEmpty
        ? (product.images.first.url ?? '')
        : '';
    final price = product.price is num
        ? (product.price as num).toDouble()
        : double.tryParse('${product.price}') ?? 0;
    final disc = product.discount is num
        ? (product.discount as num).toDouble()
        : double.tryParse('${product.discount}') ?? 0;
    final sale = price * (1 - disc / 100);

    return SizedBox(
      width: 148,
      child: Material(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(16),
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: () => Get.to(
            () => ProductDetailsView(productId: product.id ?? ''),
          ),
          child: Ink(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: AppColors.grayLight.withValues(alpha: 0.75),
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ClipRRect(
                  borderRadius:
                      const BorderRadius.vertical(top: Radius.circular(15)),
                  child: AspectRatio(
                    aspectRatio: 1.05,
                    child: imgUrl.isEmpty
                        ? ColoredBox(
                            color: AppColors.grayLight,
                            child: Icon(
                              Icons.image_outlined,
                              color: AppColors.hintColor,
                            ),
                          )
                        : Image.network(
                            imgUrl,
                            fit: BoxFit.cover,
                            errorBuilder: (_, __, ___) => ColoredBox(
                              color: AppColors.grayLight,
                              child: Icon(
                                Icons.broken_image_outlined,
                                color: AppColors.hintColor,
                              ),
                            ),
                          ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(10, 8, 10, 10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        product.name ?? '',
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: GoogleFonts.dmSans(
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                          height: 1.25,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        '\$${sale.toStringAsFixed(2)}',
                        style: GoogleFonts.dmSans(
                          fontSize: 15,
                          fontWeight: FontWeight.w800,
                          color: AppColors.mainColor,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
