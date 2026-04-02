import 'package:expiry_deals/app/data/api.dart';
import 'package:expiry_deals/app/data/base_client.dart';
import 'package:expiry_deals/app/modules/home/controllers/near_me_stores_controller.dart';
import 'package:expiry_deals/app/modules/home/model/near_me_stores_model.dart';
import 'package:expiry_deals/app/modules/store/model/store_wise_product_model.dart';
import 'package:expiry_deals/common/app_constant/app_constant.dart';
import 'package:expiry_deals/common/helper/local_store.dart';
import 'package:get/get.dart';

/// Loads all shops (browse) and per-author products for the Browse tab.
class BrowseController extends GetxController {
  static const int _parallelProductFetches = 5;

  late final NearMeStoresController _nearMe;

  /// authorId -> products (shop-wise API uses author id).
  final productsByAuthorId = <String, List<StoreWiseProduct>>{}.obs;

  /// authorIds currently fetching products.
  final loadingAuthorIds = <String>{}.obs;

  @override
  void onInit() {
    super.onInit();
    _nearMe = Get.isRegistered<NearMeStoresController>()
        ? Get.find<NearMeStoresController>()
        : Get.put(NearMeStoresController());
    _bootstrap();
  }

  Future<void> _bootstrap() async {
    await _nearMe.fetchBrowseAllStores();
    await _loadProductsForStores(_nearMe.browseAllStores);
  }

  Future<void> refreshAll() async {
    productsByAuthorId.clear();
    productsByAuthorId.refresh();
    await _nearMe.fetchBrowseAllStores();
    await _loadProductsForStores(_nearMe.browseAllStores);
  }

  Future<void> _loadProductsForStores(List<NearMeStores> stores) async {
    final ids = stores
        .map((s) => s.author?.id)
        .whereType<String>()
        .where((id) => id.isNotEmpty)
        .toSet()
        .toList();

    for (var i = 0; i < ids.length; i += _parallelProductFetches) {
      final chunk = ids.skip(i).take(_parallelProductFetches).toList();
      await Future.wait(chunk.map(_fetchProductsForAuthor));
    }
  }

  Future<void> _fetchProductsForAuthor(String authorId) async {
    if (productsByAuthorId.containsKey(authorId)) return;

    loadingAuthorIds.add(authorId);
    loadingAuthorIds.refresh();

    try {
      final token = LocalStorage.getData(key: AppConstant.token);
      if (token == null || token.isEmpty) {
        return;
      }

      final headers = {'Authorization': 'Bearer $token'};
      final response = await BaseClient.handleResponse(
        await BaseClient.getRequest(
          api: '${Api.shopWiseProduct(shopId: authorId)}?limit=100',
          headers: headers,
        ),
      );

      if (response != null && response['success'] == true) {
        final list =
            StoreWiseProductModel.fromJson(response).data?.data ?? [];
        productsByAuthorId[authorId] = list;
        productsByAuthorId.refresh();
      }
    } catch (_) {
      // keep section empty; user can pull to refresh
    } finally {
      loadingAuthorIds.remove(authorId);
      loadingAuthorIds.refresh();
    }
  }
}
