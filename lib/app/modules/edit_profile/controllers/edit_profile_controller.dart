import 'dart:convert';
import 'dart:io';
import 'package:expiry_deals/app/data/api.dart';
import 'package:expiry_deals/app/data/base_client.dart';
import 'package:expiry_deals/app/modules/profile/model/profile_model.dart';
import 'package:expiry_deals/common/app_constant/app_constant.dart';
import 'package:expiry_deals/common/helper/local_store.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;

class EditProfileController extends GetxController {
  var isLoading = false.obs;
  var profileData = ProfileModel().obs;
  var selectedImage = Rxn<File>();

  @override
  void onInit() {
    super.onInit();
    fetchProfileData();
  }

  // Fetch profile data from the server
  Future<void> fetchProfileData() async {
    String? token = LocalStorage.getData(key: AppConstant.token);
    if (token == null || token.isEmpty) {
      Get.snackbar("Error", "Authentication token is missing.");
      return;
    }

    var headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token',
    };

    try {
      var response = await BaseClient.handleResponse(
        await BaseClient.getRequest(api: Api.profile, headers: headers),
      );

      if (response != null && response['success'] == true) {
        profileData.value = ProfileModel.fromJson(response);
      } else {
        Get.snackbar("Error", "Failed to fetch profile data.");
      }
    } catch (e) {
      Get.snackbar("Error", e.toString());
    }
  }

  // Pick image from gallery or camera
  Future<void> pickImage(ImageSource source) async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: source, imageQuality: 85);

    if (pickedFile != null) {
      selectedImage.value = File(pickedFile.path);
    }
  }

  // Update Profile Data with Image
  Future<void> updateProfile(String name, String email, String phone, String address,  BuildContext context) async {
    String? token = LocalStorage.getData(key: AppConstant.token);
    if (token == null || token.isEmpty) {
      Get.snackbar("Error", "Authentication token is missing.");
      return;
    }

    var headers = {
      'Authorization': 'Bearer $token',
    };

    var body = {
      "status": "active",
      "name": name,
      "phoneNumber": phone,
      "address": address, // Update with actual address if needed
    };

    isLoading.value = true;

    try {
      var uri = Uri.parse(Api.updateProfile);
      var request = http.MultipartRequest('PATCH', uri)
        ..headers.addAll(headers)
        ..fields['data'] = jsonEncode(body); // Send the data as a JSON string

      // If an image is selected, add it to the request
      if (selectedImage.value != null) {
        request.files.add(await http.MultipartFile.fromPath(
          'profile', selectedImage.value!.path,
        ));
      }

      // Send the request
      var response = await request.send();

      print(response.statusCode);

      if (response.statusCode == 200) {
        // Successfully updated profile
       await fetchProfileData();
       Navigator.pop(context);
     //   Get.snackbar("Success", "Profile updated successfully.");
      } else {
       debugPrint("Api issue");
      }
    } catch (e) {
      debugPrint("Error: $e");

    } finally {
      isLoading.value = false;
    }
  }
}
