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

  /// Wider fetch so server-side strips are less likely to miss deals; [mergeRecommendedStripProducts] also fills gaps from the home grid.
  static const int _stripLimit = 40;

  Worker? _productsWorker;

  @override
  void onInit() {
    super.onInit();
    final pc = Get.find<ProductController>();
    _productsWorker = ever<List<Products>>(pc.products, (_) {
      if (pc.products.isEmpty) return;
      mergeRecommendedStripProducts();
    });
    _loadStrips();
  }

  @override
  void onClose() {
    _productsWorker?.dispose();
    super.onClose();
  }

  /// Adds any matching items from the main “Recommended” product list into 70%+ and Expiring Soon strips
  /// so deals still appear if filtered API calls return empty or a different page order.
  void mergeRecommendedStripProducts() {
    if (!Get.isRegistered<ProductController>()) return;
    final source = Get.find<ProductController>().products.toList();
    if (source.isEmpty) return;

    bool idIn(List<Products> xs, String? id) =>
        id != null && id.isNotEmpty && xs.any((e) => e.id == id);

    double dOf(Products p) {
      final d = p.discount;
      if (d is num) return d.toDouble();
      return double.tryParse('$d') ?? 0;
    }

    DateTime? expOf(Products p) {
      final v = p.expiredAt;
      if (v == null) return null;
      if (v is DateTime) return v;
      if (v is String && v.isNotEmpty) return DateTime.tryParse(v);
      return null;
    }

    final now = DateTime.now();
    bool inExpiringSoonWindow(DateTime? t) {
      if (t == null) return false;
      if (!t.isAfter(now)) return false;
      return t.difference(now) <= const Duration(hours: 24);
    }

    final mega = List<Products>.from(megaOff);
    final exp = List<Products>.from(expiringSoon);

    for (final p in source) {
      final id = p.id;
      if (id == null || id.isEmpty) continue;
      if (dOf(p) >= 70 && !idIn(mega, id)) {
        mega.add(p);
      }
      if (inExpiringSoonWindow(expOf(p)) && !idIn(exp, id)) {
        exp.add(p);
      }
    }

    mega.sort((a, b) => dOf(b).compareTo(dOf(a)));
    exp.sort((a, b) {
      final ta = expOf(a);
      final tb = expOf(b);
      if (ta == null) return 1;
      if (tb == null) return -1;
      return ta.compareTo(tb);
    });

    megaOff.assignAll(mega);
    expiringSoon.assignAll(exp);
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
      mergeRecommendedStripProducts();
    }
  }

  Future<void> refreshStrips() => _loadStrips();
}
