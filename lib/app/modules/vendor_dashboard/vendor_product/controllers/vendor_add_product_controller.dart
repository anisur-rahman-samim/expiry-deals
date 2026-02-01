import 'dart:convert';
import 'dart:io';
import 'package:expiry_deals/app/modules/vendor_dashboard/vendor_product/controllers/category_controller.dart';
import 'package:expiry_deals/app/modules/vendor_dashboard/vendor_product/controllers/vendor_product_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:expiry_deals/app/data/api.dart';
import 'package:expiry_deals/common/helper/local_store.dart';
import 'package:expiry_deals/common/app_constant/app_constant.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;

class VendorAddProductController extends GetxController {
  var isLoading = false.obs;
  final VendorProductController vendorProductController = Get.put(
    VendorProductController(),
  );
  final selectedImage = Rxn<File>(); // ← Only one image (Rxn = nullable observable)

  final itemName = ''.obs;
  final itemDetails = ''.obs;
  final selectedCategoryId = ''.obs;
  final selectedCategoryName = ''.obs;
  final price = ''.obs;
  final quantity = ''.obs;
  final expiryDays = ''.obs;
  final discountPercent = ''.obs;

  final expiryDate = Rxn<DateTime>();

  late final CategoryDataController categoryController;

  @override
  void onInit() {
    super.onInit();
    categoryController = Get.put(CategoryDataController());

    // Auto select first category if none selected
    ever(categoryController.categories, (_) {
      if (categoryController.categories.isNotEmpty && selectedCategoryId.value.isEmpty) {
        final first = categoryController.categories.first;
        selectedCategoryId.value = first.id ?? '';
        selectedCategoryName.value = first.name ?? '';
      }
    });
  }

  /// Pick only ONE image
  Future<void> pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery, imageQuality: 85);

    if (pickedFile != null) {
      selectedImage.value = File(pickedFile.path);
      Get.snackbar('Success', 'Image selected', duration: const Duration(seconds: 2));
    }
  }

  Future<void> addProduct() async {
    if (!_validateFields()) return;

    try {
      isLoading.value = true;

      String? token = LocalStorage.getData(key: AppConstant.token);
      if (token == null || token.isEmpty) {
        Get.snackbar('Error', 'Authentication token not found');
        return;
      }

      var uri = Uri.parse(Api.addProduct);

      var request = http.MultipartRequest('POST', uri);

      // Headers — Do NOT set 'Content-Type' manually for MultipartRequest
      request.headers['Authorization'] = 'Bearer $token';

      // Add product data as JSON string in 'data' field
      request.fields['data'] = _getProductDataJson();

      // Add single image (most APIs expect 'image' for single file)
      if (selectedImage.value != null) {
        request.files.add(
          await http.MultipartFile.fromPath(
            'images', // ← try 'image' or 'images' — depends on backend
            selectedImage.value!.path,
            filename: selectedImage.value!.path.split('/').last,
          ),
        );
      }

      // Send request
      var streamedResponse = await request.send();
      var response = await http.Response.fromStream(streamedResponse);

      isLoading.value = false;

      if (response.statusCode == 200 || response.statusCode == 201) {
        await vendorProductController.fetchProducts();
        clearFields();
        Get.back();
        Get.snackbar('Success', 'Product added successfully!', backgroundColor: Colors.green[100]);

      } else {
        try {
          final errorBody = jsonDecode(response.body);
          Get.snackbar(
            'Error ${response.statusCode}',
            errorBody['message'] ?? 'Failed to add product',
            backgroundColor: Colors.red[100],
          );
        } catch (_) {
          Get.snackbar('Error ${response.statusCode}', response.body.isNotEmpty ? response.body : 'No response body');
        }
        print("Server response: ${response.statusCode} - ${response.body}");
      }
    } catch (e) {
      isLoading.value = false;
      Get.snackbar('Exception', e.toString());
      print("Exception during add product: $e");
    }
  }

  bool _validateFields() {
    if (itemName.value.trim().isEmpty) {
      Get.snackbar('Error', 'Product name is required');
      return false;
    }
    if (itemDetails.value.trim().isEmpty) {
      Get.snackbar('Error', 'Product details are required');
      return false;
    }
    if (selectedCategoryId.value.isEmpty) {
      Get.snackbar('Error', 'Please select a category');
      return false;
    }
    if (price.value.isEmpty || double.tryParse(price.value) == null || double.parse(price.value) <= 0) {
      Get.snackbar('Error', 'Enter a valid price');
      return false;
    }
    if (quantity.value.isEmpty || int.tryParse(quantity.value) == null || int.parse(quantity.value) <= 0) {
      Get.snackbar('Error', 'Enter a valid quantity');
      return false;
    }
    if (expiryDate.value == null) {
      Get.snackbar('Error', 'Please select expiry date');
      return false;
    }
    if (selectedImage.value == null) {
      Get.snackbar('Error', 'Product image is required');
      return false;
    }
    return true;
  }

  String _getProductDataJson() {
    final data = {
      "name": itemName.value.trim(),
      "details": itemDetails.value.trim(),
      "category": selectedCategoryId.value,
      "price": double.tryParse(price.value) ?? 0.0,
      "quantity": int.tryParse(quantity.value) ?? 0,
      "stock": int.tryParse(quantity.value) ?? 0,
      "expiredAt": expiryDate.value?.toIso8601String(),
      "discount": double.tryParse(discountPercent.value) ?? 0.0,
    };
    return jsonEncode(data);
  }

  void clearFields() {
    itemName.value = '';
    itemDetails.value = '';
    selectedCategoryId.value = '';
    selectedCategoryName.value = '';
    price.value = '';
    quantity.value = '';
    expiryDays.value = '';
    discountPercent.value = '';
    expiryDate.value = null;
    selectedImage.value = null;
  }
}