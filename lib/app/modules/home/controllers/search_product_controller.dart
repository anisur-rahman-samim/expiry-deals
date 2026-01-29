import 'dart:convert';
import 'package:expiry_deals/app/modules/home/model/search_product_model.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:expiry_deals/app/data/api.dart';
import 'package:expiry_deals/app/data/base_client.dart';
import 'package:expiry_deals/common/helper/local_store.dart';
import 'package:expiry_deals/common/app_constant/app_constant.dart';

class SearchProductController extends GetxController {
  var isLoading = false.obs;
  var searchQuery = "".obs; // Stores the current search query
  var searchProducts = <SearchProduct>[].obs;

  final TextEditingController searchController = TextEditingController();

  @override
  void onInit() {
    super.onInit();
    // Fetch all products initially when the page loads (empty search)
    fetchSearchProducts(search: "");
  }

  // Fetch products from the server with search query (empty query for all products)
  Future<void> fetchSearchProducts({required String search}) async {
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
          api: Api.allProducts + "?searchTerm=$search",  // Fetch products based on search term
          headers: headers,
        ),
      );

      if (response != null && response['success'] == true) {
        // Map the API response to the ProductModel and assign it to the product list
        searchProducts.assignAll(SearchProductModel.fromJson(response).data?.data ?? []);
      } else {
        Get.snackbar('Error', 'Failed to fetch products.');
      }
    } catch (e) {
      Get.snackbar('Error', e.toString());
    } finally {
      isLoading(false);
    }
  }

  // Called when user changes the search query
  void onSearchChanged(String query) {
    searchQuery.value = query; // Update search query
    fetchSearchProducts(search: query); // Fetch products based on updated search query
  }

  // Clears the search input and fetches all products
  void clearSearch() {
    searchController.clear();
    searchQuery.value = "";  // Reset search query to empty
    fetchSearchProducts(search: "");  // Fetch all products
  }
}
