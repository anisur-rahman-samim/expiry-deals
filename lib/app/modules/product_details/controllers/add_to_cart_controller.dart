import 'dart:convert';
import 'package:expiry_deals/app/modules/cart/views/cart_view.dart';
import 'package:get/get.dart';
import 'package:expiry_deals/app/data/api.dart';
import 'package:expiry_deals/app/data/base_client.dart';
import 'package:expiry_deals/common/app_constant/app_constant.dart';
import 'package:expiry_deals/common/helper/local_store.dart';
import 'package:expiry_deals/common/app_color/app_colors.dart';
import 'package:flutter/material.dart';

class AddToCartController extends GetxController {
  var isLoading = false.obs;


  // Method to add item to cart
  Future<void> addToCart({required String productId, required int quantity, required bool isBuyNow}) async {
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
        'product': productId,
        'quantity': quantity,
      };

      // API call to add to cart
      dynamic response = await BaseClient.handleResponse(
        await BaseClient.postRequest(
          api: Api.cart,
          headers: headers,
          body: jsonEncode(body),
        ),
      );

      if (response != null) {


        if(  isBuyNow == true){

          Get.to(() => CartView());
        }
        Get.snackbar('Success', 'Item added to cart!');
      } else {
        Get.snackbar('Error', 'Failed to add item to cart.');
      }
    } catch (e) {
      Get.snackbar('Error', e.toString());
    } finally {
      isLoading(false);
    }
  }


}
