import 'package:expiry_deals/app/data/api.dart';
import 'package:expiry_deals/app/data/base_client.dart';
import 'package:expiry_deals/common/helper/local_store.dart';
import 'package:expiry_deals/common/app_constant/app_constant.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:expiry_deals/app/modules/my_orders/model/my_order_model.dart';

class MyOrdersController extends GetxController {
  var isLoading = true.obs;

  // All orders (main list)
  var allOrders = <MyOrder>[].obs;

  // Filtered lists for tabs
  var pendingOrders = <MyOrder>[].obs;
  var ongoingOrders = <MyOrder>[].obs;
  var deliveredOrders = <MyOrder>[].obs;
  var cancelledOrders = <MyOrder>[].obs;

  @override
  void onInit() {
    super.onInit();
    fetchOrders();
  }

  Future<void> fetchOrders() async {
    try {
      isLoading.value = true;

      String? token = LocalStorage.getData(key: AppConstant.token);
      if (token == null || token.trim().isEmpty) {
        Get.snackbar('Error', 'Authentication token is missing');
        return;
      }

      var headers = {
        'Authorization': 'Bearer $token',
        'Accept': 'application/json',
      };

      final response = await BaseClient.handleResponse(
        await BaseClient.getRequest(
          api: Api.myOrders,
          headers: headers,
        ),
      );

      if (response != null && response['success'] == true) {
        final model = MyOrderModel.fromJson(response);
        final orders = model.data?.data ?? [];

        // Sort by createdAt (newest first)
        orders.sort((a, b) {
          final dateA = a.createdAt ?? DateTime(2000);
          final dateB = b.createdAt ?? DateTime(2000);
          return dateB.compareTo(dateA);
        });

        allOrders.assignAll(orders);

        // Filter using correct backend status values
        pendingOrders.assignAll(
          orders.where((o) => o.status?.toLowerCase() == 'pending').toList(),
        );
        ongoingOrders.assignAll(
          orders.where((o) => o.status?.toLowerCase() == 'ongoing').toList(),
        );
        deliveredOrders.assignAll(
          orders.where((o) => o.status?.toLowerCase() == 'delivered').toList(),
        );
        cancelledOrders.assignAll(
          orders.where((o) => o.status?.toLowerCase() == 'cancelled').toList(),
        );
      } else {
        Get.snackbar(
          'Error',
          response?['message'] ?? 'Failed to fetch orders',
          backgroundColor: Colors.red[100],
        );
      }
    } catch (e) {
      print("Fetch orders error: $e");
      Get.snackbar(
        'Error',
        'Something went wrong: $e',
        backgroundColor: Colors.red[100],
      );
    } finally {
      isLoading.value = false;
    }
  }

  // Optional: Call this when you want to refresh (pull-to-refresh)
  Future<void> refreshOrders() async {
    await fetchOrders();
  }
}