import 'dart:convert';
import 'package:expiry_deals/app/modules/store/model/store_wise_product_model.dart';
import 'package:get/get.dart';
import 'package:expiry_deals/app/data/api.dart';
import 'package:expiry_deals/app/data/base_client.dart';
import 'package:expiry_deals/common/helper/local_store.dart';
import 'package:expiry_deals/common/app_constant/app_constant.dart';

import '../../../../common/helper/current_location.dart';

class StoreWiseProductController extends GetxController {
  var isLoading = false.obs;
  var storeWiseProduct = <StoreWiseProduct>[].obs;



  Future<void> fetchStoreWiseProduct({required String shopId}) async {
    try {
      isLoading(true);

      var token = LocalStorage.getData(key: AppConstant.token);
      if (token == null || token.isEmpty) {
        Get.snackbar('Error', 'Authentication token is missing.');
        return;
      }

      // 🔥 Get real location
      // Position position = await getCurrentLocation();
      // double latitude = position.latitude;
      // double longitude = position.longitude;

      var headers = {
        'Authorization': 'Bearer $token',
      };

      dynamic response = await BaseClient.handleResponse(
        await BaseClient.getRequest(
          api: Api.shopWiseProduct(shopId: shopId) + "?limit=100000000",
          headers: headers,
        ),
      );

      if (response != null && response['success'] == true) {
        // Map the API response to the ProductModel and assign it to the product list
        storeWiseProduct.assignAll(StoreWiseProductModel.fromJson(response).data?.data ?? []);
      } else {
        Get.snackbar('Error', 'Failed to fetch shop wise product.');
      }
    } catch (e) {
      Get.snackbar('Error', e.toString());
    } finally {
      isLoading(false);
    }
  }
}
