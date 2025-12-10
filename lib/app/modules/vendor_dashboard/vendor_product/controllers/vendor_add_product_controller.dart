// vendor_add_product_controller.dart

import 'dart:io';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

class VendorAddProductController extends GetxController {
  var selectedImage = Rxn<File>();
  var itemName = ''.obs;
  var itemDetails = ''.obs;
  var selectedCategory = 'Fashion'.obs; // default value
  var price = ''.obs;
  var quantity = ''.obs;
  var expiryDays = ''.obs;
  var discountPercent = ''.obs;

  // Fixed: No duplicates + more realistic categories
  final List<String> categories = [
    'Fashion',
    'Electronics',
    'Home & Living',
    'Beauty & Health',
    'Sports & Fitness',
    'Toys & Games',
    'Food & Grocery',
    'Books & Stationery',
    'Jewelry',
    'Shoes & Bags',
  ];

  Future<void> pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery, imageQuality: 85);

    if (pickedFile != null) {
      selectedImage.value = File(pickedFile.path);
    }
  }

  // void saveProduct(BuildContext context) {
  //   if (itemName.value.isEmpty || price.value.isEmpty || selectedImage.value == null) {
  //     Get.snackbar('Error', 'Please fill all required fields and upload an image',
  //         backgroundColor: AppColors.red.withValues(alpha: 0.2), colorText: AppColors.red);
  //     return;
  //   }
  //
  //   // Your save logic here (API call, etc.)
  //   Get.snackbar('Success', 'Product added successfully!',
  //       backgroundColor: AppColors.green.withValues(alpha: 0.2), colorText: AppColors.green);
  //   Navigator.pop(context);
  // }
}