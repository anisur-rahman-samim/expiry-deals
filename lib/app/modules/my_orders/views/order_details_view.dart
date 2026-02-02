import 'package:expiry_deals/app/modules/my_orders/model/my_order_model.dart' as myOrder;
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:geolocator/geolocator.dart';

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
            const SizedBox(height: 24),

            // ── Find Route Button ──
            if (_hasShopLocation())
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: () => _openRouteToShop(context),
                  icon: const Icon(Icons.directions_car),
                  label: const Text('Find Route to Shop'),
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    backgroundColor: AppColors.mainColor,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    elevation: 2,
                  ),
                ),
              ),

            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }

  // ────────────────────────────────────────────────
  //  Helper: Check if we have valid shop location data
  // ────────────────────────────────────────────────
  bool _hasShopLocation() {
    if (order.items.isEmpty) return false;
    final firstItem = order.items.first;
    final shop = firstItem.product?.author?.shop;
    final coords = shop?.location?.coordinates;
    return coords != null && coords.length == 2;
  }

  // Get shop coordinates [lng, lat] from first item (assuming single seller)
  List<double>? _getShopCoordinates() {
    if (order.items.isEmpty) return null;
    final coords = order.items.first.product?.author?.shop?.location?.coordinates;
    if (coords != null && coords.length == 2) {
      return coords;
    }
    return null;
  }

  // ────────────────────────────────────────────────
  //  Open Google Maps directions from current location
  // ────────────────────────────────────────────────
  Future<void> _openRouteToShop(BuildContext context) async {
    final shopCoords = _getShopCoordinates();
    if (shopCoords == null) {
      Get.snackbar('Error', 'Shop location not available');
      return;
    }

    final double shopLat = shopCoords[1]; // latitude
    final double shopLng = shopCoords[0]; // longitude

    // 1. Check location services
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      Get.snackbar(
        'Location Disabled',
        'Please enable location services to find the route.',
        duration: const Duration(seconds: 4),
      );
      return;
    }

    // 2. Check & request permission
    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        Get.snackbar('Permission Denied', 'Location permission is required');
        return;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      Get.snackbar(
        'Permission Denied Forever',
        'Please enable location permission in app settings.',
      );
      return;
    }

    // 3. Get current position
    Position? position;
    try {
      position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.medium,
      );
    } catch (e) {
      Get.snackbar('Error', 'Failed to get your current location');
      return;
    }

    final double userLat = position.latitude;
    final double userLng = position.longitude;

    // 4. Build Google Maps URL
    final String origin = '$userLat,$userLng';
    final String destination = '$shopLat,$shopLng';

    // Universal web URL (works everywhere)
    final Uri googleMapsUrl = Uri.parse(
      'https://www.google.com/maps/dir/?api=1&origin=$origin&destination=$destination&travelmode=driving',
    );

    // Try native Google Maps app first (Android + iOS)
    if (await canLaunchUrl(Uri(scheme: 'comgooglemaps'))) {
      final Uri nativeUrl = Uri.parse(
        'comgooglemaps://?saddr=$origin&daddr=$destination&directionsmode=driving',
      );
      try {
        if (await launchUrl(nativeUrl, mode: LaunchMode.externalApplication)) {
          return;
        }
      } catch (_) {
        // fallback to web
      }
    }

    // Fallback: open in browser / installed maps app
    if (await canLaunchUrl(googleMapsUrl)) {
      await launchUrl(
        googleMapsUrl,
        mode: LaunchMode.externalApplication,
      );
    } else {
      Get.snackbar('Error', 'Could not open Google Maps');
    }
  }

  // ────────────────────────────────────────────────
  //  Existing UI Builders (updated/fixed where needed)
  // ────────────────────────────────────────────────
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
                decoration: BoxDecoration(
                  color: color.withOpacity(0.08),
                  borderRadius: BorderRadius.circular(20),
                ),
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

  Widget _buildItems() => _card(
    ListView.separated(
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
              child: ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Image.network(
                  item.product?.images.isNotEmpty == true
                      ? item.product!.images[0].url ?? ''
                      : '',
                  fit: BoxFit.cover,
                  errorBuilder: (_, __, ___) => const Icon(Icons.image_not_supported),
                ),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    item.product?.name ?? "Unknown Product",
                    style: h3,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  Text(
                    'Qty: ${item.quantity}',
                    style: h5.copyWith(color: AppColors.hintColor),
                  ),
                ],
              ),
            ),
            Text(
              '\$${(item.price! * item.quantity!).toStringAsFixed(2)}',
              style: h3.copyWith(fontWeight: FontWeight.w600),
            ),
          ],
        );
      },
    ),
  );

  Widget _buildPrice() {
    return _card(
      Column(
        children: [
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

  Widget _buildAddress() => _card(
    Row(
      children: [
        Icon(Icons.location_on, color: AppColors.mainColor, size: 32),
        const SizedBox(width: 16),
        Expanded(
          child: Text(
            order.billingDetails != null
                ? "${order.billingDetails!.address ?? ''}, "
                "${order.billingDetails!.city ?? ''}, "
                "${order.billingDetails!.state ?? ''} "
                "${order.billingDetails!.zipCode ?? ''}, "
                "${order.billingDetails!.country ?? ''}"
                : "No address available",
            style: h4,
          ),
        ),
      ],
    ),
  );

  Widget _card(Widget child) => Container(
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
        ),
      ],
    ),
    child: child,
  );

  Widget _priceRow(String label, dynamic amount, {bool bold = false, Color? color}) => Padding(
    padding: const EdgeInsets.symmetric(vertical: 6),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: h4.copyWith(color: bold ? AppColors.black : AppColors.hintColor),
        ),
        Text(
          '\$${double.tryParse(amount.toString())?.toStringAsFixed(2) ?? '0.00'}',
          style: bold
              ? h2.copyWith(color: color ?? AppColors.mainColor)
              : h3.copyWith(fontWeight: FontWeight.w600),
        ),
      ],
    ),
  );

  Color _statusColor() {
    switch (order.status?.toLowerCase() ?? '') {
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