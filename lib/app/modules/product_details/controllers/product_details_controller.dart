import 'package:expiry_deals/app/modules/home/model/search_product_model.dart';
import 'package:expiry_deals/app/modules/product_details/model/single_product_model.dart';
import 'package:get/get.dart';
import 'package:expiry_deals/app/data/api.dart';
import 'package:expiry_deals/app/data/base_client.dart';
import 'package:expiry_deals/common/helper/local_store.dart';
import 'package:expiry_deals/common/app_constant/app_constant.dart';

class ProductDetailsController extends GetxController {
  var isLoading = false.obs;
  var singleProduct = SingleProductModel().obs;
  var similarLoading = false.obs;
  var similarProducts = <SearchProduct>[].obs;

  Future<void> fetchSingleProduct({required String productId}) async {
    try {
      isLoading(true);
      similarProducts.clear();

      var token = LocalStorage.getData(key: AppConstant.token);
      if (token == null || token.isEmpty) {
        Get.snackbar('Error', 'Authentication token is missing.');
        return;
      }

      var headers = {
        'Authorization': 'Bearer $token',
      };

      dynamic response = await BaseClient.handleResponse(
        await BaseClient.getRequest(
          api: Api.productById(productId: productId),
          headers: headers,
        ),
      );

      if (response != null && response['success'] == true) {
        singleProduct.value = SingleProductModel.fromJson(response);
        final catId = singleProduct.value.data?.category?.id;
        if (catId != null && catId.isNotEmpty) {
          await fetchSimilarProducts(
            categoryId: catId,
            excludeProductId: productId,
          );
        }
      } else {
        Get.snackbar('Error', 'Failed to fetch single shop.');
      }
    } catch (e) {
      Get.snackbar('Error', e.toString());
    } finally {
      isLoading(false);
    }
  }

  /// Same category, excluding the current product (backend allows up to default page size).
  Future<void> fetchSimilarProducts({
    required String categoryId,
    required String excludeProductId,
  }) async {
    try {
      similarLoading(true);
      var token = LocalStorage.getData(key: AppConstant.token);
      if (token == null || token.isEmpty) return;

      final uri =
          '${Api.allProducts}?category=${Uri.encodeQueryComponent(categoryId)}&limit=30';
      dynamic response = await BaseClient.handleResponse(
        await BaseClient.getRequest(
          api: uri,
          headers: {'Authorization': 'Bearer $token'},
        ),
      );

      if (response != null && response['success'] == true) {
        final list =
            SearchProductModel.fromJson(response).data?.data ?? [];
        similarProducts.assignAll(
          list
              .where((p) => p.id != null && p.id != excludeProductId)
              .take(10)
              .toList(),
        );
      }
    } catch (_) {
      similarProducts.clear();
    } finally {
      similarLoading(false);
    }
  }
}
