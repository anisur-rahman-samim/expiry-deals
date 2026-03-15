import 'dart:convert';
import 'package:expiry_deals/app/modules/auth/views/login_view.dart';
import 'package:get/get.dart';
import 'package:expiry_deals/app/data/api.dart';
import 'package:expiry_deals/app/data/base_client.dart';
import 'package:expiry_deals/common/app_constant/app_constant.dart';
import 'package:expiry_deals/common/helper/local_store.dart';
import 'package:flutter/material.dart';

class ResetPasswordController extends GetxController {
  var isLoading = false.obs;

  // Reset password function
  Future<void> resetPassword({
    required String newPassword,
    required String confirmPassword,
  }) async {
    try {
      isLoading(true);

      String? otpToken = LocalStorage.getData(key: AppConstant.token);
      if (otpToken == null || otpToken.isEmpty) {
        Get.snackbar("Error", "OTP Token is missing.");
        return;
      }

      var headers = {
        'token': otpToken,
        'Content-Type': 'application/json',
      };

      var body = {
        'newPassword': newPassword,
        'confirmPassword': confirmPassword,
      };

      dynamic response = await BaseClient.handleResponse(
        await BaseClient.patchRequest(
          api: Api.resetPassword,
          headers: headers,
          body: jsonEncode(body),
        ),
      );

      if (response != null && response['success'] == true) {
        Get.snackbar("Success", "Password reset successfully.");
        LocalStorage.removeData(key: AppConstant.token);
        Get.to(() => LoginView()); // Redirect to login screen
      } else {
        Get.snackbar("Error", "Failed to reset password.");
      }
    } catch (e) {
      debugPrint("Reset Password Error: $e");
      Get.snackbar("Error", e.toString());
    } finally {
      isLoading(false);
    }
  }
}
