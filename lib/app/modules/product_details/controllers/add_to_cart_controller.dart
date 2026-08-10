import 'dart:convert';
import 'package:expiry_deals/app/modules/cart/controllers/cart_controller.dart';
import 'package:expiry_deals/app/modules/cart/views/cart_view.dart';
import 'package:get/get.dart';
import 'package:expiry_deals/app/data/api.dart';
import 'package:expiry_deals/app/data/base_client.dart';
import 'package:expiry_deals/common/app_color/app_colors.dart';
import 'package:expiry_deals/common/app_constant/app_constant.dart';
import 'package:expiry_deals/common/helper/local_store.dart';
import 'package:flutter/material.dart';

class AddToCartController extends GetxController {
  var isLoading = false.obs;

  /// Single cart instance app-wide; avoids duplicate [CartController.onInit] fetches.
  CartController get cartController {
    if (Get.isRegistered<CartController>()) {
      return Get.find<CartController>();
    }
    return Get.put(CartController(), permanent: true);
  }

  void _showAddedSuccess({required bool isBuyNow}) {
    Get.snackbar(
      'Added to cart',
      isBuyNow
          ? 'Opening your cart…'
          : 'You can review items in your cart anytime.',
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: AppColors.green,
      colorText: Colors.white,
      icon: const Icon(Icons.check_circle_outline, color: Colors.white, size: 28),
      margin: const EdgeInsets.all(16),
      borderRadius: 12,
      duration: const Duration(seconds: 3),
      snackStyle: SnackStyle.FLOATING,
    );
  }

  /// Add item to cart. Loading feedback is **only** via [isLoading] on the product
  /// screen (inline UI) — never use a GetX overlay snackbar for loading; it can
  /// stick after disconnects or route changes.
  Future<void> addToCart({
    required String productId,
    required int quantity,
    required bool isBuyNow,
    required String authorId,
  }) async {
    if (productId.isEmpty) {
      Get.snackbar('Error', 'Product is not available.');
      return;
    }
    if (authorId.isEmpty) {
      Get.snackbar('Error', 'Seller information is missing.');
      return;
    }

    try {
      isLoading(true);

      var token = LocalStorage.getData(key: AppConstant.token);
      if (token == null || token.isEmpty) {
        Get.snackbar('Error', 'Please sign in to add items to your cart.');
        return;
      }

      final cartAuthorId = cartController.getCartAuthorId();

      if (cartAuthorId != null && cartAuthorId != authorId) {
        await cartController.cartEmpty(refreshCartAfter: false);
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
        await cartController.fetchAddToCart(silent: true);

        if (isBuyNow) {
          Get.to(() => const CartView());
        }

        _showAddedSuccess(isBuyNow: isBuyNow);
      } else {
        Get.snackbar('Error', 'Could not add to cart. Please try again.');
      }
    } catch (e) {
      Get.snackbar('Error', e.toString());
    } finally {
      isLoading(false);
    }
  }
}
