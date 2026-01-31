import 'package:expiry_deals/app/modules/cart/controllers/cart_controller.dart';
import 'package:expiry_deals/app/modules/cart/model/add_to_cart_model.dart';
import 'package:expiry_deals/app/modules/cart/views/billing_details_view.dart';
import 'package:expiry_deals/app/modules/dashboard/views/dashboard_view.dart';
import 'package:expiry_deals/common/app_color/app_colors.dart';
import 'package:expiry_deals/common/app_text_style/styles.dart';
import 'package:flutter/material.dart' as Material;
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

class CartView extends Material.StatefulWidget {
  CartView({super.key});

  @override
  Material.State<CartView> createState() => _CartViewState();
}

class _CartViewState extends Material.State<CartView> {
  final CartController controller = Get.put(CartController());

  @override
  void initState() {
    controller.fetchAddToCart();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bgColor,
      appBar: AppBar(
        title: Text('My Cart', style: GoogleFonts.dmSans(fontSize: 22, fontWeight: FontWeight.w700)),
        centerTitle: true,
        backgroundColor: AppColors.bgColor,
        elevation: 0,
        foregroundColor: AppColors.black,
      ),
      body: Obx(() {
        if (controller.cartItems.isEmpty) {
          return _buildEmptyCart(context);
        }

        double totalPrice = 0;
        List<Map<String, dynamic>> items = [];

        // Calculate total price and prepare items list
        for (var item in controller.cartItems) {
          double itemPrice = (item.product?.price ?? 0) * (item.quantity ?? 1);
          totalPrice += itemPrice;

          items.add({
            "product": item.product?.id,
            "quantity": item.quantity,
          });
        }

        return Stack(
          children: [
            // Cart Items List
            RefreshIndicator(
              onRefresh: () async => await Future.delayed(const Duration(seconds: 1)),
              color: AppColors.mainColor,
              child: ListView.builder(
                padding: const EdgeInsets.only(bottom: 160), // Space for bottom bar
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
              child: _buildCheckoutBar(totalPrice, items),
            ),
          ],
        );
      }),
    );
  }

  // Empty Cart State
  Widget _buildEmptyCart(BuildContext context) {
    return RefreshIndicator(
      onRefresh: () async {},
      child: ListView(
        physics: const AlwaysScrollableScrollPhysics(),
        children: [
          SizedBox(height: Get.height * 0.15),
          Center(
            child: Column(
              children: [
                Icon(Icons.shopping_bag_outlined, size: 100, color: AppColors.gray),
                const SizedBox(height: 24),
                Text('Your cart is empty', style: h2.copyWith(fontSize: 24)),
                const SizedBox(height: 12),
                Text('Add items to get started!', style: h4.copyWith(color: AppColors.hintColor)),
                const SizedBox(height: 24),
                ElevatedButton(
                  onPressed: () => Get.to(() => DashboardView()),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.mainColor,
                    padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                  ),
                  child: Text('Continue Shopping', style: GoogleFonts.dmSans(fontWeight: FontWeight.w600, color: Colors.white)),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // Cart Item Card
  Widget _buildCartItem(AddToCart item) {
    return Dismissible(
      key: Key(item.id ?? ''),
      direction: DismissDirection.endToStart,
      background: Container(
        margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
        decoration: BoxDecoration(color: AppColors.red, borderRadius: BorderRadius.circular(16)),
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 30),
        child: const Icon(Icons.delete_forever, color: Colors.white, size: 32),
      ),
      onDismissed: (_) {
        controller.removeFromCart(item.id ?? '');
        controller.deleteAddToCart(cartId: item.id ?? "");
      },
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: AppColors.grayLight),
          boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10, offset: const Offset(0, 4))],
        ),
        child: Row(
          children: [
            // Product Image
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Material.Image.network(
                item.product?.images.first.url ?? '',  // Updated access to images
                width: 80,
                height: 80,
                fit: BoxFit.cover,
              ),
            ),
            const SizedBox(width: 16),

            // Details
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(item.product?.name ?? '', style: h3.copyWith(fontWeight: FontWeight.w600), maxLines: 2, overflow: TextOverflow.ellipsis),
                  const SizedBox(height: 8),
                  Text("QTY: ${item.quantity}", style: h3.copyWith(fontWeight: FontWeight.w600)),
                  const SizedBox(height: 8),
                  Text('\$${item.product?.price?.toStringAsFixed(2)}', style: h2.copyWith(color: AppColors.mainColor)),
                ],
              ),
            ),

            // Quantity Control
            GestureDetector(
              onTap: (){
                controller.deleteAddToCart(cartId: item.id ?? "");
              },
              child: Container(
                decoration: BoxDecoration(
                  border: Border.all(color: AppColors.grayLight),
                  borderRadius: BorderRadius.circular(30),
                ),
                child: Material.Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Icon(Icons.delete,color: AppColors.red,),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Checkout Bottom Bar
  Widget _buildCheckoutBar(double totalPrice, List<Map<String, dynamic>> items) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(32)),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.12), blurRadius: 20, offset: const Offset(0, -5))],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Price Breakdown
          _priceRow('Subtotal', totalPrice),
          _priceRow('Shipping cost', 0.0),
          const Divider(height: 24),
          _priceRow('Total', totalPrice + 0.0, bold: true, large: true),  // Add shipping cost to total

          const SizedBox(height: 16),

          // Checkout Button
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {
                // Navigate to BillingDetailsView with calculated total price and items list
                Get.to(() => BillingDetailsView(
                  authorId: controller.cartItems.first.product?.author?.id ?? "",
                  totalPrice: totalPrice,
                  items: items, // Pass the items here
                ));
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.mainColor,
                padding: const EdgeInsets.symmetric(vertical: 20),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
              ),
              child: Text(
                'Proceed to Checkout (${controller.cartItems.length} items)',
                style: GoogleFonts.dmSans(fontSize: 18, fontWeight: FontWeight.w700, color: Colors.white),
              ),
            ),
          ),
          const SizedBox(height: 150),
        ],
      ),
    );
  }

  // Price Row Helper
  Widget _priceRow(String label, double amount, {bool bold = false, bool large = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: bold ? h3.copyWith(fontWeight: FontWeight.w600) : h4.copyWith(color: AppColors.hintColor)),
          Text(
            '\$${amount.toStringAsFixed(2)}',
            style: large
                ? h1.copyWith(color: AppColors.mainColor, fontSize: 26)
                : bold
                ? h2.copyWith(color: AppColors.mainColor)
                : h3,
          ),
        ],
      ),
    );
  }
}
