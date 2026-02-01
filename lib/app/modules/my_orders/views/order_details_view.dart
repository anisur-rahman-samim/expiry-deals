import 'package:expiry_deals/app/modules/my_orders/model/my_order_model.dart' as myOrder;
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import '../controllers/my_orders_controller.dart';
import 'package:expiry_deals/common/app_color/app_colors.dart';
import 'package:expiry_deals/common/app_text_style/styles.dart';

class OrderDetailsView extends StatelessWidget {
  final myOrder.MyOrder order;

  const OrderDetailsView({super.key, required this.order});

  bool get canCancel => ['pending'].contains(order.status?.toLowerCase());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bgColor,
      appBar: AppBar(
        title: Text('Order Details', style: h2.copyWith(fontSize: 18)),
        centerTitle: true,
        backgroundColor: AppColors.bgColor,
        elevation: 0,
        foregroundColor: AppColors.black,
        // actions: [
        //   if (canCancel)
        //     TextButton(
        //       onPressed: () => _confirmCancel(context),
        //       child: Text(
        //         'Cancel Order',
        //         style: GoogleFonts.dmSans(color: AppColors.red, fontWeight: FontWeight.w600),
        //       ),
        //     ),
        // ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeader(),
            const SizedBox(height: 16),
            _buildSection('Items Ordered', _buildItems()),
            const SizedBox(height: 16),
            _buildSection('Price Breakdown', _buildPrice()),
            const SizedBox(height: 16),
            _buildSection('Shipping Address', _buildAddress()),
            const SizedBox(height: 16),
         //   _buildSection('Payment Method', _buildPayment()),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    final color = _statusColor();
    return _card(
      Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Order ${order.datumId}', style: h2),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                decoration: BoxDecoration(color: color.withValues(alpha: 0.08), borderRadius: BorderRadius.circular(20)),
                child: Text(
                  order.status!.capitalizeFirst!,
                  style: GoogleFonts.dmSans(color: color, fontWeight: FontWeight.w600),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            'Placed on ${DateFormat('dd MMMM yyyy • hh:mm a').format(order.createdAt!)}',
            style: h5.copyWith(color: AppColors.hintColor),
          ),
          const SizedBox(height: 8),
          Text(
            '${order.items.length} items • Total: \$${order.totalPrice!.toStringAsFixed(2)}',
            style: h3.copyWith(color: AppColors.mainColor),
          ),
        ],
      ),
    );
  }

  Widget _buildItems() => _card(ListView.separated(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: order.items.length,
        separatorBuilder: (_, __) => const Divider(height: 32),
        itemBuilder: (_, i) {
          final item = order.items[i];
          return Row(
            children: [
              Container(
                width: 70,
                height: 70,
                decoration: BoxDecoration(
                  color: AppColors.grayLight,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Image.network(item.product?.images[0].url ?? ""),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(item.product?.name ?? "", style: h3, maxLines: 2, overflow: TextOverflow.ellipsis),
                    Text('Qty: ${item.quantity}', style: h5.copyWith(color: AppColors.hintColor)),
                  ],
                ),
              ),
              Text('\$${(item.price! * item.quantity!).toStringAsFixed(2)}', style: h3.copyWith(fontWeight: FontWeight.w600)),
            ],
          );
        },
      ));

  Widget _buildPrice() {

    return _card(
      Column(
        children: [
         // _priceRow('Sub-Total', (order.items * order.quantity!).toStringAsFixed(2)!, bold: true, color: AppColors.mainColor),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 6),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("Tax", style: h4.copyWith(color: AppColors.black)),
                Text(
                  '8.25%',
                  style: h2.copyWith(color: AppColors.mainColor),
                ),
              ],
            ),
          ),
          _priceRow('Total', order.totalPrice!, bold: true, color: AppColors.mainColor),
        ],
      ),
    );
  }

  Widget _buildAddress() => _card(Row(
        children: [
          Icon(Icons.location_on, color: AppColors.mainColor, size: 32),
          const SizedBox(width: 16),
          Expanded(child: Text("${order.billingDetails!.address!}, ${order.billingDetails!.city}, ${order.billingDetails!.state}, ${order.billingDetails!.zipCode}, ${order.billingDetails!.country}", style: h4)),
        ],
      ));


  Widget _card(Widget child) => Container(
        width: double.infinity,
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: AppColors.grayLight),
          boxShadow: [
            BoxShadow(color: Colors.black.withValues(alpha: 0.04), blurRadius: 10, offset: const Offset(0, 4)),
          ],
        ),
        child: child,
      );

  Widget _priceRow(String label,  amount, {bool bold = false, Color? color}) =>
      Padding(
        padding: const EdgeInsets.symmetric(vertical: 6),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(label, style: h4.copyWith(color: bold ? AppColors.black : AppColors.hintColor)),
            Text(
              '\$${amount.toStringAsFixed(2)}',
              style: bold ? h2.copyWith(color: color ?? AppColors.mainColor) : h3.copyWith(fontWeight: FontWeight.w600),
            ),
          ],
        ),
      );

  void _confirmCancel(BuildContext context) {
    Get.dialog(AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      title: Text('Cancel Order?', style: h2),
      content: Text('This action cannot be undone.', style: h4),
      actions: [
        TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Keep Order', style: GoogleFonts.dmSans(color: AppColors.hintColor))),
        ElevatedButton(
          onPressed: () {
            Navigator.pop(context);
            Navigator.pop(context);
            Get.snackbar('Order Cancelled', 'Your order has been cancelled successfully',
                backgroundColor: AppColors.red.withValues(alpha: 0.1), colorText: AppColors.red);
          },
          style: ElevatedButton.styleFrom(backgroundColor: AppColors.red),
          child: Text('Yes, Cancel', style: GoogleFonts.dmSans(color: Colors.white)),
        ),
      ],
    ));
  }

  Color _statusColor() {
    switch (order.status!.toLowerCase()) {
      case 'delivered':
        return AppColors.green;
      case 'pending':
      case 'processing':
        return AppColors.orange;
      case 'cancelled':
        return AppColors.red;
      default:
        return AppColors.gray;
    }
  }

  Widget _buildSection(String title, Widget child) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: h2.copyWith(fontSize: 18)),
        const SizedBox(height: 8),
        child,
      ],
    );
  }
}
