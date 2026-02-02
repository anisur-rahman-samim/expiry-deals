import 'dart:convert';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';

import '../../../data/api.dart';
import '../../auth/views/login_view.dart'; // adjust path

class VendorRequestController extends GetxController {
  var isLoading = false.obs;

  var longitude = 0.0.obs; // longitude (x in GeoJSON)
  var latitude = 0.0.obs;  // latitude (y in GeoJSON)

  var documentFile = Rx<File?>(null);

  Future<void> pickDocument() async {
    try {
      final picker = ImagePicker();
      final pickedFile = await picker.pickImage(source: ImageSource.gallery);

      if (pickedFile != null) {
        documentFile.value = File(pickedFile.path);
        Get.snackbar('Success', 'Document selected');
      }
    } catch (e) {
      Get.snackbar('Error', 'Failed to pick document: $e');
    }
  }

  void selectLocation(LatLng position) {
    longitude.value = position.longitude;
    latitude.value  = position.latitude;
    debugPrint("Location selected → Lat: ${latitude.value}, Lng: ${longitude.value}");
  }

  Future<void> submitVendorRequest({
    required String name,
    required String email,
    required String shopName,
  }) async {
    if (name.trim().isEmpty || email.trim().isEmpty || shopName.trim().isEmpty) {
      Get.snackbar('Error', 'Please fill all required fields');
      return;
    }

    if (documentFile.value == null) {
      Get.snackbar('Error', 'Please select a document');
      return;
    }

    if (latitude.value == 0.0 || longitude.value == 0.0) {
      Get.snackbar('Error', 'Please select a location on the map');
      return;
    }

    isLoading.value = true;

    try {
      final uri = Uri.parse(Api.vendorRequest);
      var request = http.MultipartRequest('POST', uri);

      request.fields['name']     = name.trim();
      request.fields['email']    = email.trim();
      request.fields['shopName'] = shopName.trim();

      // // Nested format – most common & reliable for multipart → GeoJSON Point
      request.fields['location[type]'] = 'Point';
      request.fields['location[coordinates][0]'] = longitude.value.toStringAsFixed(6); // lng first
      request.fields['location[coordinates][1]'] = latitude.value.toStringAsFixed(6);  // lat second

      // ──────────────────────────────────────────────────────────────
      // If backend wants stringified JSON instead → use this (uncomment):
      // request.fields['location'] = jsonEncode({
      //   'type': 'Point',
      //   'coordinates': [longitude.value, latitude.value],
      // });
      // ──────────────────────────────────────────────────────────────

      final file = documentFile.value!;
      if (await file.exists()) {
        final fileName = file.path.split(Platform.pathSeparator).last;
        request.files.add(
          await http.MultipartFile.fromPath(
            'document',
            file.path,
            filename: fileName,
          ),
        );
      } else {
        Get.snackbar('Error', 'Selected document file not found');
        return;
      }

      debugPrint('→ Sending to: $uri');
      debugPrint('Fields: ${request.fields}');
      debugPrint('Files: ${request.files.map((f) => f.filename).toList()}');

      final streamedResponse = await request.send();
      final responseBody = await streamedResponse.stream.bytesToString();

      if (streamedResponse.statusCode == 200 || streamedResponse.statusCode == 201) {
        Get.snackbar('Success', 'Vendor request submitted successfully!');
        Get.off(() => LoginView());
      } else {
        debugPrint('Server error ${streamedResponse.statusCode}: $responseBody');
        Get.snackbar(
          'Error',
          'Failed (${streamedResponse.statusCode})\n${responseBody.substring(0, responseBody.length.clamp(0, 150))}...',
        );
      }
    } catch (e, stackTrace) {
      debugPrint('Submit exception: $e\n$stackTrace');
      Get.snackbar('Error', 'Network or unexpected error');
    } finally {
      isLoading.value = false;
    }
  }

  @override
  void onClose() {
    documentFile.value?.deleteSync(); // optional – be careful in production
    super.onClose();
  }
}