import 'dart:convert';

import 'package:expiry_deals/app/data/api.dart';
import 'package:expiry_deals/app/data/base_client.dart';
import 'package:expiry_deals/app/modules/vendor_dashboard/vendor_profile/model/bank_details_model.dart';
import 'package:expiry_deals/common/app_constant/app_constant.dart';
import 'package:expiry_deals/common/helper/local_store.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

class BankDetailsController extends GetxController {
  final accountNumberCtrl = TextEditingController();
  final routingNumberCtrl = TextEditingController();
  final bankNameCtrl = TextEditingController();
  final holderNameCtrl = TextEditingController();
  final bankAddressCtrl = TextEditingController();

  var isLoading = false.obs;
  var bankDetails = MyBankDetailsModel().obs;

  /// True when API returned 404 (no saved bank info yet) — not an error.
  var noBankDetailsYet = false.obs;

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


  /// Loads saved bank info. **404 = no record yet** (normal for new vendors) — do not treat as error.
  Future<void> fetchMyBankDetails() async {
    try {
      isLoading.value = true;
      final token = LocalStorage.getData(key: AppConstant.token);
      if (token == null || token.isEmpty) {
        throw "Authentication token is missing.";
      }

      final headers = {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      };

      final raw = await http.get(Uri.parse(Api.myBankDetails), headers: headers);

      if (raw.statusCode == 200) {
        final decoded = jsonDecode(raw.body) as Map<String, dynamic>;
        if (decoded['success'] == true) {
          bankDetails.value = MyBankDetailsModel.fromJson(decoded);
          final data = bankDetails.value.data;
          noBankDetailsYet.value = data == null;
          accountNumberCtrl.text = data?.accountNumber ?? "";
          routingNumberCtrl.text = data?.routingNumber ?? "";
          bankNameCtrl.text = data?.bankName ?? "";
          holderNameCtrl.text = data?.bankHolderName ?? "";
          bankAddressCtrl.text = data?.bankAddress ?? "";
        }
      } else if (raw.statusCode == 404) {
        // Backend: "Bank details not found" — expected until first save.
        noBankDetailsYet.value = true;
        bankDetails.value = MyBankDetailsModel();
      } else {
        String msg = 'Failed to load bank details';
        try {
          final decoded = jsonDecode(raw.body) as Map<String, dynamic>?;
          msg = decoded?['message']?.toString() ?? msg;
        } catch (_) {}
        Get.snackbar('Error', msg);
      }
    } catch (e) {
      debugPrint('fetchMyBankDetails: $e');
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
        noBankDetailsYet.value = false;
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