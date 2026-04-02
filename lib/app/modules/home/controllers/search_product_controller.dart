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
  /// When the exact search returns nothing, we show these broader matches (by keyword or popular list).
  var similarProducts = <SearchProduct>[].obs;
  var showingSimilarFallback = false.obs;

  final TextEditingController searchController = TextEditingController();

  @override
  void onInit() {
    super.onInit();
    // Fetch all products initially when the page loads (empty search)
    fetchSearchProducts(search: "");
  }

  String _productsQuery({required String searchTerm, int limit = 100}) {
    final map = <String, String>{'limit': '$limit'};
    if (searchTerm.isNotEmpty) {
      map['searchTerm'] = searchTerm;
    }
    final qs = Uri(queryParameters: map).query;
    return qs.isEmpty ? Api.allProducts : '${Api.allProducts}?$qs';
  }

  Future<void> _fetchSimilarSuggestions(String originalQuery) async {
    similarProducts.clear();
    showingSimilarFallback(false);

    var token = LocalStorage.getData(key: AppConstant.token);
    if (token == null || token.isEmpty) return;

    final headers = {'Authorization': 'Bearer $token'};

    Future<List<SearchProduct>> getList(String searchTerm) async {
      final response = await BaseClient.handleResponse(
        await BaseClient.getRequest(
          api: _productsQuery(searchTerm: searchTerm, limit: 24),
          headers: headers,
        ),
      );
      if (response != null && response['success'] == true) {
        return SearchProductModel.fromJson(response).data?.data ?? [];
      }
      return [];
    }

    final tokens = originalQuery
        .trim()
        .split(RegExp(r'\s+'))
        .where((t) => t.length >= 2)
        .toList()
      ..sort((a, b) => b.length.compareTo(a.length));

    for (final tok in tokens) {
      final list = await getList(tok);
      if (list.isNotEmpty) {
        similarProducts.assignAll(list);
        showingSimilarFallback(true);
        return;
      }
    }

    final broad = await getList('');
    if (broad.isNotEmpty) {
      similarProducts.assignAll(broad);
      showingSimilarFallback(true);
    }
  }

  // Fetch products from the server with search query (empty query for all products)
  Future<void> fetchSearchProducts({required String search}) async {
    try {
      isLoading(true);
      similarProducts.clear();
      showingSimilarFallback(false);

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
          api: _productsQuery(searchTerm: search, limit: 100),
          headers: headers,
        ),
      );

      if (response != null && response['success'] == true) {
        final list =
            SearchProductModel.fromJson(response).data?.data ?? [];
        searchProducts.assignAll(list);
        if (search.trim().isNotEmpty && list.isEmpty) {
          await _fetchSimilarSuggestions(search);
        }
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
    similarProducts.clear();
    showingSimilarFallback(false);
    fetchSearchProducts(search: "");  // Fetch all products
  }
}
