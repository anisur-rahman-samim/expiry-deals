import 'dart:convert';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';

import '../../../data/api.dart';
import '../../auth/views/login_view.dart'; // adjust path if needed

class VendorRequestController extends GetxController {
  var isLoading = false.obs;
  var locationCoordinates = Rx<List<double>>([0.0, 0.0]); // [longitude, latitude] for GeoJSON
  var documentFile = Rx<File?>(null);

  Future<void> pickDocument() async {
    try {
      final picker = ImagePicker();
      final pickedFile = await picker.pickImage(source: ImageSource.gallery);

      if (pickedFile != null) {
        documentFile.value = File(pickedFile.path);
      }
    } catch (e) {
      Get.snackbar("Error", "Failed to pick document: $e");
    }
  }

  void selectLocation(LatLng position) {
    // GeoJSON Point = [longitude, latitude]
    locationCoordinates.value = [position.longitude, position.latitude];
    debugPrint("Location selected: ${position.latitude}, ${position.longitude}");
  }

  Future<void> submitVendorRequest({
    required String name,
    required String email,
    required String shopName,
    required File document,
    required List<double> locationCoordinates,
  }) async {
    isLoading.value = true;

    try {
      var request = http.MultipartRequest('POST', Uri.parse(Api.vendorRequest));

      // Prepare JSON data part
      final data = {
        'name': name,
        'email': email,
        'shopName': shopName,
        'location': jsonEncode({
          'type': 'Point',
          'coordinates': locationCoordinates, // [lng, lat]
        }),
      };

      // Add all fields
      data.forEach((key, value) {
        request.fields[key] = value;
      });

      // Add file
      if (await document.exists()) {
        request.files.add(await http.MultipartFile.fromPath(
          'document',
          document.path,
          filename: document.path.split('/').last,
        ));
      } else {
        Get.snackbar("Error", "Document file not found");
        return;
      }

      final response = await request.send();

      final responseBody = await response.stream.bytesToString();

      if (response.statusCode == 200 || response.statusCode == 201) {
        Get.snackbar("Success", "Vendor request submitted successfully!");
        Get.off(() => LoginView());
      } else {
        Get.snackbar(
          "Error",
          "Failed to submit request (${response.statusCode})\n${responseBody.substring(0, 200)}...",
        );
        debugPrint("Server response: $responseBody");
      }
    } catch (e, stack) {
      Get.snackbar("Error", "Something went wrong: $e");
      debugPrint("Submit error: $e\n$stack");
    } finally {
      isLoading.value = false;
    }
  }
}