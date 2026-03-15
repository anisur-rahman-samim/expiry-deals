import 'dart:convert';
import 'dart:io';
import 'package:expiry_deals/app/data/api.dart';
import 'package:expiry_deals/app/modules/vendor_dashboard/vendor_product/controllers/vendor_product_controller.dart';
import 'package:expiry_deals/common/app_constant/app_constant.dart';
import 'package:expiry_deals/common/helper/local_store.dart';
import 'package:expiry_deals/app/modules/vendor_dashboard/vendor_product/controllers/category_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';

class VendorEditProductController extends GetxController {
  var isLoading = false.obs;
  var isFetching = true.obs;

  final selectedImage = Rxn<File>(); // New image (optional)
  final existingImageUrl = Rxn<String>(); // Show existing image

  final itemName = ''.obs;
  final itemDetails = ''.obs;
  final selectedCategoryId = ''.obs;
  final selectedCategoryName = ''.obs;
  final price = ''.obs;
  final quantity = ''.obs;
  final expiryDays = ''.obs;
  final discountPercent = ''.obs;
  final expiryDate = Rxn<DateTime>();

   final CategoryDataController categoryController = Get.put(CategoryDataController());
   final VendorProductController vendorProductController = Get.put(VendorProductController());



  /// 1. Fetch product details
  Future<void> fetchProductDetails(String productId) async {
    try {
      isFetching.value = true;

      String? token = LocalStorage.getData(key: AppConstant.token);
      if (token == null || token.isEmpty) {
        Get.snackbar('Error', 'Authentication token not found');
        return;
      }

      final uri = Uri.parse("${Api.baseUrl}/products/$productId"); // ← make sure this is correct

      final response = await http.get(
        uri,
        headers: {
          'Authorization': 'Bearer $token',
          'Accept': 'application/json',
        },
      );

      print("GET Status: ${response.statusCode}");
      print("GET Body: ${response.body}");

      if (response.statusCode == 200) {
        final json = jsonDecode(response.body);
        final product = json['data'] ?? json; // adjust based on your real response

        itemName.value = product['name']?.toString() ?? '';
        itemDetails.value = product['details']?.toString() ?? '';
        price.value = product['price']?.toString() ?? '';
        quantity.value = product['quantity']?.toString() ?? product['stock']?.toString() ?? '';
        discountPercent.value = product['discount']?.toString() ?? '0.0';

        selectedCategoryId.value = product['category']?['_id']?.toString() ?? product['category']?.toString() ?? '';
        selectedCategoryName.value = product['category']?['name']?.toString() ?? '';

        // Expiry date
        if (product['expiredAt'] != null) {
          expiryDate.value = DateTime.tryParse(product['expiredAt']);
          if (expiryDate.value != null) {
            final today = DateTime.now();
            expiryDays.value = expiryDate.value!.difference(today).inDays.toString();
          }
        }

        // Existing image
        if (product['images'] != null && product['images'].isNotEmpty) {
          existingImageUrl.value = product['images'][0]['url'] ?? product['images'][0];
        }
      } else {
        Get.snackbar('Error', 'Failed to load product (Status: ${response.statusCode})');
      }
    } catch (e) {
      print("Fetch error: $e");
      Get.snackbar('Error', 'Failed to load product: $e');
    } finally {
      isFetching.value = false;
    }
  }

  /// 2. Pick new image (optional)
  Future<void> pickImage() async {
    final picker = ImagePicker();
    final picked = await picker.pickImage(source: ImageSource.gallery, imageQuality: 85);

    if (picked != null) {
      selectedImage.value = File(picked.path);
      Get.snackbar('Success', 'Image selected');
    }
  }

  /// 3. Update product (PATCH)
  Future<void> updateProduct({required String productId}) async {
    if (!_validateFields()) return;

    try {
      isLoading.value = true;

      String? token = LocalStorage.getData(key: AppConstant.token);
      if (token == null || token.isEmpty) {
        Get.snackbar('Error', 'No authentication token');
        return;
      }

      final uri = Uri.parse("http://103.186.20.117:9000/api/v1/products/$productId");

      var request = http.MultipartRequest('PATCH', uri);
      request.headers['Authorization'] = 'Bearer $token';

      // Send product data as JSON in 'data' field (same as add)
      request.fields['data'] = _getProductDataJson();

      // Only send image if user selected a new one
      if (selectedImage.value != null) {
        request.files.add(
          await http.MultipartFile.fromPath(
            'images', // ← CHANGE THIS if your backend expects different name (e.g. 'images', 'photo')
            selectedImage.value!.path,
            filename: selectedImage.value!.path.split('/').last,
          ),
        );
      }

      print("PATCH Request URL: $uri");
      print("PATCH Fields: ${request.fields}");
      print("PATCH Files count: ${request.files.length}");

      final streamed = await request.send();
      final response = await http.Response.fromStream(streamed);

      isLoading.value = false;

      print("PATCH Status: ${response.statusCode}");
      print("PATCH Body: ${response.body}");

      if (response.statusCode == 200 || response.statusCode == 201) {
        await vendorProductController.fetchProducts();
        Get.back();
        Get.snackbar('Success', 'Product updated successfully', backgroundColor: Colors.green[100]);

        // Refresh list if you have a list controller
        // Get.find<VendorProductController>()?.fetchProducts();
      } else {
        String errorMsg = 'Update failed';
        try {
          final err = jsonDecode(response.body);
          errorMsg = err['message'] ?? err.toString();
        } catch (_) {
          errorMsg = response.body.isNotEmpty ? response.body : 'No response body';
        }
        Get.snackbar('Error ${response.statusCode}', errorMsg, backgroundColor: Colors.red[100]);
      }
    } catch (e) {
      isLoading.value = false;
      Get.snackbar('Exception', e.toString());
      print("PATCH Exception: $e");
    }
  }

  bool _validateFields() {
    if (itemName.value.trim().isEmpty) return _error('Product name required');
    if (itemDetails.value.trim().isEmpty) return _error('Details required');
    if (selectedCategoryId.value.isEmpty) return _error('Category required');
    if (!_isValidDouble(price.value, 'price')) return false;
    if (!_isValidInt(quantity.value, 'quantity')) return false;
    if (expiryDate.value == null) return _error('Expiry date required');
    return true;
  }

  bool _isValidDouble(String val, String field) {
    if (val.isEmpty || double.tryParse(val) == null || double.parse(val) <= 0) {
      Get.snackbar('Error', 'Enter valid $field');
      return false;
    }
    return true;
  }

  bool _isValidInt(String val, String field) {
    if (val.isEmpty || int.tryParse(val) == null || int.parse(val) <= 0) {
      Get.snackbar('Error', 'Enter valid $field');
      return false;
    }
    return true;
  }

  bool _error(String msg) {
    Get.snackbar('Error', msg);
    return false;
  }

  String _getProductDataJson() {
    return jsonEncode({
      "name": itemName.value.trim(),
      "details": itemDetails.value.trim(),
      "category": selectedCategoryId.value,
      "price": double.tryParse(price.value) ?? 0.0,
      "quantity": int.tryParse(quantity.value) ?? 0,
      "stock": int.tryParse(quantity.value) ?? 0,
      "expiredAt": expiryDate.value?.toIso8601String(),
      "discount": double.tryParse(discountPercent.value) ?? 0.0,
    });
  }
}