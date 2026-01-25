import 'dart:convert';
import 'dart:io';
import 'package:expiry_deals/app/data/api.dart';
import 'package:expiry_deals/app/data/base_client.dart';
import 'package:expiry_deals/common/app_constant/app_constant.dart';
import 'package:expiry_deals/common/helper/local_store.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;

class VendorEditProductController extends GetxController {
  var isLoading = false.obs;
  var selectedImage = RxList<File>(); // To store selected images for update
  var itemName = ''.obs;
  var itemDetails = ''.obs;
  var selectedCategoryId = ''.obs;
  var selectedCategoryName = ''.obs;
  var price = ''.obs;
  var quantity = ''.obs;
  var expiryDays = ''.obs;
  var discountPercent = ''.obs;


  final expiryDate = Rxn<DateTime>();

  // Method to pick multiple images
  Future<void> pickImage() async {
    final picker = ImagePicker();
    final pickedFiles = await picker.pickMultiImage(imageQuality: 85);

    if (pickedFiles != null && pickedFiles.isNotEmpty) {
      selectedImage.clear(); // Clear previous images if any
      for (var pickedFile in pickedFiles) {
        selectedImage.add(File(pickedFile.path));
      }
    }
  }

  // Method to fetch product data for editing
  Future<void> fetchProductDetails(String id) async {
    try {
      isLoading(true);
      var headers = {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer ${LocalStorage.getData(key: AppConstant.token)}',
      };

      var response = await BaseClient.handleResponse(
        await BaseClient.getRequest(api: Api.productDetails(productId: id), headers: headers),
      );

      if (response != null && response['success'] == true) {
        var product = response['data'];
        itemName.value = product['name'] ?? '';
        itemDetails.value = product['details'] ?? '';
        selectedCategoryId.value = product['category'] ?? '';
        price.value = product['price'].toString();
        quantity.value = product['quantity'].toString();
        expiryDays.value = product['expiredAt'] ?? '';
        discountPercent.value = product['discount'].toString();

      } else {
        Get.snackbar("Error", "Failed to fetch product details.");
      }
    } catch (e) {
      Get.snackbar("Error", e.toString());
    } finally {
      isLoading(false);
    }
  }

  // Function to update product
  Future<void> updateProduct({required String productId}) async {
    if (_validateFields()) {
      try {
        // Prepare data for API request
        String? token = LocalStorage.getData(key: AppConstant.token);
        if (token == null || token.isEmpty) {
          throw 'No authentication token found';
        }

        var headers = {
          'Authorization': 'Bearer $token',
        };

        isLoading.value = true;

        var uri = Uri.parse(Api.updateProduct(productId: productId));
        var request = http.MultipartRequest('PUT', uri)
          ..headers.addAll(headers)
          ..fields['data'] = _getProductDataJson(); // Send updated product data as JSON string

        // Add images to the request
        for (var file in selectedImage) {
          request.files.add(await http.MultipartFile.fromPath('images', file.path));
        }

        // Send the request
        var response = await request.send();

        if (response.statusCode == 200) {
          Get.snackbar('Success', 'Product updated successfully');
          clearFields();  // Clear fields after successful submission
        } else {
          Get.snackbar('Error', 'Failed to update product. Please try again.');
        }
      } catch (e) {
        isLoading.value = false;
        Get.snackbar('Error', e.toString());
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
    if (discountPercent.value.isEmpty || double.tryParse(discountPercent.value) == null) {
      Get.snackbar('Error', 'Please enter a valid discount percentage.');
      return false;
    }
    if (selectedImage.isEmpty) {
      Get.snackbar('Error', 'Please pick at least one image for the product.');
      return false;
    }
    return true;
  }

  // Helper function to prepare the product data JSON for update
  String _getProductDataJson() {
    final productData = {
      "name": itemName.value,
      "details": itemDetails.value,
      "category": selectedCategoryId.value,
      "price": price.value,
      "quantity": quantity.value,
      "expiredAt": expiryDate.value?.toIso8601String(),
      "discount": discountPercent.value,
      "stock": quantity.value,
    };

    return jsonEncode(productData);
  }

  // Clear fields after successful product update
  void clearFields() {
    itemName.value = '';
    itemDetails.value = '';
    selectedCategoryId.value = '';
    selectedCategoryName.value = '';
    price.value = '';
    quantity.value = '';
    expiryDays.value = '';
    discountPercent.value = '';
    selectedImage.clear();
  }
}
