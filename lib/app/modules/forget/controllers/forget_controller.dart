import 'dart:convert';
import 'package:expiry_deals/app/modules/auth/views/verify_view.dart';
import 'package:get/get.dart';
import 'package:expiry_deals/app/data/api.dart';
import 'package:expiry_deals/app/data/base_client.dart';
import 'package:expiry_deals/common/helper/local_store.dart';
import 'package:expiry_deals/common/app_constant/app_constant.dart';
import 'package:flutter/material.dart';

class ForgetController extends GetxController {
  var isLoading = false.obs;

  // Forget password function
  Future<void> forgetPassword({required String email}) async {
    try {
      isLoading(true);

      var headers = {
        'Content-Type': 'application/json',
      };

      var body = {
        'email': email,
      };

      dynamic response = await BaseClient.handleResponse(
        await BaseClient.patchRequest(
          api: Api.forgetPassword,
          headers: headers,
          body: jsonEncode(body),
        ),
      );
      debugPrint("Forget:$response");
      if (response != null) {
     //   Get.snackbar("Success", "Password reset link sent to your email.");
        // Redirect to the verification page (OTP page)

        var otpToken = response['data']['token'];

        LocalStorage.saveData(key: AppConstant.otpToken, data: otpToken);
        Get.to(() => VerifyView(isSignUp: false));


      } else {
        debugPrint("Forget Password Error:$response");
      //  Get.snackbar("Error", "Failed to send reset password link.");
      }
    } catch (e) {
      debugPrint("Forget Password Error: $e");
      Get.snackbar("Error", e.toString());
    } finally {
      isLoading(false);
    }
  }
}
