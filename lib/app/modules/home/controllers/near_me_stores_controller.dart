import 'dart:convert';
import 'package:expiry_deals/app/modules/home/model/near_me_stores_model.dart';
import 'package:expiry_deals/common/helper/current_location.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:expiry_deals/app/data/api.dart';
import 'package:expiry_deals/app/data/base_client.dart';
import 'package:expiry_deals/common/helper/local_store.dart';
import 'package:expiry_deals/common/app_constant/app_constant.dart';

class NearMeStoresController extends GetxController {
  var isLoading = false.obs;
  var nearMeStores = <NearMeStores>[].obs;

  @override
  void onInit() {
    super.onInit();
    fetchNearMeStores();  // Fetch products when the controller is initialized
  }

  // Fetch products from the server

  Future<void> fetchNearMeStores() async {
    try {
      isLoading(true);

      var token = LocalStorage.getData(key: AppConstant.token);
      if (token == null || token.isEmpty) {
        Get.snackbar('Error', 'Authentication token is missing.');
        return;
      }

      // 🔥 Get real location
      Position position = await getCurrentLocation();
      double latitude = position.latitude;
      double longitude = position.longitude;

      var headers = {
        'Authorization': 'Bearer $token',
      };

      dynamic response = await BaseClient.handleResponse(
        await BaseClient.getRequest(
          api: Api.allShop +
              "?latitude=$latitude&longitude=$longitude&limit=90000000000",
          headers: headers,
        ),
      );

      if (response != null && response['success'] == true) {
        nearMeStores.assignAll(
          NearMeStoresModel.fromJson(response).data?.data ?? [],
        );
      } else {
        Get.snackbar('Error', 'Failed to fetch shop.');
      }
    } catch (e) {
      Get.snackbar('Error', e.toString());
    } finally {
      isLoading(false);
    }
  }

}
