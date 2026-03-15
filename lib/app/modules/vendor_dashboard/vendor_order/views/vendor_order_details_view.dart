import 'package:expiry_deals/app/modules/vendor_dashboard/vendor_order/model/my_vendor_order_model.dart';
import 'package:flutter/material.dart' as material;
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import '../controllers/vendor_order_controller.dart';
import 'package:expiry_deals/common/app_color/app_colors.dart';     // adjust path if needed
import 'package:expiry_deals/common/size_box/custom_sizebox.dart'; // adjust path if needed

class VendorOrderDetailsView extends StatelessWidget {
  final MyVendorOrder order;

  const VendorOrderDetailsView({super.key, required this.order});

  // These must match backend accepted values (display names)
  final List<String> allowedStatuses = const [
    'Pending',
    'Ongoing',
    'Delivered',
    'Cancelled',
  ];

  Color _getStatusColor(String? status) {
    switch (status?.toLowerCase()) {
      case 'delivered':
        return AppColors.green;
      case 'ongoing':
        return Colors.blue;
      case 'pending':
        return AppColors.orange;
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
              // Header
              _buildHeader(controller),
              sh20,

              // Ordered Items
              _buildSection('Items Ordered', _buildItemsList()),
              sh20,

              // Price Breakdown
              _buildSection('Price Breakdown', _buildPriceBreakdown()),
              sh20,

              // Billing Address
              _buildSection('Billing Address', _buildBillingAddress()),
              sh16,

              // Payment Info
              _buildSection('Payment Information', _buildPaymentInfo()),
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
                color: Colors.black.withOpacity(0.04),
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

  Widget _buildHeader(VendorOrderController controller) {
    // Use latest data from controller
    final latestOrder = controller.orders.firstWhere(
          (o) => o.id == order.id,
      orElse: () => order,
    );

    final date = controller.formatDate(latestOrder.createdAt);
    final status = latestOrder.status ?? 'Unknown';

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.grayLight),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 12,
            offset: const Offset(0, 4),
          )
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Text(
                  'Order #${latestOrder.datumId ?? latestOrder.id?.substring(latestOrder.id!.length - 8) ?? '—'}',
                  style: GoogleFonts.dmSans(fontSize: 19, fontWeight: FontWeight.bold),
                ),
              ),
              _buildStatusDropdown(controller),
            ],
          ),
          sh14,
          Text(
            'Placed on $date',
            style: TextStyle(color: AppColors.hintColor, fontSize: 14),
          ),
          sh10,
          Text(
            '${latestOrder.items.length} item${latestOrder.items.length == 1 ? '' : 's'} • Total: \$${latestOrder.totalPrice?.toStringAsFixed(2) ?? '0.00'}',
            style: GoogleFonts.dmSans(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: AppColors.mainColor,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatusDropdown(VendorOrderController controller) {
    // Always get the latest version of this order from the observable list
    final latestOrder = controller.orders.firstWhere(
          (o) => o.id == order.id,
      orElse: () => order,
    );

    final currentStatus = (latestOrder.status ?? 'Unknown').capitalizeFirst!;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: _getStatusColor(latestOrder.status).withOpacity(0.12),
        borderRadius: BorderRadius.circular(30),
        border: Border.all(
          color: _getStatusColor(latestOrder.status).withOpacity(0.4),
        ),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: currentStatus,
          icon: Icon(
            Icons.keyboard_arrow_down_rounded,
            color: _getStatusColor(latestOrder.status),
          ),
          style: GoogleFonts.dmSans(
            fontWeight: FontWeight.bold,
            fontSize: 14,
            color: _getStatusColor(latestOrder.status),
          ),
          dropdownColor: Colors.white,
          borderRadius: BorderRadius.circular(16),
          onChanged: (String? newStatus) {
            if (newStatus == null || newStatus == currentStatus) return;
            _showStatusChangeDialog(controller, newStatus);
          },
          items: allowedStatuses.map((status) {
            final color = _getStatusColor(status);
            return DropdownMenuItem(
              value: status,
              child: Row(
                children: [
                  Container(
                    width: 10,
                    height: 10,
                    decoration: BoxDecoration(color: color, shape: BoxShape.circle),
                  ),
                  sw10,
                  Text(
                    status,
                    style: TextStyle(color: color, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            );
          }).toList(),
        ),
      ),
    );
  }

  void _showStatusChangeDialog(VendorOrderController controller, String newStatus) {
    Get.dialog(
      AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Text(
          'Update Order Status',
          style: GoogleFonts.dmSans(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        content: Text(
          'Change status to "$newStatus"?',
          style: const TextStyle(fontSize: 16),
        ),
        actions: [
          TextButton(
            onPressed: Get.back,
            child: Text('Cancel', style: GoogleFonts.dmSans(color: AppColors.hintColor)),
          ),
          ElevatedButton(
            onPressed: () async {
              Get.back();
              await controller.updateOrderStatus(order.id ?? '', newStatus.toLowerCase());
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.mainColor,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            ),
            child: const Text('Confirm', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  Widget _buildItemsList() {
    if (order.items.isEmpty) {
      return const Padding(
        padding: EdgeInsets.symmetric(vertical: 20),
        child: Text('No items found', style: TextStyle(color: Colors.grey)),
      );
    }

    return ListView.separated(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: order.items.length,
      separatorBuilder: (_, __) => const Divider(height: 32),
      itemBuilder: (context, index) {
        final item = order.items[index];
        final product = item.product;
        final totalItemPrice = (item.price ?? 0) * (item.quantity ?? 1);

        return Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                color: AppColors.grayLight,
                borderRadius: BorderRadius.circular(12),
              ),
              child: product?.images.isNotEmpty == true
                  ? material.Image.network(
                product!.images.first.url ?? '',
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) => const Icon(Icons.image_not_supported),
              )
                  : const Icon(Icons.image_outlined, color: AppColors.gray, size: 36),
            ),
            sw14,
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    product?.name ?? 'Unknown Product',
                    style: GoogleFonts.dmSans(fontSize: 16, fontWeight: FontWeight.w600),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  sh5,
                  Text(
                    'Qty: ${item.quantity ?? 1}  •  ${item.discount != null && item.discount! > 0 ? 'Discount: ${item.discount}%' : ''}',
                    style: TextStyle(color: AppColors.hintColor, fontSize: 14),
                  ),
                ],
              ),
            ),
            Text(
              '\$${totalItemPrice.toStringAsFixed(2)}',
              style: GoogleFonts.dmSans(fontSize: 17, fontWeight: FontWeight.bold),
            ),
          ],
        );
      },
    );
  }

  Widget _buildPriceBreakdown() {
    final subtotal = order.totalPrice ?? 0;

    return Column(
      children: [
        _priceRow('Subtotal', subtotal),
        const Divider(height: 32, thickness: 1),
        _priceRow('Total Amount', subtotal, bold: true, color: AppColors.mainColor),
      ],
    );
  }

  Widget _buildBillingAddress() {
    final billing = order.billingDetails;
    if (billing == null) {
      return const Text('No billing address available', style: TextStyle(color: Colors.grey));
    }

    final address = [
      billing.address ?? '',
      billing.city ?? '',
      billing.state ?? '',
      billing.zipCode ?? '',
      billing.country ?? '',
    ].where((e) => e.isNotEmpty).join(', ');

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(Icons.location_on_outlined, color: AppColors.mainColor, size: 32),
        sw14,
        Expanded(
          child: Text(
            address.isNotEmpty ? address : 'No address provided',
            style: GoogleFonts.dmSans(fontSize: 15),
          ),
        ),
      ],
    );
  }

  Widget _buildPaymentInfo() {
    return Row(
      children: [
        Icon(Icons.payment_rounded, color: AppColors.mainColor, size: 32),
        sw14,
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              order.isPaid == true ? 'Paid' : 'Not Paid',
              style: GoogleFonts.dmSans(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: order.isPaid == true ? AppColors.green : AppColors.red,
              ),
            ),
            sh5,
            Text(
              'Transaction ID: ${order.tnxId ?? '—'}',
              style: TextStyle(color: AppColors.hintColor, fontSize: 14),
            ),
          ],
        ),
      ],
    );
  }

  Widget _priceRow(String label, double amount, {bool bold = false, Color? color}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 7),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: 15,
              color: bold ? AppColors.textColor : AppColors.hintColor,
              fontWeight: bold ? FontWeight.w600 : FontWeight.normal,
            ),
          ),
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