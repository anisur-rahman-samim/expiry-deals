import 'dart:convert';
import 'dart:io';
import 'package:get/get.dart';
import 'package:expiry_deals/app/data/api.dart';
import 'package:expiry_deals/app/data/base_client.dart';
import 'package:expiry_deals/common/app_constant/app_constant.dart';
import 'package:expiry_deals/common/helper/local_store.dart';
import 'package:expiry_deals/common/app_color/app_colors.dart';
import 'package:expiry_deals/app/modules/auth/views/login_view.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';


class VendorRequestController extends GetxController {
  var isLoading = false.obs;

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


  // Vendor request API call
  Future<void> submitVendorRequest({
    required String name,
    required String email,
    required String shopName,
    required File document,  // file input for document
    required List<double> locationCoordinates,
  }) async {
    try {
      isLoading(true);

      var token = LocalStorage.getData(key: AppConstant.token);
      if (token == null || token.isEmpty) {
        Get.snackbar('Error', 'Authentication token is missing.');
        return;
      }

      var headers = {
        'Authorization': 'Bearer $token',
      };

      // Form data for vendor request
      var body = {
        'name': name,
        'email': email,
        'shopName': shopName,
        'location': json.encode({
          'type': 'Point',
          'coordinates': locationCoordinates,
        }),
      };

      // Prepare multipart request
      var request = http.MultipartRequest('POST', Uri.parse(Api.vendorRequest));
      request.headers.addAll(headers);

      // Attach form fields to the request
      body.forEach((key, value) {
        request.fields[key] = value;
      });

      // Attach document file to the request
      request.files.add(await http.MultipartFile.fromPath('document', document.path));

      // Send request
      var response = await request.send();

      if (response.statusCode == 200) {
        Get.snackbar('Success', 'Vendor request submitted successfully!');
        Get.to(() => LoginView());  // Navigate to login view or anywhere else after success
      } else {
        Get.snackbar('Error', 'Failed to submit vendor request.');
      }
    } catch (e) {
      Get.snackbar('Error', 'An error occurred: $e');
    } finally {
      isLoading(false);
    }
  }
}
