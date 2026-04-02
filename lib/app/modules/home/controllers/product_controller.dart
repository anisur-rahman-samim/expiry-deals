import 'package:expiry_deals/app/modules/home/model/product_model.dart';
import 'package:get/get.dart';
import 'package:expiry_deals/app/data/api.dart';
import 'package:expiry_deals/app/data/base_client.dart';
import 'package:expiry_deals/common/helper/local_store.dart';
import 'package:expiry_deals/common/app_constant/app_constant.dart';

class ProductController extends GetxController {
  var isLoading = false.obs;
  var products = <Products>[].obs;

  /// Main “Recommended” grid — load more (same unfiltered list as legacy first page).
  var isLoadingMore = false.obs;
  var hasMoreProducts = true.obs;
  int _page = 1;
  static const int _pageSize = 10;

  @override
  void onInit() {
    super.onInit();
    fetchProducts();
  }

  /// Shared API for home strips, deals list, and tests. Does not mutate [products].
  Future<({List<Products> list, Meta? meta})?> queryProducts({
    int page = 1,
    int limit = 10,
    double? minDiscount,
    double? maxDiscount,
    int? expiringWithinHours,
    String? sort,
  }) async {
    try {
      var token = LocalStorage.getData(key: AppConstant.token);
      if (token == null || token.isEmpty) {
        return null;
      }

      final headers = {'Authorization': 'Bearer $token'};

      final map = <String, String>{
        'page': '$page',
        'limit': '$limit',
      };
      if (minDiscount != null) {
        map['minDiscount'] = minDiscount.toString();
      }
      if (maxDiscount != null) {
        map['maxDiscount'] = maxDiscount.toString();
      }
      if (sort != null && sort.isNotEmpty) {
        map['sort'] = sort;
      }
      if (expiringWithinHours != null && expiringWithinHours > 0) {
        map['expiringWithinHours'] = '$expiringWithinHours';
      }

      final api =
          '${Api.allProducts}?${Uri(queryParameters: map).query}';

      dynamic response = await BaseClient.handleResponse(
        await BaseClient.getRequest(
          api: api,
          headers: headers,
        ),
      );

      if (response != null && response['success'] == true) {
        final model = ProductModel.fromJson(response);
        return (
          list: model.data?.data ?? [],
          meta: model.data?.meta,
        );
      }
    } catch (_) {}
    return null;
  }

  /// First page: **unchanged** default — bare [Api.allProducts] (no query string), same as before.
  /// [loadMoreRecommended] uses paginated requests.
  Future<void> fetchProducts({bool reset = true}) async {
    try {
      isLoading(true);
      if (reset) {
        _page = 1;
        hasMoreProducts.value = true;
        products.clear();
      }

      var token = LocalStorage.getData(key: AppConstant.token);
      if (token == null || token.isEmpty) {
        Get.snackbar('Error', 'Authentication token is missing.');
        return;
      }

      var headers = {
        'Authorization': 'Bearer $token',
      };

      final dynamic response;
      if (reset && _page == 1) {
        response = await BaseClient.handleResponse(
          await BaseClient.getRequest(
            api: Api.allProducts,
            headers: headers,
          ),
        );
      } else {
        final uri =
            '${Api.allProducts}?${Uri(queryParameters: {
          'page': '$_page',
          'limit': '$_pageSize',
        }).query}';
        response = await BaseClient.handleResponse(
          await BaseClient.getRequest(
            api: uri,
            headers: headers,
          ),
        );
      }

      if (response != null && response['success'] == true) {
        final model = ProductModel.fromJson(response);
        final list = model.data?.data ?? [];
        final meta = model.data?.meta;
        if (reset) {
          products.assignAll(list);
        } else {
          products.addAll(list);
        }
        hasMoreProducts.value =
            (meta?.page ?? 1) < (meta?.totalPage ?? 1);
      } else {
        Get.snackbar('Error', 'Failed to fetch products.');
      }
    } catch (e) {
      Get.snackbar('Error', e.toString());
    } finally {
      isLoading(false);
    }
  }

  /// Infinite scroll for the main recommended grid (page 2+).
  Future<void> loadMoreRecommended() async {
    if (!hasMoreProducts.value ||
        isLoadingMore.value ||
        isLoading.value) {
      return;
    }
    try {
      isLoadingMore(true);
      _page++;
      final r = await queryProducts(
        page: _page,
        limit: _pageSize,
      );
      if (r != null) {
        products.addAll(r.list);
        hasMoreProducts.value =
            (r.meta?.page ?? 1) < (r.meta?.totalPage ?? 1);
      }
    } finally {
      isLoadingMore(false);
    }
  }
}
