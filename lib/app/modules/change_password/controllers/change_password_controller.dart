import 'dart:convert';
import 'package:expiry_deals/app/data/api.dart';
import 'package:expiry_deals/app/data/base_client.dart';
import 'package:expiry_deals/common/app_constant/app_constant.dart';
import 'package:expiry_deals/common/helper/local_store.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ChangePasswordController extends GetxController {
  var isLoading = false.obs;

  // Function to change the password
  Future<void> changePassword(String oldPassword, String newPassword, String confirmPassword, BuildContext context) async {
    // Validate input fields
    if (newPassword != confirmPassword) {
      Get.snackbar("Error", "New password and confirm password do not match.");
      return;
    }

    String? token = LocalStorage.getData(key: AppConstant.token);
    if (token == null || token.isEmpty) {
      Get.snackbar("Error", "Authentication token is missing.");
      return;
    }


    var headers = {
      'Authorization': 'Bearer $token',
    };
    debugPrint(token);

    var body = {
      "oldPassword": oldPassword,
      "newPassword": newPassword,
      "confirmPassword": confirmPassword,
    };

    isLoading.value = true;

    try {
      var response = await BaseClient.handleResponse(
        await BaseClient.patchRequest(
          api: Api.changePassword,
          headers: headers,
          body: jsonEncode(body),
        ),
      );

debugPrint("this is done: $response");
      if (response != null && response['success'] == true) {
debugPrint("this is done:");
Navigator.pop(context);
       // Get.snackbar("Success", "Password changed successfully.");
        // Optionally navigate to another screen
      } else {
        Get.snackbar("Error", "Failed to change password.");
      }
    } catch (e) {
      debugPrint(e.toString());
    } finally {
      isLoading.value = false;
    }
  }
}
