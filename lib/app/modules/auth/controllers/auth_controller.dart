import 'dart:convert';
import 'package:expiry_deals/app/modules/auth/views/login_view.dart';
import 'package:expiry_deals/app/modules/auth/views/verify_view.dart';
import 'package:expiry_deals/app/modules/forget/views/reset_view.dart';
import 'package:expiry_deals/common/app_color/app_colors.dart';
import 'package:expiry_deals/common/widgets/custom_snackbar.dart';
import 'package:get/get.dart';
import 'package:expiry_deals/app/data/api.dart';
import 'package:expiry_deals/app/data/base_client.dart';
import 'package:expiry_deals/common/app_constant/app_constant.dart';
import 'package:expiry_deals/common/helper/local_store.dart';
import 'package:flutter/material.dart';
import '../../dashboard/views/dashboard_view.dart';
import '../../vendor_dashboard/views/vendor_dashboard_view.dart';

class AuthController extends GetxController {
  var isLoading = false.obs;

    // ────────────────────────────────────────────────
  //  Form Controllers (for signup screen)
  // ────────────────────────────────────────────────
  final nameController            = TextEditingController();
  final emailController           = TextEditingController();

  final passwordController        = TextEditingController();
  final confirmPasswordController = TextEditingController();
  final addressController         = TextEditingController();

  @override
  void onClose() {
    nameController.dispose();
    emailController.dispose();

    passwordController.dispose();
    confirmPasswordController.dispose();
    addressController.dispose();
    super.onClose();
  }


  // Login function
  Future<void> login({required String email, required String password}) async {
    try {
      isLoading(true);

      var headers = {
        'Content-Type': 'application/json',
      };

      var body = {
        'email': email,
        'password': password,
      };

      // Sending request to the server for login
      dynamic response = await BaseClient.handleResponse(
        await BaseClient.postRequest(
          api: Api.login,
          headers: headers,
          body: jsonEncode(body),
        ),
      );

      if (response != null) {
        // Store token in local storage
        LocalStorage.saveData(key: AppConstant.token, data: response['data']['accessToken']);
        LocalStorage.saveData(key: AppConstant.role, data: response['data']['user']['role']);

        String role = LocalStorage.getData(key: AppConstant.role);

        // Navigate to the appropriate dashboard based on the role
        if (role == "vendor") {
          
            kSnackBar(message: "${response['message']}", bgColor: AppColors.green);
          Get.offAll(() => VendorDashboardView());
        
        } else {
         kSnackBar(message: "${response['message']}", bgColor: AppColors.green);
          Get.offAll(() => DashboardView());
        }
        if(response['success'] = false){
                     kSnackBar(message: "${response['message']}", bgColor: AppColors.failedColor);
        }

      }
    } catch (e) {
      debugPrint("Login Error: $e");
    } finally {
      isLoading(false);
    }
  }

  // Registration function
  Future<void> registration() async {
    try {
      isLoading(true);

      var headers = {
        'Content-Type': 'application/json',
      };

      var body = {
        'name': nameController.text,
        'email': emailController.text.trim(),
        'password': passwordController.text,
        'address': addressController.text,
      };

      // Sending request to the server for registration
      dynamic response = await BaseClient.handleResponse(
        await BaseClient.postRequest(
          api: Api.register,
          headers: headers,
          body: jsonEncode(body),
        ),
      );

      if (response != null) {
        var otpToken = response['data']['otpToken']['token'];

        LocalStorage.saveData(key: AppConstant.otpToken, data: otpToken);

        // Redirect to OTP verification screen
        Get.to(() => VerifyView(isSignUp: true,email: emailController.text.trim(),));
      }
    } catch (e) {
      debugPrint("Registration Error: $e");
    } finally {
      isLoading(false);
    }
  }

  // Verify OTP function
  Future<void> verifyOtp(String otp, bool isSignup) async {
    try {
      isLoading(true);

      String? otpToken = LocalStorage.getData(key: AppConstant.otpToken);

      if (otpToken == null || otpToken.isEmpty) {
        throw 'OTP Token is missing.';
      }

      var headers = {
        'Content-Type': 'application/json',
        'token': otpToken,
      };

      var body = {
        'otp': otp,
      };

      dynamic response = await BaseClient.handleResponse(
        await BaseClient.postRequest(
          api: Api.verifyOtp,
          headers: headers,
          body: jsonEncode(body),
        ),
      );

      if (response != null && response['success'] == true) {
        // OTP successfully verified
  
        kSnackBar(message: "OTP Verified Successfully", bgColor: AppColors.green);

        var token = response['data']['token'];

        LocalStorage.saveData(key: AppConstant.token, data: token);

        if(isSignup == true){
          Get.offAll(() => LoginView());
        }else{
          Get.offAll(() => ResetView());
        }

        // Navigate to the next step after OTP verification

      } else {
        // OTP verification failed
       
        kSnackBar(message: "Invalid OTP. Please try again.", bgColor: AppColors.failedColor);
      }
    } catch (e) {
      debugPrint("OTP Verification Error: $e");

    } finally {
      isLoading(false);
    }
  }

  // Resend OTP function
  Future<void> resendOtp({required String email}) async {
    try {
      isLoading(true);

      String? otpToken = LocalStorage.getData(key: AppConstant.otpToken);

      if (otpToken == null || otpToken.isEmpty) {
        throw 'OTP Token is missing.';
      }

      var headers = {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $otpToken',
      };

      dynamic response = await BaseClient.handleResponse(
        await BaseClient.postRequest(
          api: Api.resendOtp,
          headers: headers,
          body: jsonEncode({
            "email":email.trim()
          }),
        ),
      );

      if (response != null && response['success'] == true) {
      
        kSnackBar(message: "OTP Sent Again!", bgColor: AppColors.green);
      } else {
              kSnackBar(message: "Failed to resend OTP.", bgColor: AppColors.failedColor);
  
      }
    } catch (e) {
      debugPrint("Resend OTP Error: $e");
    } finally {
      isLoading(false);
    }
  }
}
