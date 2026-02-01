import 'dart:convert';
import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:expiry_deals/app/data/api.dart';
import 'package:expiry_deals/common/helper/local_store.dart';
import 'package:expiry_deals/common/app_constant/app_constant.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../views/login_view.dart';  // For location selection

class VendorRequestController extends GetxController {
  var isLoading = false.obs;
  var locationCoordinates = Rx<List<double>>([0.0, 0.0]); // Default to 0,0
  var documentFile = Rx<File?>(null); // Observable for selected document file

  // Method to pick a document (image)
  Future<void> pickDocument() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      documentFile.value = File(pickedFile.path);  // Update documentFile
    } else {
      documentFile.value = null;
    }
  }

  // Method to select location (using Google Maps)
  Future<void> selectLocation(LatLng selectedLocation) async {
    // Here, we update the location coordinates to the selected point from the map
    locationCoordinates.value = [selectedLocation.longitude, selectedLocation.latitude];
  }

  // Vendor request API call
  Future<void> submitVendorRequest({
    required String name,
    required String email,
    required String shopName,
    required File document,
    required List<double> locationCoordinates,
  }) async {
    try {
      isLoading(true);  // Set loading state to true

      // var token = LocalStorage.getData(key: AppConstant.token);
      // if (token == null || token.isEmpty) {
      //   Get.snackbar('Error', 'Authentication token is missing.');
      //   return;
      // }
      //
      var headers = {
        'Content-Type': 'application/json',
      };
      debugPrint("this is location: ${locationCoordinates}");

      var body = {
        'name': name,
        'email': email,
        'shopName': shopName,
        'location': json.encode({
          'type': 'Point',
          'coordinates': locationCoordinates,
        }),
      };

      // var request = http.MultipartRequest('POST', Uri.parse(Api.vendorRequest));
      // request.headers.addAll(headers);
      var request = http.MultipartRequest('POST', Uri.parse(Api.vendorRequest))
        ..headers.addAll(headers)
        ..fields['data'] = jsonEncode(body);

      // Add body fields
      body.forEach((key, value) {
        request.fields[key] = value;
      });

      // Add document if selected
      if (document.existsSync()) {
        request.files.add(await http.MultipartFile.fromPath('document', document.path));
      } else {
        Get.snackbar('Error', 'Please upload a document.');
        return;
      }

      // Sending the request
      var response = await request.send();

      if (response.statusCode == 201 || response.statusCode == 200) {
        Get.snackbar('Success', 'Vendor request submitted successfully!');
        Get.to(() => LoginView());  // Navigate after success
      } else {
        Get.snackbar('Error', 'Failed to submit vendor request.');
      }
    } catch (e) {
      Get.snackbar('Error', 'An error occurred: $e');
    } finally {
      isLoading(false);  // Set loading state to false after completion
    }
  }
}
