import 'dart:io';

import 'package:expiry_deals/app/data/api.dart';
import 'package:expiry_deals/common/app_constant/app_constant.dart';
import 'package:expiry_deals/common/helper/local_store.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:image_picker/image_picker.dart';



import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';

class EditShopController extends GetxController {
  var isLoading = false.obs;

  final nameController = TextEditingController();
  final descController = TextEditingController();
  final addressController = TextEditingController();

  final Rx<String> selectedOpeningHours = '9:00 AM - 10:00 PM'.obs;
  final RxList<String> selectedDays = <String>[].obs;

  final Rx<File?> bannerImage = Rx<File?>(null);
  final Rx<File?> logoImage = Rx<File?>(null);

  final daysOfWeek = ['mon', 'tue', 'wed', 'thu', 'fri', 'sat', 'sun'];
  GoogleMapController? mapController;
  final Rx<LatLng> shopLocation =
      const LatLng(40.73061, -73.935242).obs;

  void onMapCreated(GoogleMapController controller) {
    mapController = controller;
  }

  @override
  void onInit() {
    super.onInit();

    nameController.text = "Sunrise Boutique";
    descController.text =
    "A cozy boutique offering handmade crafts and local art.";
    addressController.text = "123 Market Street, Springfield";
 //   selectedDays.value = ["sat", "sun"];
  }

  Future<void> pickImage(bool isBanner) async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      final file = File(pickedFile.path);
      isBanner ? bannerImage.value = file : logoImage.value = file;
    }
  }

  void updateLocation(LatLng pos) {
    shopLocation.value = pos;
  }

  /// ─────────────────────────────────────────────
  /// PATCH SHOP (MULTIPART)
  /// ─────────────────────────────────────────────
  Future<void> updateShop() async {
    isLoading.value = true;

    try {
      final uri = Uri.parse(
        Api.addShop
      );

      String? token = LocalStorage.getData(key: AppConstant.token);
      if (token == null || token.isEmpty) {
        throw "Authentication token is missing.";
      }

      final request = http.MultipartRequest("PATCH", uri);

      /// ── DATA FIELD (JSON STRING) ──────────────
      final data = {
        "name": nameController.text.trim(),
        "description": descController.text.trim(),
        "address": addressController.text.trim(),
        "openingHours": selectedOpeningHours.value,
        "openingDays": selectedDays.join(', '),
        "location": {
          "type": "Point",
          "coordinates": [
            shopLocation.value.longitude,
            shopLocation.value.latitude,
          ],
        },
      };

      request.fields['data'] = jsonEncode(data);

      debugPrint("PATCH data: ${request.fields['data']}");

      /// ── LOGO FILE ─────────────────────────────
      if (logoImage.value != null &&
          await logoImage.value!.exists()) {
        request.files.add(
          await http.MultipartFile.fromPath(
            'logo',
            logoImage.value!.path,
          ),
        );
      }

      /// ── BANNER FILE ───────────────────────────
      if (bannerImage.value != null &&
          await bannerImage.value!.exists()) {
        request.files.add(
          await http.MultipartFile.fromPath(
            'banner',
            bannerImage.value!.path,
          ),
        );
      }

      /// ── HEADERS (ADD TOKEN IF NEEDED) ─────────
      request.headers.addAll({
        "Accept": "application/json",
        "Authorization": "Bearer $token",
      });

      final response = await request.send();
      final responseBody =
      await response.stream.bytesToString();

      debugPrint("Status Code: ${response.statusCode}");
      debugPrint("Response: $responseBody");

      if (response.statusCode == 200 ||
          response.statusCode == 201) {
        Get.snackbar(
          "Success",
          "Shop updated successfully",
          backgroundColor: Colors.green.shade700,
          colorText: Colors.white,
        );
      } else {
        Get.snackbar(
          "Error",
          "Failed (${response.statusCode})",
          backgroundColor: Colors.red.shade700,
          colorText: Colors.white,
        );
      }
    } catch (e, stack) {
      debugPrint("Update error: $e\n$stack");
      Get.snackbar(
        "Error",
        "Something went wrong",
        backgroundColor: Colors.red.shade700,
        colorText: Colors.white,
      );
    } finally {
      isLoading.value = false;
    }
  }

  @override
  void onClose() {
    nameController.dispose();
    descController.dispose();
    addressController.dispose();
    super.onClose();
  }
}

