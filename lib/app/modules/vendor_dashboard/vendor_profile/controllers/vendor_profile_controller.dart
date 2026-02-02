import 'dart:io';
import 'package:expiry_deals/app/data/api.dart';
import 'package:expiry_deals/app/data/base_client.dart';
import 'package:expiry_deals/app/modules/vendor_dashboard/vendor_profile/model/my_shop_model.dart';
import 'package:expiry_deals/common/app_constant/app_constant.dart';
import 'package:expiry_deals/common/helper/local_store.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class EditShopController extends GetxController {
  var isLoading = false.obs;

  var myShop = MyShopModel().obs;

  final nameController = TextEditingController();
  final descController = TextEditingController();
  final addressController = TextEditingController();

  // Changed to nullable
  final Rx<String?> selectedOpeningHours = Rx<String?>(null);

  final RxList<String> selectedDays = <String>[].obs;

  final Rx<File?> bannerImage = Rx<File?>(null);
  final Rx<File?> logoImage = Rx<File?>(null);

  final daysOfWeek = ['mon', 'tue', 'wed', 'thu', 'fri', 'sat', 'sun'];

  GoogleMapController? mapController;
  final Rx<LatLng> shopLocation = const LatLng(40.73061, -73.935242).obs;

  final List<String> allowedHours = [
    "8:00 AM - 9:00 PM",
    "9:00 AM - 10:00 PM",
    "10:00 AM - 11:00 PM",
    "11:00 AM - 12:00 AM",
    "Custom hours...",
  ];

  void onMapCreated(GoogleMapController controller) {
    mapController = controller;
  }

  @override
  void onInit() {
    super.onInit();
    fetchMyShop();
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

  Future<void> updateShop() async {
    isLoading.value = true;

    try {
      final uri = Uri.parse(Api.addShop);
      String? token = LocalStorage.getData(key: AppConstant.token);
      if (token == null || token.isEmpty) {
        throw "Authentication token is missing.";
      }

      final request = http.MultipartRequest("PATCH", uri);

      // Prepare data – use fallback if null
      final hoursToSend = selectedOpeningHours.value ?? allowedHours.first;

      final data = {
        "name": nameController.text.trim(),
        "description": descController.text.trim(),
        "address": addressController.text.trim(),
        "openingHours": hoursToSend,
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

      // Logo
      if (logoImage.value != null && await logoImage.value!.exists()) {
        request.files.add(
          await http.MultipartFile.fromPath('logo', logoImage.value!.path),
        );
      }

      // Banner
      if (bannerImage.value != null && await bannerImage.value!.exists()) {
        request.files.add(
          await http.MultipartFile.fromPath('banner', bannerImage.value!.path),
        );
      }

      request.headers.addAll({
        "Accept": "application/json",
        "Authorization": "Bearer $token",
      });

      final response = await request.send();
      final responseBody = await response.stream.bytesToString();

      debugPrint("Status Code: ${response.statusCode}");
      debugPrint("Response: $responseBody");

      if (response.statusCode == 200 || response.statusCode == 201) {
        await fetchMyShop();
        Get.back();
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
      Get.snackbar("Error", "Something went wrong");
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> fetchMyShop() async {
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
        await BaseClient.getRequest(api: Api.myShop, headers: headers),
      );

      if (response != null && response['success'] == true) {
        myShop.value = MyShopModel.fromJson(response);
        var data = myShop.value.data;

        nameController.text = data?.name ?? "";
        descController.text = data?.description ?? "";
        addressController.text = data?.address ?? "";

        // Safe handling for opening hours
        final backendHours = data?.openingHours?.trim();
        if (backendHours != null && allowedHours.contains(backendHours)) {
          selectedOpeningHours.value = backendHours;
        } else {
          selectedOpeningHours.value = null; // Will show placeholder
        }

        // Opening days
        if (data?.openingDays != null && data!.openingDays!.isNotEmpty) {
          selectedDays.value = data.openingDays!
              .split(',')
              .map((e) => e.trim().toLowerCase())
              .where((day) => daysOfWeek.contains(day))
              .toList();
        } else {
          selectedDays.clear();
        }

        // Location – assuming coordinates are [lng, lat]
        if (data?.location?.coordinates != null &&
            data!.location!.coordinates.length == 2) {
          shopLocation.value = LatLng(
            data.location!.coordinates[1], // latitude
            data.location!.coordinates[0], // longitude
          );
        }
      } else {
        Get.snackbar("Error", "Failed to fetch shop data.");
      }
    } catch (e) {
      Get.snackbar("Error", e.toString());
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