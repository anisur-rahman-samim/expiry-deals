import 'package:expiry_deals/app/modules/vendor_dashboard/vendor_product/model/my_product_model.dart';
import 'package:get/get.dart';
import 'package:expiry_deals/app/data/api.dart';
import 'package:expiry_deals/app/data/base_client.dart';
import 'package:expiry_deals/common/helper/local_store.dart';
import 'package:expiry_deals/common/app_constant/app_constant.dart';
import 'dart:convert';


class VendorProductController extends GetxController {
  var isLoading = true.obs;
  var products = <MyProduct>[].obs;

  @override
  void onInit() {
    super.onInit();
    fetchProducts();
  }

  // Fetch products from the server
  void fetchProducts() async {
    isLoading.value = true;
    try {
      String? token = LocalStorage.getData(key: AppConstant.token);
      if (token == null || token.isEmpty) {
        throw "Authentication token is missing.";
      }

      var headers = {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      };

      dynamic response = await BaseClient.handleResponse(
        await BaseClient.getRequest(api: Api.myProduct, headers: headers),
      );

      if (response != null && response['success'] == true) {
        // Parse the response into the model
        products.assignAll(MyProductModel.fromJson(response).data?.data ?? []);
      } else {
        Get.snackbar("Error", "Failed to fetch products");
      }
    } catch (e) {
      Get.snackbar("Error", e.toString());
    } finally {
      isLoading.value = false;
    }
  }
}
