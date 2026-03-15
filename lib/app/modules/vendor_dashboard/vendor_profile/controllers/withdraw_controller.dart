import 'dart:convert';
import 'package:expiry_deals/app/data/api.dart';
import 'package:expiry_deals/app/modules/profile/controllers/profile_controller.dart';
import 'package:expiry_deals/app/modules/vendor_dashboard/vendor_profile/model/withdraw_model.dart';
import 'package:expiry_deals/common/app_constant/app_constant.dart';
import 'package:expiry_deals/common/helper/local_store.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

// ────────────────────────────────────────────────
// CONTROLLER
// ────────────────────────────────────────────────
class WithdrawController extends GetxController {
  // ── Observables ───────────────────────────────────────
  var availableBalance = 0.0.obs;
  var withdrawalRequests = <WithdrawRequest>[].obs;
  var isLoading = false.obs;

  final ProfileController profileController = Get.put(ProfileController());

  final TextEditingController amountController = TextEditingController();

  @override
  void onInit() {
    super.onInit();
    fetchWithdrawalRequests();    // load history
  }

  // Fetch user's withdrawal requests
  Future<void> fetchWithdrawalRequests() async {
    try {
      isLoading.value = true;

      String? token = LocalStorage.getData(key: AppConstant.token);
      if (token == null || token.isEmpty) {
        throw "Authentication token is missing.";
      }

      var headers = {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      };

      final response = await http.get(
        Uri.parse(Api.myWithdrawRequest),
        headers: headers,
      );

      if (response.statusCode == 200) {
        final model = WithdrawRequestModel.fromJson(jsonDecode(response.body));

        if (model.success == true && model.data != null) {
          withdrawalRequests.assignAll(model.data!.data);
        } else {
          Get.snackbar("Error", model.message ?? "Failed to load requests");
        }
      } else {
        Get.snackbar("Error", "Server error: ${response.statusCode}");
      }
    } catch (e) {
      Get.snackbar("Error", "Something went wrong: $e");
    } finally {
      isLoading.value = false;
    }
  }

  // Create new withdrawal request
  Future<void> createWithdrawalRequest(double amount) async {
    if (amount <= 0) {
      Get.snackbar("Invalid Amount", "Please enter a valid amount");
      return;
    }

    // Optional: check against balance if you fetch it
    // if (amount > availableBalance.value) { ... }

    try {
      isLoading.value = true;

      final body = jsonEncode({
        "amount": amount.toInt(), // API expects int?
        // "bankDetails": ... if needed
        // Add other required fields if your API needs them
      });

      String? token = LocalStorage.getData(key: AppConstant.token);
      if (token == null || token.isEmpty) {
        throw "Authentication token is missing.";
      }

      var headers = {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      };


      final response = await http.post(
        Uri.parse(Api.withdrawRequest),
        headers: headers,
        body: body,
      );

      if (response.statusCode == 201 || response.statusCode == 200) {
        final model = WithdrawRequestModel.fromJson(jsonDecode(response.body));



        if (model.success == true) {
          await profileController.fetchProfile();
          Get.back(); // close dialog
          Get.snackbar("Success", "Withdrawal request submitted");

          // Refresh list
          fetchWithdrawalRequests();

          // Optional: update balance if you have it
          // availableBalance.value -= amount;
        } else {
          Get.snackbar("Error", model.message ?? "Failed to submit request");
        }
      } else {
        Get.snackbar("Error", "Server error: ${response.statusCode}");
      }
    } catch (e) {
      Get.snackbar("Error", "Failed to submit: $e");
    } finally {
      isLoading.value = false;
    }
  }


  @override
  void onClose() {
    amountController.dispose();
    super.onClose();
  }
}