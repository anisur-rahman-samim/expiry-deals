import 'dart:convert';

import 'package:get/get.dart';
import 'package:expiry_deals/app/data/api.dart';
import 'package:expiry_deals/app/data/base_client.dart';
import 'package:expiry_deals/common/helper/local_store.dart';
import 'package:expiry_deals/common/app_constant/app_constant.dart';

import '../model/notification_model.dart';


class NotificationsController extends GetxController {
  var isLoading = false.obs;

  var notificationList = <NotificationList>[].obs;

  @override
  void onInit() {
    super.onInit();
    fetchNotifications();
  }


  // Fetch products from the server
  Future<void> fetchNotifications() async {
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
          api: Api.notifications + "?limit=9000000000",
          headers: headers,
        ),
      );

      if (response != null && response['success'] == true) {
        // Map the API response to the ProductModel and assign it to the product list
        notificationList.assignAll(NotificationModel.fromJson(response).data ?? []);
      } else {
        Get.snackbar('Error', 'Failed to fetch notification.');
      }
    } catch (e) {
      Get.snackbar('Error', e.toString());
    } finally {
      isLoading(false);
    }
  }

}
