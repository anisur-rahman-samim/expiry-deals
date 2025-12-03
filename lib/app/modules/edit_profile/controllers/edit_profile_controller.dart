import 'dart:io';

import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

class EditProfileController extends GetxController {
  // Rx variable to store the selected image file
  Rx<File?> selectedImage = Rx<File?>(null);

  // Instance of ImagePicker
  final ImagePicker _picker = ImagePicker();

  // Function to pick an image from gallery or camera
  Future<void> pickImage(ImageSource source) async {
    try {
      final XFile? image = await _picker.pickImage(source: source);
      if (image != null) {
        selectedImage.value = File(image.path);
      } else {
        Get.snackbar('No Image Selected', 'Please select an image.');
      }
    } catch (e) {
      Get.snackbar('Error', 'Failed to pick image: $e');
    }
  }
}
