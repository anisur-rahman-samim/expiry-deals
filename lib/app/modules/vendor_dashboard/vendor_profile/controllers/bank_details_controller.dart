import 'dart:convert';

import 'package:expiry_deals/app/data/api.dart';
import 'package:expiry_deals/app/data/base_client.dart';
import 'package:expiry_deals/app/modules/vendor_dashboard/vendor_profile/model/bank_details_model.dart';
import 'package:expiry_deals/common/app_constant/app_constant.dart';
import 'package:expiry_deals/common/helper/local_store.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class BankDetailsController extends GetxController {
  final accountNumberCtrl = TextEditingController();
  final routingNumberCtrl = TextEditingController();
  final bankNameCtrl = TextEditingController();
  final holderNameCtrl = TextEditingController();
  final bankAddressCtrl = TextEditingController();

  var isLoading = false.obs;
  var bankDetails = MyBankDetailsModel().obs;

  @override
  void onInit() {
    super.onInit();
    // Load existing data
    fetchMyBankDetails();

  }

  void saveBankDetails() {
    final data = {
      "accountNumber": accountNumberCtrl.text.trim(),
      "routingNumber": routingNumberCtrl.text.trim(),
      "bankName": bankNameCtrl.text.trim(),
      "bankHolderName": holderNameCtrl.text.trim(),
      "bankAddress": bankAddressCtrl.text.trim(),
    };

    print("═══════════════════════════════════════════════");
    print("          BANK DETAILS UPDATE");
    print("═══════════════════════════════════════════════");
    data.forEach((key, value) {
      print("$key: $value");
    });
    print("═══════════════════════════════════════════════\n");

    Get.snackbar(
      "Saved",
      "Bank details have been updated",
      backgroundColor: Colors.green.shade700,
      colorText: Colors.white,
      snackPosition: SnackPosition.BOTTOM,
    );

    // Get.back();   // ← uncomment if you want to close screen
  }


  Future<void> fetchMyBankDetails() async {
    try {
      String? token = LocalStorage.getData(key: AppConstant.token);
      if (token == null || token.isEmpty) {
        throw "Authentication token is missing.";
      }

      var headers = {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      };

      var response = await BaseClient.handleResponse(
        await BaseClient.getRequest(api: Api.myBankDetails, headers: headers),
      );

      if (response != null && response['success'] == true) {
        bankDetails.value = MyBankDetailsModel.fromJson(response);
        var data = bankDetails.value.data;

        accountNumberCtrl.text = data?.accountNumber ?? "";
        routingNumberCtrl.text = data?.routingNumber ?? "";
        bankNameCtrl.text = data?.bankName ?? "";
        holderNameCtrl.text = data?.bankHolderName ?? "";
        bankAddressCtrl.text = data?.bankAddress ?? "";
      } else {
        Get.snackbar("Error", "Failed to fetch bank data.");
      }
    } catch (e) {
      Get.snackbar("Error", e.toString());
    } finally {
      isLoading.value = false;
    }
  }
  Future<void> addMyBankDetails() async {
    try {
      isLoading(true);
      String? token = LocalStorage.getData(key: AppConstant.token);
      if (token == null || token.isEmpty) {
        throw "Authentication token is missing.";
      }

      var headers = {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      };
      var body = {
        "accountNumber": accountNumberCtrl.text,
        "routingNumber": routingNumberCtrl.text,
        "bankName": bankNameCtrl.text,
        "bankHolderName": holderNameCtrl.text,
        "bankAddress": bankAddressCtrl.text
      };
      var response = await BaseClient.handleResponse(
        await BaseClient.postRequest(api: Api.addBankDetails, headers: headers,  body: jsonEncode(body), ),
      );

      if (response != null && response['success'] == true) {

      await fetchMyBankDetails();
      isLoading(false);
      Get.back();
      } else {
        Get.snackbar("Error", "Failed to fetch bank data.");
        isLoading(false);
      }
    } catch (e) {
      Get.snackbar("Error", e.toString());
      isLoading(false);
    } finally {
      isLoading(false);
      isLoading.value = false;
    }
  }



  @override
  void onClose() {
    accountNumberCtrl.dispose();
    routingNumberCtrl.dispose();
    bankNameCtrl.dispose();
    holderNameCtrl.dispose();
    bankAddressCtrl.dispose();
    super.onClose();
  }
}