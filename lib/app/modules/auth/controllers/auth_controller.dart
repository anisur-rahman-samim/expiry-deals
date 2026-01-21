import 'dart:convert';

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
}
