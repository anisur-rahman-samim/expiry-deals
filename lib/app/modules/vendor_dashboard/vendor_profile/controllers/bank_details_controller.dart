import 'package:flutter/material.dart';
import 'package:get/get.dart';

class BankDetailsController extends GetxController {
  final accountNumberCtrl = TextEditingController();
  final routingNumberCtrl = TextEditingController();
  final bankNameCtrl = TextEditingController();
  final holderNameCtrl = TextEditingController();
  final bankAddressCtrl = TextEditingController();

  @override
  void onInit() {
    super.onInit();
    // Load existing data
    accountNumberCtrl.text = "1234567890";
    routingNumberCtrl.text = "987654321";
    bankNameCtrl.text = "First National Bank";
    holderNameCtrl.text = "John Doe";
    bankAddressCtrl.text = "123 Main Street, Springfield, IL 62704";
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