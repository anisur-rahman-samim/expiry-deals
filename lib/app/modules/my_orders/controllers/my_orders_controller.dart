import 'dart:convert';
import 'package:expiry_deals/app/data/api.dart';
import 'package:expiry_deals/app/data/base_client.dart';
import 'package:expiry_deals/common/helper/local_store.dart';
import 'package:expiry_deals/common/app_constant/app_constant.dart';
import 'package:get/get.dart';
import 'package:expiry_deals/app/modules/my_orders/model/my_order_model.dart';

class MyOrdersController extends GetxController {
  var isLoading = true.obs;
  var allOrders = <MyOrder>[].obs;
  var pendingOrders = <MyOrder>[].obs;
  var processingOrders = <MyOrder>[].obs;
  var deliveredOrders = <MyOrder>[].obs;
  var cancelledOrders = <MyOrder>[].obs;

  @override
  void onInit() {
    fetchOrders();
    super.onInit();
  }

  Future<void> fetchOrders() async {
    isLoading(true);

    String? token = LocalStorage.getData(key: AppConstant.token);
    if (token == null || token.isEmpty) {
      Get.snackbar('Error', 'Authentication token is missing.');
      return;
    }

    var headers = {
      'Authorization': 'Bearer $token',
    };

    try {
      var response = await BaseClient.handleResponse(
        await BaseClient.getRequest(
          api: Api.myOrders,
          headers: headers,
        ),
      );

      if (response != null && response['success'] == true) {
        final orders = MyOrderModel.fromJson(response).data?.data ?? [];
        allOrders.assignAll(orders);
        pendingOrders.assignAll(orders.where((order) => order.status == 'pending'));
        processingOrders.assignAll(orders.where((order) => order.status == 'processing'));
        deliveredOrders.assignAll(orders.where((order) => order.status == 'delivered'));
        cancelledOrders.assignAll(orders.where((order) => order.status == 'cancelled'));
      } else {
        Get.snackbar('Error', 'Failed to fetch orders.');
      }
    } catch (e) {
      Get.snackbar('Error', e.toString());
    } finally {
      isLoading(false);
    }
  }
}
