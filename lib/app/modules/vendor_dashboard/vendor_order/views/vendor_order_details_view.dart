// vendor_order_details_view.dart

import 'package:expiry_deals/common/app_color/app_colors.dart';
import 'package:expiry_deals/common/size_box/custom_sizebox.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import '../controllers/vendor_order_controller.dart';

class VendorOrderDetailsView extends StatelessWidget {
  final Order order;

  const VendorOrderDetailsView({super.key, required this.order});

  final List<String> statuses = const [
    'Pending',
    'Processing',
    'Shipped',
    'Delivered',
    'Cancelled'
  ];

  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'delivered':
        return AppColors.green;
      case 'pending':
      case 'processing':
        return AppColors.orange;
      case 'shipped':
        return Colors.blue;
      case 'cancelled':
        return AppColors.red;
      default:
        return AppColors.gray;
    }
  }

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<VendorOrderController>();

    return Scaffold(
      backgroundColor: AppColors.bgColor,
      appBar: AppBar(
        title: const Text('Order Details'),
        centerTitle: true,
        backgroundColor: AppColors.mainColor,
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: RefreshIndicator(
        onRefresh: controller.refreshOrders,
        color: AppColors.mainColor,
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header with Status Dropdown
              _buildHeader(controller,context),
              sh20,

              // Ordered Items
              _buildSection('Items Ordered', _buildItemsList()),
              sh20,

              // Price Breakdown
              _buildSection('Price Breakdown', _buildPriceBreakdown()),
              sh20,

              // Customer Info
              _buildSection('Shipping Address', _buildAddress()),
              sh16,
              _buildSection('Payment Method', _buildPayment()),
              sh40,
            ],
          ),
        ),
      ),
    );
  }


  Widget _buildSection(String title, Widget child) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: GoogleFonts.dmSans(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: AppColors.textColor,
          ),
        ),
        sh10,
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: AppColors.white,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: AppColors.grayLight),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.04),
                blurRadius: 10,
                offset: const Offset(0, 4),
              )
            ],
          ),
          child: child,
        ),
      ],
    );
  }

  Widget _buildHeader(VendorOrderController controller, BuildContext context) {
    return Container(
      width: Get.width,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.grayLight),
        boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.05), blurRadius: 12, offset: const Offset(0, 4))],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Order #${order.id}', style: GoogleFonts.dmSans(fontSize: 19, fontWeight: FontWeight.bold)),
             sh10,
              Align(
                  alignment: Alignment.topRight,
                  child: _buildStatusDropdown(controller,context)),
            ],
          ),
          sh14,
          Text(
            'Placed on ${DateFormat('dd MMMM yyyy • hh:mm a').format(order.orderDate)}',
            style: TextStyle(color: AppColors.hintColor, fontSize: 14),
          ),
          sh10,
          Text(
            '${order.items.length} items • Total: \$${order.total.toStringAsFixed(2)}',
            style: GoogleFonts.dmSans(fontSize: 20, fontWeight: FontWeight.bold, color: AppColors.mainColor),
          ),
        ],
      ),
    );
  }

  Widget _buildStatusDropdown(VendorOrderController controller, BuildContext context) {
    return Obx(() {
      // Always get latest status from the live order in controller
      final currentStatus = controller.orders.firstWhere((o) => o.id == order.id).status.capitalizeFirst!;

      return Container(
        height: 50,
      //  width: 120,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: _getStatusColor(currentStatus).withValues(alpha: 0.12),
          borderRadius: BorderRadius.circular(30),
          border: Border.all(color: _getStatusColor(currentStatus).withValues(alpha: 0.4),),
        ),
        child: DropdownButtonHideUnderline(
          child: DropdownButton<String>(
            value: currentStatus,
            icon: Icon(Icons.keyboard_arrow_down_rounded, color: _getStatusColor(currentStatus)),
            style: GoogleFonts.dmSans(fontWeight: FontWeight.bold, fontSize: 14),
            dropdownColor: Colors.white,
            borderRadius: BorderRadius.circular(16),
            onChanged: (String? newStatus) {
              if (newStatus == null || newStatus == currentStatus) return;

              _showStatusChangeDialog(controller, newStatus, context);
            },
            items: statuses.map((status) {
              final color = _getStatusColor(status);
              return DropdownMenuItem(
                value: status,
                child: Row(
                  children: [
                    Container(width: 10, height: 10, decoration: BoxDecoration(color: color, shape: BoxShape.circle)),
                    sw10,
                    Text(status, style: TextStyle(color: color, fontWeight: FontWeight.bold)),
                  ],
                ),
              );
            }).toList(),
          ),
        ),
      );
    });
  }

  void _showStatusChangeDialog(VendorOrderController controller, String newStatus, BuildContext context) {
    Get.dialog(
      AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Text('Update Order Status', style: GoogleFonts.dmSans(fontSize: 20, fontWeight: FontWeight.bold)),
        content: Text('Change status to "$newStatus"?', style: const TextStyle(fontSize: 16)),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancel', style: GoogleFonts.dmSans(color: AppColors.hintColor)),
          ),
          ElevatedButton(
            onPressed: () async {
          Navigator.pop(context);
              await controller.updateOrderStatus(order.id, newStatus.toLowerCase());
              // Get.snackbar(
              //   'Status Updated',
              //   'Order is now $newStatus',
              //   backgroundColor: _getStatusColor(newStatus).withOpacity(0.2),
              //   colorText: _getStatusColor(newStatus),
              //   icon: Icon(Icons.check_circle, color: _getStatusColor(newStatus)),
              // );

            },
            style: ElevatedButton.styleFrom(backgroundColor: AppColors.mainColor, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))),
            child: const Text('Confirm', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );
  }

  Widget _buildItemsList() {
    return ListView.separated(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: order.items.length,
      separatorBuilder: (_, __) => const Divider(height: 32),
      itemBuilder: (_, i) {
        final item = order.items[i];
        return Row(
          children: [
          Container(
          width: 72,
          height: 72,
          decoration: BoxDecoration(
            color: AppColors.grayLight,
            borderRadius: BorderRadius.circular(12),

          ),
          child: const Icon(Icons.image_outlined, color: AppColors.gray, size: 32),
        ),
          sw14,
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(item.name, style: GoogleFonts.dmSans(fontSize: 16, fontWeight: FontWeight.w600), maxLines: 2, overflow: TextOverflow.ellipsis),
                sh5,
                Text('Quantity: ${item.quantity}', style: TextStyle(color: AppColors.hintColor)),
              ],
            ),
          ),
          Text(
            '\$${(item.price * item.quantity).toStringAsFixed(2)}',
            style: GoogleFonts.dmSans(fontSize: 17, fontWeight: FontWeight.bold),
          ),
        ]
        );
      },
    );
  }

  Widget _buildPriceBreakdown() {
    final subtotal = order.items.fold(0.0, (sum, item) => sum + (item.price * item.quantity));
    return Column(
      children: [
        _priceRow('Subtotal', subtotal),
        _priceRow('Shipping Fee', order.shippingFee),
        _priceRow('Tax', order.tax),
        const Divider(height: 32, thickness: 1),
        _priceRow('Total Amount', order.total, bold: true, color: AppColors.mainColor),
      ],
    );
  }

  Widget _buildAddress() => Row(
    children: [
      Icon(Icons.location_on_outlined, color: AppColors.mainColor, size: 32),
      sw14,
      Expanded(child: Text(order.shippingAddress, style: GoogleFonts.dmSans(fontSize: 15))),
    ],
  );

  Widget _buildPayment() => Row(
    children: [
      Icon(Icons.credit_card, color: AppColors.mainColor, size: 32),
      sw14,
      Text('Credit/Debit Card •••• 4242', style: GoogleFonts.dmSans(fontSize: 16, fontWeight: FontWeight.w600)),
    ],
  );


  Widget _priceRow(String label, double amount, {bool bold = false, Color? color}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 7),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: TextStyle(fontSize: 15, color: bold ? AppColors.textColor : AppColors.hintColor, fontWeight: bold ? FontWeight.w600 : FontWeight.normal)),
          Text(
            '\$${amount.toStringAsFixed(2)}',
            style: GoogleFonts.dmSans(
              fontSize: bold ? 20 : 16,
              fontWeight: bold ? FontWeight.bold : FontWeight.w600,
              color: color ?? AppColors.textColor,
            ),
          ),
        ],
      ),
    );
  }
}