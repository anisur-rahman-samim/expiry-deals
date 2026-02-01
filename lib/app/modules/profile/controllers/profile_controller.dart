import 'package:expiry_deals/app/data/api.dart';
import 'package:expiry_deals/app/data/base_client.dart';
import 'package:expiry_deals/app/modules/auth/views/login_view.dart';
import 'package:expiry_deals/common/app_constant/app_constant.dart';
import 'package:expiry_deals/common/helper/local_store.dart';
import 'package:get/get.dart';
import 'package:expiry_deals/app/modules/profile/model/profile_model.dart';

class ProfileController extends GetxController {
  var isLoading = true.obs;
  var profileData = ProfileModel().obs;

  @override
  void onInit() {
    super.onInit();
    fetchProfile();
  }

  Future<void> fetchProfile() async {
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
        await BaseClient.getRequest(api: Api.profile, headers: headers),
      );

      if (response != null && response['success'] == true) {
        profileData.value = ProfileModel.fromJson(response);

        LocalStorage.saveData(key: AppConstant.userId, data: response["data"]["_id"]);
      } else {
        Get.snackbar("Error", "Failed to fetch profile data.");
      }
    } catch (e) {
      Get.snackbar("Error", e.toString());
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> deleteProfile() async {
    try {

      var response = await BaseClient.handleResponse(
        await BaseClient.deleteRequest(api: Api.deleteProfile, ),
      );

      if (response != null) {

        LocalStorage.removeData(key: AppConstant.token);
        Get.offAll(() => LoginView());

      } else {
        Get.snackbar("Error", "Failed to delete account data.");
      }
    } catch (e) {
      Get.snackbar("Error", e.toString());
    } finally {
      isLoading.value = false;
    }
  }
}
