import 'dart:convert';
import 'package:expiry_deals/app/modules/auth/views/login_view.dart';
import 'package:expiry_deals/app/modules/auth/views/verify_view.dart';
import 'package:expiry_deals/app/modules/forget/views/reset_view.dart';
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
          Get.offAll(() => VendorDashboardView());
        } else {
          Get.offAll(() => DashboardView());
        }
      }
    } catch (e) {
      debugPrint("Login Error: $e");
    } finally {
      isLoading(false);
    }
  }

  // Registration function
  Future<void> registration({
    required String name,
    required String email,
    required String phone,
    required String password,
    required String address,
  }) async {
    try {
      isLoading(true);

      var headers = {
        'Content-Type': 'application/json',
      };

      var body = {
        'name': name,
        'email': email,
        'phoneNumber': phone,
        'password': password,
        'address': address,
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
        Get.to(() => VerifyView(isSignUp: true));
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
        Get.snackbar("Success", "OTP Verified Successfully");

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
        Get.snackbar("Error", "Invalid OTP. Please try again.");
      }
    } catch (e) {
      debugPrint("OTP Verification Error: $e");
      Get.snackbar("Error", e.toString());
    } finally {
      isLoading(false);
    }
  }

  // Resend OTP function
  Future<void> resendOtp() async {
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
          body: jsonEncode({}),
        ),
      );

      if (response != null && response['success'] == true) {
        Get.snackbar("Success", "OTP Sent Again!");
      } else {
        Get.snackbar("Error", "Failed to resend OTP.");
      }
    } catch (e) {
      debugPrint("Resend OTP Error: $e");
      Get.snackbar("Error", e.toString());
    } finally {
      isLoading(false);
    }
  }
}
