import 'package:expiry_deals/app/modules/home/controllers/product_controller.dart';
import 'package:expiry_deals/app/modules/home/model/product_model.dart';
import 'package:get/get.dart';

/// Paginated “See all” for a discount / sort filter.
class DealsListController extends GetxController {
  DealsListController({
    this.minDiscount,
    this.maxDiscount,
    this.expiringWithinHours,
    this.sort,
  });

  final double? minDiscount;
  final double? maxDiscount;
  final int? expiringWithinHours;
  final String? sort;

  final products = <Products>[].obs;
  var isLoading = true.obs;
  var isLoadingMore = false.obs;
  var hasMore = true.obs;

  int _page = 1;
  static const int _pageSize = 20;

  @override
  void onInit() {
    super.onInit();
    loadFirst();
  }

  Future<void> loadFirst() async {
    isLoading.value = true;
    _page = 1;
    products.clear();
    hasMore.value = true;
    try {
      final pc = Get.find<ProductController>();
      final r = await pc.queryProducts(
        page: _page,
        limit: _pageSize,
        minDiscount: minDiscount,
        maxDiscount: maxDiscount,
        expiringWithinHours: expiringWithinHours,
        sort: sort,
      );
      if (r != null) {
        products.assignAll(r.list);
        hasMore.value =
            (r.meta?.page ?? 1) < (r.meta?.totalPage ?? 1);
      }
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> loadMore() async {
    if (!hasMore.value || isLoadingMore.value || isLoading.value) return;
    isLoadingMore.value = true;
    try {
      final pc = Get.find<ProductController>();
      _page++;
      final r = await pc.queryProducts(
        page: _page,
        limit: _pageSize,
        minDiscount: minDiscount,
        maxDiscount: maxDiscount,
        expiringWithinHours: expiringWithinHours,
        sort: sort,
      );
      if (r != null) {
        products.addAll(r.list);
        hasMore.value =
            (r.meta?.page ?? 1) < (r.meta?.totalPage ?? 1);
      }
    } finally {
      isLoadingMore.value = false;
    }
  }
}
