import 'dart:convert';

import 'package:expiry_deals/app/data/api.dart';
import 'package:expiry_deals/app/data/base_client.dart';
import 'package:expiry_deals/app/modules/auth/views/login_view.dart';
import 'package:expiry_deals/common/app_constant/app_constant.dart';
import 'package:expiry_deals/common/helper/local_store.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:expiry_deals/app/modules/profile/model/profile_model.dart';

class ProfileController extends GetxController {
  var isLoading = true.obs;
  var profileData = ProfileModel().obs;

  /// Shop logo from `GET /shop/my-shop` — used on vendor profile header (not the same as user `profile` photo).
  final vendorShopLogoUrl = Rxn<String>();
  /// Shop banner image URL from `GET /shop/my-shop` (same as Edit Shop).
  final vendorShopBannerUrl = Rxn<String>();
  /// Optional hex banner color when no image is set.
  final vendorShopBannerColor = Rxn<String>();
  DateTime? vendorShopLogoTimestamp;

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

        final role = response["data"]?["role"]?.toString();
        if (role == "vendor") {
          await _refreshVendorShopLogo();
        } else {
          vendorShopLogoUrl.value = null;
          vendorShopBannerUrl.value = null;
          vendorShopBannerColor.value = null;
          vendorShopLogoTimestamp = null;
        }
      } else {
        Get.snackbar("Error", "Failed to fetch profile data.");
      }
    } catch (e) {
      Get.snackbar("Error", e.toString());
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> _refreshVendorShopLogo() async {
    try {
      final token = LocalStorage.getData(key: AppConstant.token);
      if (token == null || token.isEmpty) return;

      final raw = await http.get(
        Uri.parse(Api.myShop),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );
      if (raw.statusCode != 200) return;
      final decoded = jsonDecode(raw.body) as Map<String, dynamic>?;
      if (decoded?['success'] != true || decoded?['data'] == null) return;
      final data = decoded!['data'] as Map<String, dynamic>;
      final logo = data['logo']?.toString();
      vendorShopLogoUrl.value =
          (logo != null && logo.isNotEmpty) ? logo : null;
      final banner = data['banner']?.toString();
      vendorShopBannerUrl.value =
          (banner != null && banner.isNotEmpty) ? banner : null;
      final bc = data['bannerColor']?.toString();
      vendorShopBannerColor.value =
          (bc != null && bc.isNotEmpty) ? bc : null;
      vendorShopLogoTimestamp =
          DateTime.tryParse(data['updatedAt']?.toString() ?? '') ??
              DateTime.now();
    } catch (_) {
      vendorShopLogoUrl.value = null;
      vendorShopBannerUrl.value = null;
      vendorShopBannerColor.value = null;
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
