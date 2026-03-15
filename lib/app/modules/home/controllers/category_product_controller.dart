import 'dart:convert';

import 'package:get/get.dart';
import 'package:expiry_deals/app/data/api.dart';
import 'package:expiry_deals/app/data/base_client.dart';
import 'package:expiry_deals/common/helper/local_store.dart';
import 'package:expiry_deals/common/app_constant/app_constant.dart';

import '../model/category_product_model.dart';

class CategoryProductController extends GetxController {
  var isLoading = false.obs;

  var categoryProducts = <CategoryProduct>[].obs;


  // Fetch products from the server
  Future<void> fetchCategoryProducts({required String categoryId}) async {
    try {
      isLoading(true);

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
          api: Api.categoryProducts(categoryId: categoryId) + "&limit=9000000000",
          headers: headers,
        ),
      );

      if (response != null && response['success'] == true) {
        // Map the API response to the ProductModel and assign it to the product list
        categoryProducts.assignAll(CategoryProductModel.fromJson(response).data?.data ?? []);
      } else {
        Get.snackbar('Error', 'Failed to fetch products.');
      }
    } catch (e) {
      Get.snackbar('Error', e.toString());
    } finally {
      isLoading(false);
    }
  }

}
