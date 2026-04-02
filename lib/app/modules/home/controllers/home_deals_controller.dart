import 'package:expiry_deals/app/modules/home/controllers/product_controller.dart';
import 'package:expiry_deals/app/modules/home/model/product_model.dart';
import 'package:get/get.dart';

/// Discount rows on home (MVP — rule-based, no ML). Loaded after [ProductController] is registered.
class HomeDealsController extends GetxController {
  final megaOff = <Products>[].obs; // 70%+
  final hotDeals = <Products>[].obs; // 50–69%
  final valueDeals = <Products>[].obs; // 30–49%
  final bestSelling = <Products>[].obs;
  /// `expiredAt` within the next 24 hours (requires backend `expiringWithinHours`).
  final expiringSoon = <Products>[].obs;

  var isLoading = true.obs;

  static const int _stripLimit = 8;

  @override
  void onInit() {
    super.onInit();
    _loadStrips();
  }

  Future<void> _loadStrips() async {
    isLoading.value = true;
    try {
      final pc = Get.find<ProductController>();
      final results = await Future.wait([
        pc.queryProducts(
          page: 1,
          limit: _stripLimit,
          minDiscount: 70,
          sort: '-discount',
        ),
        pc.queryProducts(
          page: 1,
          limit: _stripLimit,
          minDiscount: 50,
          maxDiscount: 69.99,
          sort: '-discount',
        ),
        pc.queryProducts(
          page: 1,
          limit: _stripLimit,
          minDiscount: 30,
          maxDiscount: 49.99,
          sort: '-discount',
        ),
        pc.queryProducts(
          page: 1,
          limit: _stripLimit,
          sort: '-totalSell',
        ),
        pc.queryProducts(
          page: 1,
          limit: _stripLimit,
          expiringWithinHours: 24,
          sort: 'expiredAt',
        ),
      ]);

      megaOff.assignAll(results[0]?.list ?? []);
      hotDeals.assignAll(results[1]?.list ?? []);
      valueDeals.assignAll(results[2]?.list ?? []);
      bestSelling.assignAll(results[3]?.list ?? []);
      expiringSoon.assignAll(results[4]?.list ?? []);
    } catch (_) {
      megaOff.clear();
      hotDeals.clear();
      valueDeals.clear();
      bestSelling.clear();
      expiringSoon.clear();
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> refreshStrips() => _loadStrips();
}
