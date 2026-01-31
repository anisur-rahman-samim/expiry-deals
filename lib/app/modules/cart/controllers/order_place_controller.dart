import 'dart:convert';
import 'package:expiry_deals/app/modules/cart/views/cart_view.dart';
import 'package:expiry_deals/app/modules/order_success/views/order_success_view.dart';
import 'package:get/get.dart';
import 'package:expiry_deals/app/data/api.dart';
import 'package:expiry_deals/app/data/base_client.dart';
import 'package:expiry_deals/common/app_constant/app_constant.dart';
import 'package:expiry_deals/common/helper/local_store.dart';
import 'package:expiry_deals/common/app_color/app_colors.dart';
import 'package:flutter/material.dart';

class OrderPlaceController extends GetxController {
  var isLoading = false.obs;

  // Method to add item to cart
  Future<void> createOrder({
    required String productId,
    required int quantity,
    required int method,
    required String address,
    required String city,
    required String state,
    required String zipCode,
    required String country,
  }) async {
    try {
      isLoading(true);

      // Retrieve the token from local storage
      var token = LocalStorage.getData(key: AppConstant.token);
      if (token == null || token.isEmpty) {
        Get.snackbar('Error', 'Authentication token is missing.');
        return;
      }

      var headers = {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      };

      // Define the request body
      var body = {
        "product": productId,
        "quantity": quantity,
        "billingDetails": {
          "address": address,
          "city": city,
          "state": state,
          "zipCode": zipCode,
          "country": country
        }
      };

      // API call to add to cart
      dynamic response = await BaseClient.handleResponse(
        await BaseClient.postRequest(
          api: Api.createOrders,
          headers: headers,
          body: jsonEncode(body),
        ),
      );

      if (response != null) {
        if (method == 1) {
          Get.offAll(() => OrderSuccessView());
        }else{
          print("online payment");
        }

        Get.snackbar('Success', 'Order place successfully');
      } else {
        Get.snackbar('Error', 'Failed to order place.');
      }
    } catch (e) {
      Get.snackbar('Error', e.toString());
    } finally {
      isLoading(false);
    }
  }
}
