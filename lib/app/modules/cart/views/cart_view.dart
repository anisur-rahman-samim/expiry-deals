import 'package:expiry_deals/app/modules/cart/controllers/cart_controller.dart';
import 'package:expiry_deals/app/modules/cart/model/add_to_cart_model.dart';
import 'package:expiry_deals/app/modules/cart/views/billing_details_view.dart';
import 'package:expiry_deals/app/modules/dashboard/controllers/dashboard_controller.dart';
import 'package:expiry_deals/app/routes/app_pages.dart';
import 'package:expiry_deals/common/app_color/app_colors.dart';
import 'package:expiry_deals/common/app_text_style/styles.dart';
import 'package:expiry_deals/common/size_box/custom_sizebox.dart';
import 'package:flutter/material.dart';
import 'package:flutter/material.dart' as material;
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

class CartView extends StatefulWidget {
  const CartView({super.key});

  @override
  State<CartView> createState() => _CartViewState();
}

class _CartViewState extends State<CartView> {
  final CartController controller = Get.put(CartController());

  @override
  void initState() {
    super.initState();
    // Skip redundant GET if cart was just refreshed (e.g. Buy now from product).
    if (controller.cartItems.isEmpty) {
      controller.fetchAddToCart();
    } else {
      controller.calculateTotal();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bgColor,
      appBar: AppBar(
        title: Text(
          'My Cart',
          style: GoogleFonts.dmSans(fontSize: 22, fontWeight: FontWeight.w700),
        ),
        centerTitle: true,
        backgroundColor: AppColors.bgColor,
        elevation: 0,
        foregroundColor: AppColors.black,
      ),
      body: Obx(() {
        if (controller.cartItems.isEmpty) {
          return _buildEmptyCart(context);
        }

        // Calculations moved inside Obx — this is fine as long as we don't mutate observables here
        final totalPrice = controller.cartItems.fold<double>(
          0.0,
              (sum, item) => sum + ((item.product?.price ?? 0) * (1 - (item.product?.discount ?? 0) / 100) ?? 0) * (item.quantity ?? 1),
        );

        final checkoutItems = controller.cartItems
            .map((item) => {
          "product": item.product?.id,
          "quantity": item.quantity,
        })
            .toList();

        return Stack(
          children: [
            // Cart Items List
            RefreshIndicator(
              onRefresh: controller.fetchAddToCart,
              color: AppColors.mainColor,
              child: ListView.builder(
                padding: const EdgeInsets.only(bottom: 180),
                itemCount: controller.cartItems.length,
                itemBuilder: (context, index) {
                  final item = controller.cartItems[index];
                  return _buildCartItem(item);
                },
              ),
            ),

            // Sticky Bottom Checkout Bar
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: _buildCheckoutBar(totalPrice, checkoutItems),
            ),
          ],
        );
      }),
    );
  }

  Widget _buildEmptyCart(BuildContext context) {
    return RefreshIndicator(
      onRefresh: controller.fetchAddToCart,
      color: AppColors.mainColor,
      child: ListView(
        physics: const AlwaysScrollableScrollPhysics(),
        children: [
          SizedBox(height: Get.height * 0.15),
          Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.shopping_bag_outlined, size: 100, color: AppColors.gray),
                const SizedBox(height: 24),
                Text('Your cart is empty', style: h2.copyWith(fontSize: 24)),
                const SizedBox(height: 12),
                Text(
                  'Add items to get started!',
                  style: h4.copyWith(color: AppColors.hintColor),
                ),
                const SizedBox(height: 32),
                ElevatedButton(
                  onPressed: () {
                    if (Get.isRegistered<DashboardController>()) {
                      Get.find<DashboardController>().changePage(0);
                    } else {
                      Get.offAllNamed(Routes.DASHBOARD);
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.mainColor,
                    padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                  ),
                  child: Text(
                    'Continue Shopping',
                    style: GoogleFonts.dmSans(fontWeight: FontWeight.w600, color: Colors.white),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCartItem(AddToCart item) {
    return Dismissible(
      key: Key(item.id ?? UniqueKey().toString()),
      direction: DismissDirection.endToStart,
      background: Container(
        margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
        decoration: BoxDecoration(
          color: AppColors.red,
          borderRadius: BorderRadius.circular(16),
        ),
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 30),
        child: const Icon(Icons.delete_forever, color: Colors.white, size: 32),
      ),
      onDismissed: (_) {
        controller.removeFromCart(item.id ?? '');
        controller.deleteAddToCart(cartId: item.id ?? '');
      },
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: AppColors.grayLight),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Product Image
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: material.Image.network(
                item.product?.images.firstOrNull?.url ?? '',
                width: 80,
                height: 80,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) => Container(
                  width: 80,
                  height: 80,
                  color: Colors.grey[200],
                  child: const Icon(Icons.image_not_supported),
                ),
              ),
            ),
            const SizedBox(width: 16),

            // Details
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    item.product?.name ?? 'Unknown Product',
                    style: h3.copyWith(fontWeight: FontWeight.w600),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 6),
                  Text(
                    "QTY: ${item.quantity ?? 1}",
                    style: h4.copyWith(fontWeight: FontWeight.w500),
                  ),
                  const SizedBox(height: 6),
                  Row(
                    children: [
                      Text(
                       // '\$${item.product?.price?.toStringAsFixed(2) ?? '0.00'}',
                        '\$${((item.product?.price ?? 0) * (1 - (item.product?.discount ?? 0) / 100)).toStringAsFixed(2)}',
                        style: h2.copyWith(color: AppColors.mainColor, fontWeight: FontWeight.w700),
                      ),
                      sw5,
                      Text('\$${ item.product?.price}', style: h3.copyWith(color: AppColors.gray, fontWeight: FontWeight.bold)),
                    ],
                  ),
                ],
              ),
            ),

            // Delete button (alternative to swipe)
            GestureDetector(
              onTap: () {
                controller.removeFromCart(item.id ?? '');
                controller.deleteAddToCart(cartId: item.id ?? '');
              },
              child: Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  border: Border.all(color: AppColors.grayLight),
                  borderRadius: BorderRadius.circular(30),
                ),
                child: Icon(Icons.delete, color: AppColors.red, size: 24),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCheckoutBar(double totalPrice, List<Map<String, dynamic>> items) {
    return Container(
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
          _priceRow('Subtotal', totalPrice),
          // _priceRow('Shipping cost', 8.7), // still commented out — uncomment if needed

          // Tax row: percentage + calculated amount
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 6),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("Tax", style: h4.copyWith(color: AppColors.black)),
                Text(
                  '${(totalPrice * 0.0825).toStringAsFixed(2)} (8.25%)',
                  style: h2.copyWith(color: AppColors.mainColor),
                ),
              ],
            ),
          ),

          const Divider(height: 28, thickness: 1),

          // Grand total (subtotal + tax)
          _priceRow(
            'Total',
            totalPrice * 1.0825,           // or totalPrice + (totalPrice * 0.0825)
            bold: true,
            large: true,
          ),

          const SizedBox(height: 20),

          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {
                if (controller.cartItems.isNotEmpty) {
                  // Option A: Pass subtotal only (most common — tax calculated later)
                  Get.to(() => BillingDetailsView(
                    authorId: controller.cartItems.first.product?.author?.id ?? "",
                    totalPrice: totalPrice * 1.0825,           // ← subtotal here
                    items: items,
                  ));

                  // Option B: If BillingDetailsView expects the final amount including tax:
                  // totalPrice: totalPrice * 1.0825,
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.mainColor,
                padding: const EdgeInsets.symmetric(vertical: 18),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
              ),
              child: Text(
                'Proceed to Checkout (${controller.cartItems.length} items)',
                style: GoogleFonts.dmSans(
                  fontSize: 17,
                  fontWeight: FontWeight.w700,
                  color: Colors.white,
                ),
              ),
            ),
          ),

          const SizedBox(height: 120),
        ],
      ),
    );
  }

  Widget _priceRow(String label, double amount, {bool bold = false, bool large = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: bold
                ? h3.copyWith(fontWeight: FontWeight.w600)
                : h4.copyWith(color: AppColors.hintColor),
          ),
          Text(
            '\$${amount.toStringAsFixed(2)}',
            style: large
                ? h1.copyWith(color: AppColors.mainColor, fontSize: 26, fontWeight: FontWeight.w700)
                : bold
                ? h2.copyWith(color: AppColors.mainColor, fontWeight: FontWeight.w700)
                : h3.copyWith(color: AppColors.mainColor),
          ),
        ],
      ),
    );
  }
}