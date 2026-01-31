import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:image_picker/image_picker.dart';

class EditShopController extends GetxController {
  final nameController = TextEditingController();
  final descController = TextEditingController();
  final addressController = TextEditingController();

  final Rx<String> selectedOpeningHours = '9:00 AM - 10:00 PM'.obs;
  final RxList<String> selectedDays = <String>[].obs;

  final Rx<File?> bannerImage = Rx<File?>(null);
  final Rx<File?> logoImage = Rx<File?>(null);

  final Rx<LatLng> shopLocation = const LatLng(40.73061, -73.935242).obs;
  GoogleMapController? mapController;

  final daysOfWeek = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];

  @override
  void onInit() {
    super.onInit();
    nameController.text = "Sunrise Boutique";
    descController.text =
        "A cozy boutique offering handmade crafts and local art.";
    addressController.text = "123 Market Street, Springfield";
    selectedOpeningHours.value = "9:00 AM - 10:00 PM";
    selectedDays.value = ["Sat", "Sun"];
  }

  Future<void> pickImage(bool isBanner) async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      final file = File(pickedFile.path);
      if (isBanner)
        bannerImage.value = file;
      else
        logoImage.value = file;
    }
  }

  void onMapCreated(GoogleMapController controller) {
    mapController = controller;
  }

  void updateLocation(LatLng pos) {
    shopLocation.value = pos;
  }

  void saveShop() {
    final data = {
      "name": nameController.text.trim(),
      "description": descController.text.trim(),
      "address": addressController.text.trim(),
      "openingHours": selectedOpeningHours.value,
      "openingDays": selectedDays.toList(),
      "location": {
        "type": "Point",
        "coordinates": [
          shopLocation.value.longitude,
          shopLocation.value.latitude,
        ],
      },
      // You can add banner & logo paths/URLs here later
      "banner": bannerImage.value?.path ?? "no banner",
      "logo": logoImage.value?.path ?? "no logo",
    };

    // ── Print all data when save is clicked ───────────────────────────
    print("═══════════════════════════════════════════════");
    print("          SHOP UPDATE DATA (SAVED)");
    print("═══════════════════════════════════════════════");
    data.forEach((key, value) {
      print("$key: $value");
    });
    print("═══════════════════════════════════════════════\n");

    Get.snackbar(
      "Saved",
      "Shop data printed to console",
      backgroundColor: Colors.green.shade700,
      colorText: Colors.white,
      duration: const Duration(seconds: 3),
    );

    // Get.back(); // uncomment if you want to close screen after save
  }

  @override
  void onClose() {
    nameController.dispose();
    descController.dispose();
    addressController.dispose();
    mapController?.dispose();
    super.onClose();
  }
}
