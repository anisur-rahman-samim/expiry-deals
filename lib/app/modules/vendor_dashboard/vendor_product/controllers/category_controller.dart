import 'package:expiry_deals/app/data/api.dart';
import 'package:expiry_deals/app/data/base_client.dart';
import 'package:expiry_deals/app/modules/vendor_dashboard/vendor_product/model/category_model.dart';
import 'package:expiry_deals/common/app_constant/app_constant.dart';
import 'package:expiry_deals/common/helper/local_store.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CategoryDataController extends GetxController {
  final isLoading = false.obs;
  final categories = <Category>[].obs;

  @override
  void onInit() {
    super.onInit();
    fetchCategories();
  }

  Future<void> fetchCategories() async {
    try {
      isLoading(true);

      final String? token = LocalStorage.getData(key: AppConstant.token);
      if (token == null || token.isEmpty) {
        throw "Authentication token is missing.";
      }

      final headers = {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      };

      final response = await BaseClient.handleResponse(
        await BaseClient.getRequest(api: Api.categories, headers: headers),
      );

      final model = CategoryModel.fromJson(response);

      if (model.success == true) {
        categories.assignAll(model.data?.data ?? []);
        debugPrint("✅ Categories loaded: ${categories.length}");
      } else {
        categories.clear();
        Get.snackbar("Error", model.message ?? "Failed to fetch categories");
      }
    } catch (e) {
      categories.clear();
      Get.snackbar("Error", e.toString());
      debugPrint("❌ Category Error: $e");
    } finally {
      isLoading(false);
    }
  }
}
