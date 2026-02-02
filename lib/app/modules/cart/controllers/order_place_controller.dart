import 'dart:convert';
import 'package:expiry_deals/app/modules/cart/controllers/cart_controller.dart';
import 'package:expiry_deals/app/modules/cart/views/cart_view.dart';
import 'package:expiry_deals/app/modules/cart/views/payment_web_view.dart';
import 'package:expiry_deals/app/modules/order_success/views/order_success_view.dart';
import 'package:expiry_deals/common/widgets/custom_snackbar.dart';
import 'package:get/get.dart';
import 'package:expiry_deals/app/data/api.dart';
import 'package:expiry_deals/app/data/base_client.dart';
import 'package:expiry_deals/common/app_constant/app_constant.dart';
import 'package:expiry_deals/common/helper/local_store.dart';
import 'package:expiry_deals/common/app_color/app_colors.dart';
import 'package:flutter/material.dart';

class OrderPlaceController extends GetxController {
  var isLoading = false.obs;

  final CartController cartController = Get.put(CartController());

  final paymentUrl = "".obs;

  // Method to create an order
  Future<void> createOrder({
    required String authorId, // Added author ID
    required List<Map<String, dynamic>> items, // List of items with product ID and quantity
    required double totalPrice, // Total price calculation
    required String address,
    required String city,
    required String state,
    required String zipCode,
    required String country,
    required String paymentMethod,
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
        "author": authorId,
        "items": items,
        "totalPrice": totalPrice,
        "billingDetails": {
          "address": address,
          "city": city,
          "state": state,
          "zipCode": zipCode,
          "country": country
        }
      };

      // API call to create an order
      dynamic response = await BaseClient.handleResponse(
        await BaseClient.postRequest(
          api: Api.createOrders,
          headers: headers,
          body: jsonEncode(body),
        ),
      );

      if (response != null) {
        if (response["success"] == true) {
          cartController.cartEmpty();
          if(paymentMethod == "1"){
            Get.offAll(() => OrderSuccessView());
            kSnackBar(message: 'Order placed successfully', bgColor: AppColors.green);
          }else{
         await   orderCheckout(orderId: response["data"]["_id"]);
          }

        } else {
      
          kSnackBar(message: 'Failed to place order.', bgColor: AppColors.failedColor);
        }
      } else {
      
            kSnackBar(message: 'Failed to place order.', bgColor: AppColors.failedColor);
      }
    } catch (e) {
      debugPrint(e.toString());
    } finally {
      isLoading(false);
    }
  }

  // Method to create an order
  Future<void> orderCheckout({
    required String orderId,

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
        "order": orderId

      };

      // API call to create an order
      dynamic response = await BaseClient.handleResponse(
        await BaseClient.postRequest(
          api: Api.paymentsCheckout,
          headers: headers,
          body: jsonEncode(body),
        ),
      );

      if (response != null) {
        if (response["success"] == true) {
          paymentUrl.value = response["data"];
          //paymentUrl will be open a webview then after payment will be redeirect a api. after this api call responce is success then will be route successview page or failview page.
          Get.to(() => PaymentWebView(
            paymentUrl: paymentUrl.value,
            orderId: orderId,
          ));
        } else {

          kSnackBar(message: 'Failed to place order.', bgColor: AppColors.failedColor);
        }
      } else {

        kSnackBar(message: 'Failed to place order.', bgColor: AppColors.failedColor);
      }
    } catch (e) {
      debugPrint(e.toString());
    } finally {
      isLoading(false);
    }
  }
}

