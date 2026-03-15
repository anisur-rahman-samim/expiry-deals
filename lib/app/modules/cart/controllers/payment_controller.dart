
import 'dart:convert';

import 'package:expiry_deals/app/modules/order_success/views/order_success_view.dart';
import 'package:expiry_deals/common/helper/local_store.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

import '../../../../common/app_color/app_colors.dart';
import '../../../../common/app_constant/app_constant.dart';
import '../../../../common/widgets/custom_snackbar.dart';
import '../../../data/base_client.dart';

class PaymentController extends GetxController {
  var isLoading = false.obs;



  Future<void> paymentDone({required String paymentApi}) async {
    try {
      isLoading(true);

      final token = LocalStorage.getData(key: AppConstant.token);
      if (token == null) throw 'No auth token found';

      final headers = {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      };

      print('Verifying payment → $paymentApi');
      print('Headers: $headers');

      final response = await BaseClient.getRequest(api: paymentApi, headers: headers);

      print('Status code: ${response.statusCode}');
      print('Response body: ${response.body}');

      // First priority: check HTTP status filagal955@newtrea.com
      if (response.statusCode == 200) {
        Get.to(() => OrderSuccessView()); // #O34KW6KCRC

      } else {
        Get.back();
        kSnackBar(message: "Payment verified but status not success", bgColor: AppColors.orange);
      }
    } catch (e) {
      debugPrint("Payment verification error: $e");
      kSnackBar(message: "Payment error: $e", bgColor: AppColors.orange);
      Get.back();
    } finally {
      isLoading(false);
    }
  }
}