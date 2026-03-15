import 'dart:convert';
import 'package:get/get.dart';
import 'package:expiry_deals/app/data/api.dart';
import 'package:expiry_deals/app/data/base_client.dart';
import 'package:expiry_deals/app/modules/terms_conditions/controllers/terms_conditions_controller.dart';

import '../model/contents_model.dart';

class ContentsController extends GetxController {
  var isLoading = false.obs;
  var contentData = Rxn<Data>();  // To hold the fetched content data

  @override
  void onInit() {
    super.onInit();
    fetchContent();
  }

  // Fetch content data from the server
  Future<void> fetchContent() async {
    try {
      isLoading(true);

      dynamic response = await BaseClient.handleResponse(
        await BaseClient.getRequest(api: Api.contents),
      );

      if (response != null && response['success'] == true) {
        contentData.value = ContentModel.fromJson(response).data;
      } else {
        Get.snackbar("Error", "Failed to fetch content.");
      }
    } catch (e) {
      Get.snackbar("Error", e.toString());
    } finally {
      isLoading(false);
    }
  }
}
