import 'dart:convert';
import 'package:expiry_deals/app/modules/cart/controllers/cart_controller.dart';
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

  final CartController cartController = Get.put(CartController());


  // Method to add item to cart
  Future<void> addToCart({
    required String productId,
    required int quantity,
    required bool isBuyNow,
    required String authorId, // 🔴 pass authorId from product
  }) async {
    try {
      isLoading(true);

      var token = LocalStorage.getData(key: AppConstant.token);
      if (token == null || token.isEmpty) {
        Get.snackbar('Error', 'Authentication token is missing.');
        return;
      }

      // 🔍 Check existing cart author
      String? cartAuthorId = cartController.getCartAuthorId();

      // ❌ Different author → Empty cart first
      if (cartAuthorId != null && cartAuthorId != authorId) {
        await cartController.cartEmpty();
      }

      var headers = {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      };

      var body = {
        'product': productId,
        'quantity': quantity,
      };

      dynamic response = await BaseClient.handleResponse(
        await BaseClient.postRequest(
          api: Api.cart,
          headers: headers,
          body: jsonEncode(body),
        ),
      );

      if (response != null && response['success'] == true) {
        await cartController.fetchAddToCart();

        if (isBuyNow) {
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
