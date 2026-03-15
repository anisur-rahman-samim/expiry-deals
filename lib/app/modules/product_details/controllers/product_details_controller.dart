import 'package:expiry_deals/app/modules/product_details/model/single_product_model.dart';
import 'package:get/get.dart';
import 'package:expiry_deals/app/data/api.dart';
import 'package:expiry_deals/app/data/base_client.dart';
import 'package:expiry_deals/common/helper/local_store.dart';
import 'package:expiry_deals/common/app_constant/app_constant.dart';

class ProductDetailsController extends GetxController {
  var isLoading = false.obs;
  var singleProduct = SingleProductModel().obs;


  Future<void> fetchSingleProduct({required String productId}) async {
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
          api: Api.productById(productId: productId),
          headers: headers,
        ),
      );

      if (response != null && response['success'] == true) {
        singleProduct.value = SingleProductModel.fromJson(response);
      } else {
        Get.snackbar('Error', 'Failed to fetch single shop.');
      }
    } catch (e) {
      Get.snackbar('Error', e.toString());
    } finally {
      isLoading(false);
    }
  }
}
