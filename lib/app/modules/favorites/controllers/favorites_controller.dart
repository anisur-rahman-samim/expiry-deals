import 'package:expiry_deals/app/data/api.dart';
import 'package:expiry_deals/app/data/base_client.dart';
import 'package:expiry_deals/app/modules/home/model/product_model.dart';
import 'package:expiry_deals/common/app_constant/app_constant.dart';
import 'package:expiry_deals/common/favorites/favorites_service.dart';
import 'package:expiry_deals/common/helper/local_store.dart';
import 'package:get/get.dart';

/// Registered in [main] as permanent so hearts stay in sync app-wide.
class FavoritesController extends GetxController {
  final ids = <String>[].obs;
  final products = <Products>[].obs;
  var isLoadingList = false.obs;

  @override
  void onInit() {
    super.onInit();
    ids.assignAll(FavoritesService.loadIds());
  }

  void reloadIds() {
    ids.assignAll(FavoritesService.loadIds());
  }

  Future<void> toggle(String productId) async {
    if (productId.isEmpty) return;
    await FavoritesService.toggle(productId);
    reloadIds();
  }

  bool isFavorite(String productId) =>
      productId.isNotEmpty && ids.contains(productId);

  /// Fetch full product rows for saved ids (parallel, capped).
  Future<void> refreshProducts() async {
    final list = List<String>.from(ids);
    if (list.isEmpty) {
      products.clear();
      return;
    }
    isLoadingList.value = true;
    try {
      var token = LocalStorage.getData(key: AppConstant.token);
      if (token == null || token.isEmpty) {
        products.clear();
        return;
      }
      final headers = {'Authorization': 'Bearer $token'};
      const cap = 40;
      final take = list.length > cap ? list.sublist(0, cap) : list;

      final futures = take.map((id) async {
        try {
          dynamic response = await BaseClient.handleResponse(
            await BaseClient.getRequest(
              api: Api.productById(productId: id),
              headers: headers,
            ),
          );
          if (response != null &&
              response['success'] == true &&
              response['data'] != null) {
            final raw = response['data'];
            if (raw is Map<String, dynamic>) {
              return Products.fromJson(raw);
            }
            if (raw is Map) {
              return Products.fromJson(Map<String, dynamic>.from(raw));
            }
          }
        } catch (_) {}
        return null;
      });

      final out = await Future.wait(futures);
      products.assignAll(out.whereType<Products>());
    } finally {
      isLoadingList.value = false;
    }
  }
}
