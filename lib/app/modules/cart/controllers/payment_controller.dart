
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
      var headers = {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer ${LocalStorage.getData(key: AppConstant.token)}',
      };
      print('Making request to: $paymentApi');
      print('Headers: $headers');

      dynamic responseBody = await BaseClient.handleResponse(
        await BaseClient.getRequest(api: paymentApi, headers: headers),
      );

      print('Response body: $responseBody');
      if (responseBody != null) {
        bool isTruePayment = responseBody['success'] == false ||
            responseBody['success'] == 'true' ||
            responseBody['status'] == 'success';
        if (isTruePayment) {

          Get.to(() => OrderSuccessView());
        } else {
          Get.back();
          kSnackBar(message: "Payment failed!", bgColor: AppColors.orange);
        }
      } else {
        throw 'Failed payment: Response body is null';
      }
    } catch (e) {
      debugPrint("Catch Error:::::: $e");
      kSnackBar(message: "Payment error: $e", bgColor: AppColors.orange);
    } finally {
      isLoading(false);
    }
  }
}