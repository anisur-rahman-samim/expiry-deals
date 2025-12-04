import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SearchPageController extends GetxController {
  final searchController = TextEditingController();
  var searchQuery = ''.obs;
  var isLoading = false.obs;
  var searchResults = <Map<String, dynamic>>[].obs;

  @override
  void onInit() {
    super.onInit();
    searchController.addListener(() {
      searchQuery.value = searchController.text;
    });
  }

  void onSearchChanged(String query) {
    if (query.isEmpty) {
      searchResults.clear();
      return;
    }
    // Simulate search
    isLoading(true);
    Future.delayed(const Duration(milliseconds: 800), () {
      searchResults.assignAll([
        {'title': 'Leather Jacket Pro', 'price': 129.99, 'image': 'https://i.pinimg.com/736x/af/38/16/af3816f775f479ab6fb7dfaf30d3e553.jpg'},
        {'title': 'Wireless Headphones', 'price': 89.99, 'image': 'https://www.dhresource.com/webp/m/0x0/f2/albu/g21/M00/1F/F5/rBVaq2DCDRGABLbyAADQ8DkUmO8389.jpg'},
        // Add more...
      ]);
      isLoading(false);
    });
  }

  void clearSearch() {
    searchController.clear();
    searchQuery.value = '';
    searchResults.clear();
  }
}