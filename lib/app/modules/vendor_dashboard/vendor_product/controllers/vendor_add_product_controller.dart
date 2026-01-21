import 'dart:io';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

class VendorAddProductController extends GetxController {
  var selectedImage = Rxn<File>();  // Used to store the selected image file
  var itemName = ''.obs;  // Product name
  var itemDetails = ''.obs;  // Product details
  var selectedCategory = 'Fashion'.obs;  // Default product category
  var price = ''.obs;  // Product price
  var quantity = ''.obs;  // Product stock quantity
  var expiryDays = ''.obs;  // Product expiry in days
  var discountPercent = ''.obs;  // Product discount percentage
  Rx<DateTime?> expiryDate = Rx<DateTime?>(null);



  // Categories available for the product
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

  // Function to pick an image from the gallery
  Future<void> pickImage() async {
    final picker = ImagePicker();

    try {
      // Pick an image from the gallery
      final pickedFile = await picker.pickImage(
        source: ImageSource.gallery,
        imageQuality: 85,  // Set image quality to 85
      );

      if (pickedFile != null) {
        selectedImage.value = File(pickedFile.path);
      } else {
        // User canceled image selection
        Get.snackbar('No Image', 'You did not select an image.');
      }
    } catch (e) {
      // Catch any errors and show them as snackbars
      Get.snackbar('Error', 'Failed to pick image: $e');
    }
  }

  // Method to add product to the backend or local storage
  Future<void> addProduct() async {
    if (_validateFields()) {
      // Process to add the product (example: send data to backend)
      try {
        // Add product logic here (e.g., API call)
        // For now, we just show a snackbar
        Get.snackbar('Success', 'Product Added Successfully!', snackPosition: SnackPosition.BOTTOM);
      } catch (e) {
        // Show error if something goes wrong
        Get.snackbar('Error', 'Failed to add product: $e');
      }
    }
  }

  // Helper function to validate fields
  bool _validateFields() {
    if (itemName.value.isEmpty) {
      Get.snackbar('Error', 'Please enter a product name.');
      return false;
    }
    if (itemDetails.value.isEmpty) {
      Get.snackbar('Error', 'Please enter product details.');
      return false;
    }
    if (price.value.isEmpty || double.tryParse(price.value) == null) {
      Get.snackbar('Error', 'Please enter a valid price.');
      return false;
    }
    if (quantity.value.isEmpty || int.tryParse(quantity.value) == null) {
      Get.snackbar('Error', 'Please enter a valid quantity.');
      return false;
    }
    if (expiryDays.value.isEmpty || int.tryParse(expiryDays.value) == null) {
      Get.snackbar('Error', 'Please enter a valid expiry period.');
      return false;
    }
    if (discountPercent.value.isEmpty || double.tryParse(discountPercent.value) == null) {
      Get.snackbar('Error', 'Please enter a valid discount percentage.');
      return false;
    }
    if (selectedImage.value == null) {
      Get.snackbar('Error', 'Please pick an image for the product.');
      return false;
    }
    return true;
  }
}
