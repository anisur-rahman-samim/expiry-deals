import 'dart:convert';

import 'package:expiry_deals/app/data/api.dart';
import 'package:expiry_deals/common/app_constant/app_constant.dart';
import 'package:expiry_deals/common/helper/local_store.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

import '../model/my_vendor_order_model.dart';

class VendorOrderController extends GetxController {
  var isLoading = true.obs;
  var orders = <MyVendorOrder>[].obs;
  var errorMessage = ''.obs;

  @override
  void onInit() {
    super.onInit();
    fetchOrders();
  }

  /// [userId] in storage is set on login; older sessions only had it after opening Profile.
  Future<String?> _resolveAuthorId() async {
    String? userId = LocalStorage.getData(key: AppConstant.userId);
    if (userId != null && userId.isNotEmpty) return userId;

    final token = LocalStorage.getData(key: AppConstant.token);
    if (token == null || token.isEmpty) return null;

    try {
      final response = await http.get(
        Uri.parse(Api.profile),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );
      if (response.statusCode != 200) return null;
      final decoded = jsonDecode(response.body) as Map<String, dynamic>?;
      if (decoded?['success'] != true || decoded?['data'] == null) return null;
      final data = decoded!['data'] as Map<String, dynamic>?;
      final id = data?['_id'] ?? data?['id'];
      if (id == null) return null;
      final sid = id.toString();
      await LocalStorage.saveData(key: AppConstant.userId, data: sid);
      return sid;
    } catch (_) {
      return null;
    }
  }

  /// Fetch all vendor orders
  Future<void> fetchOrders() async {
    try {
      isLoading.value = true;
      errorMessage.value = '';

      String? token = LocalStorage.getData(key: AppConstant.token);
      if (token == null || token.isEmpty) {
        errorMessage.value = "Authentication token is missing.";
        return;
      }

      final userId = await _resolveAuthorId();
      if (userId == null || userId.isEmpty) {
        errorMessage.value = "User ID is missing.";
        return;
      }

      var headers = {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      };

      final response = await http.get(
        Uri.parse(Api.vendorOrder(authorId: userId)),
        headers: headers,
      );

      if (response.statusCode == 200) {
        final model = MyVendorOrderModel.fromJson(jsonDecode(response.body));

        if (model.success == true && model.data != null) {
          orders.assignAll(model.data!.data);
        } else {
          errorMessage.value = model.message ?? "Failed to load orders";
        }
      } else {
        errorMessage.value = "Server error: ${response.statusCode}";
      }
    } catch (e) {
      errorMessage.value = "Something went wrong: $e";
    } finally {
      isLoading.value = false;
    }
  }

  /// Pull-to-refresh support
  Future<void> refreshOrders() async {
    await fetchOrders();
  }

  /// Update order status (PATCH request)
  Future<bool> updateOrderStatus(String orderId, String newStatus) async {
    try {
      String? token = LocalStorage.getData(key: AppConstant.token);
      if (token == null || token.isEmpty) {
        Get.snackbar('Error', 'Authentication token is missing');
        return false;
      }

      if (orderId.isEmpty) {
        Get.snackbar('Error', 'Order ID is missing');
        return false;
      }

      var headers = {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      };

      // Normalize status to match backend expected values
      String backendStatus = newStatus.toLowerCase();
      // You can add mapping if frontend uses different casing/names
      // Example: if (newStatus == 'Delivered') backendStatus = 'delivered';



      final body = jsonEncode({
        "status": backendStatus,
      });

      final response = await http.patch(
        Uri.parse(Api.updateOrderStatus(orderId: orderId)),
        headers: headers,
        body: body,
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        print(response.statusCode);
        Get.back();
        // Update local list
        final index = orders.indexWhere((o) => o.id == orderId);
        if (index != -1) {
          final updatedOrder = orders[index];
          // Create updated copy (immutable way)
          orders[index] = MyVendorOrder(
            billingDetails: updatedOrder.billingDetails,
            id: updatedOrder.id,
            user: updatedOrder.user,
            author: updatedOrder.author,
            items: updatedOrder.items,
            totalPrice: updatedOrder.totalPrice,
            status: backendStatus, // update status
            isPaid: updatedOrder.isPaid,
            isDeleted: updatedOrder.isDeleted,
            datumId: updatedOrder.datumId,
            tnxId: updatedOrder.tnxId,
            createdAt: updatedOrder.createdAt,
            updatedAt: DateTime.now(), // approximate
          );
          orders.refresh();
        }

        Get.snackbar(
          'Success',
          'Order status updated to ${newStatus.capitalizeFirst}',
          backgroundColor: Colors.green.withOpacity(0.15),
          colorText: Colors.green[800],
        );

        return true;
      } else {
        final errorBody = jsonDecode(response.body);
        Get.snackbar(
          'Failed',
          errorBody['message'] ?? 'Failed to update status (${response.statusCode})',
          backgroundColor: Colors.red.withOpacity(0.15),
          colorText: Colors.red[800],
        );
        return false;
      }
    } catch (e) {
      Get.snackbar('Error', 'Failed to update status: $e');
      return false;
    }
  }

  // Helper methods
  String formatDate(DateTime? date) {
    if (date == null) return '—';
    return DateFormat('dd MMM yyyy • hh:mm a').format(date);
  }

  String getStatusDisplay(String? status) {
    if (status == null) return 'Unknown';
    return status.capitalizeFirst ?? status;
  }
}