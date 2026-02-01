
import 'package:expiry_deals/app/data/api.dart';
import 'package:expiry_deals/app/data/base_client.dart';
import 'package:expiry_deals/app/modules/vendor_dashboard/vendor_home/model/vendor_home_model.dart';
import 'package:expiry_deals/common/app_constant/app_constant.dart';
import 'package:expiry_deals/common/helper/local_store.dart';
import 'package:get/get.dart';

class VendorHomeController extends GetxController {
  var isLoading = false.obs;

  var vendorDashboard = VendorDashboardModel().obs;

  RxString totalRevenue = "0".obs;
  RxString totalProducts = "0".obs;

  @override
  void onInit() {
    super.onInit();
    fetchVendorDashboard();
  }
  /// ─────────────────────────────────────────────
  /// GET Vendor dashbaord
  /// ─────────────────────────────────────────────
  Future<void> fetchVendorDashboard() async {
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
        await BaseClient.getRequest(api: Api.vendorDashboard, headers: headers),
      );

      if (response != null && response['success'] == true) {
        vendorDashboard.value = VendorDashboardModel.fromJson(response);

        totalRevenue.value = vendorDashboard.value.data!.totalIncome.toString();
        totalProducts.value = vendorDashboard.value.data!.totalProducts.toString();


      } else {
        Get.snackbar("Error", "Failed to fetch bank data.");
      }
    } catch (e) {
      Get.snackbar("Error", e.toString());
    } finally {
      isLoading.value = false;
    }
  }
}