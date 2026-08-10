import 'dart:convert';
import 'package:expiry_deals/app/data/api.dart';
import 'package:expiry_deals/app/modules/profile/controllers/profile_controller.dart';
import 'package:expiry_deals/app/modules/vendor_dashboard/vendor_profile/model/my_shop_model.dart';
import 'package:expiry_deals/app/modules/vendor_dashboard/vendor_profile/model/withdraw_model.dart';
import 'package:expiry_deals/common/app_constant/app_constant.dart';
import 'package:expiry_deals/common/helper/local_store.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

/// How the vendor receives withdrawn funds.
enum PayoutMethod { ach, cheque }

// ────────────────────────────────────────────────
// CONTROLLER
// ────────────────────────────────────────────────
class WithdrawController extends GetxController {
  /// Copy only — align with your processor’s real ACH fee schedule.
  static const String achFeeDisclosure =
      'ACH transfers are typically processed within 2–5 business days. A processing fee may apply '
      '(commonly around 0.5%–1.5% of the amount, minimum fee may apply—see your payout statement).';

  static const String chequeDisclosure =
      'We will mail a company check to the mailing address on your account. Delivery time '
      'depends on postal service.';

  // ── Observables ───────────────────────────────────────
  var availableBalance = 0.0.obs;
  var withdrawalRequests = <WithdrawRequest>[].obs;
  var isLoading = false.obs;

  final ProfileController profileController = Get.put(ProfileController());

  final TextEditingController amountController = TextEditingController();

  final selectedPayoutMethod = PayoutMethod.ach.obs;
  final chequeAddressConfirmed = false.obs;

  /// Latest shop record (includes shop `address` from Edit Shop) — used for cheque mailing line.
  final shopSnapshot = Rxn<MyShopModel>();

  @override
  void onInit() {
    super.onInit();
    refreshAll();
  }

  /// Loads shop address for cheque mailing (same source as Edit Shop).
  Future<void> fetchMyShopSnapshot() async {
    try {
      final token = LocalStorage.getData(key: AppConstant.token);
      if (token == null || token.isEmpty) return;

      final response = await http.get(
        Uri.parse(Api.myShop),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );
      if (response.statusCode != 200) return;
      final decoded = jsonDecode(response.body) as Map<String, dynamic>?;
      if (decoded?['success'] == true) {
        shopSnapshot.value = MyShopModel.fromJson(decoded!);
      }
    } catch (_) {
      // ignore
    }
  }

  /// Refreshes wallet balance (profile) + shop address + withdrawal list.
  Future<void> refreshAll() async {
    await profileController.fetchProfile();
    await fetchMyShopSnapshot();
    await fetchWithdrawalRequests();
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

  void setPayoutMethod(PayoutMethod m) {
    selectedPayoutMethod.value = m;
    if (m == PayoutMethod.ach) {
      chequeAddressConfirmed.value = false;
    }
  }

  /// True if shop address (Edit Shop) or user profile mailing fields are set.
  bool _hasChequeMailingAddress() {
    final shop = shopSnapshot.value?.data?.address?.toString().trim() ?? '';
    if (shop.isNotEmpty) return true;
    final d = profileController.profileData.value.data;
    if (d == null) return false;
    bool nonEmpty(dynamic v) => v != null && v.toString().trim().isNotEmpty;
    if (nonEmpty(d.address)) return true;
    if (nonEmpty(d.city) || nonEmpty(d.state) || nonEmpty(d.zipCode)) return true;
    if (nonEmpty(d.country)) return true;
    return false;
  }

  // Create new withdrawal request
  Future<void> createWithdrawalRequest(double amount) async {
    if (amount <= 0) {
      Get.snackbar("Invalid Amount", "Please enter a valid amount");
      return;
    }

    // Optional: check against balance if you fetch it
    // if (amount > availableBalance.value) { ... }

    final method = selectedPayoutMethod.value;
    if (method == PayoutMethod.cheque) {
      if (!_hasChequeMailingAddress()) {
        Get.snackbar(
          'Mailing address required',
          'Add your shop address in Edit Shop, or your address in Edit profile.',
        );
        return;
      }
      if (!chequeAddressConfirmed.value) {
        Get.snackbar(
          'Confirmation required',
          'Please confirm your mailing address for cheque delivery.',
        );
        return;
      }
    }

    try {
      isLoading.value = true;

      final payoutKey = method == PayoutMethod.ach ? 'ach' : 'cheque';
      final bodyMap = <String, dynamic>{
        'amount': amount.toInt(),
        'payoutMethod': payoutKey,
        if (method == PayoutMethod.cheque) 'chequeAddressConfirmed': true,
      };

      final body = jsonEncode(bodyMap);

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