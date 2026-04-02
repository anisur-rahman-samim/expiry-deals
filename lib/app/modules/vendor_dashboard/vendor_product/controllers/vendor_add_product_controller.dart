import 'dart:convert';
import 'dart:io';
import 'package:expiry_deals/app/modules/vendor_dashboard/vendor_product/controllers/category_controller.dart';
import 'package:expiry_deals/app/modules/vendor_dashboard/vendor_product/controllers/vendor_product_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:expiry_deals/app/data/api.dart';
import 'package:expiry_deals/common/helper/local_store.dart';
import 'package:expiry_deals/common/app_constant/app_constant.dart';
import 'package:expiry_deals/common/app_color/app_colors.dart';
import 'package:expiry_deals/common/app_text_style/styles.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;

/// Backend accepts up to 10 files under field name `images` (see products.route.ts).
class VendorAddProductController extends GetxController {
  var isLoading = false.obs;
  final VendorProductController vendorProductController = Get.put(
    VendorProductController(),
  );

  static const int maxImages = 10;

  /// One or more photos — marketplace listings look better with several angles.
  final selectedImages = <File>[].obs;

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

    ever(categoryController.categories, (_) {
      if (categoryController.categories.isNotEmpty && selectedCategoryId.value.isEmpty) {
        final first = categoryController.categories.first;
        selectedCategoryId.value = first.id ?? '';
        selectedCategoryName.value = first.name ?? '';
      }
    });
  }

  /// Bottom sheet: camera vs gallery (multi-select on gallery).
  void showImageSourcePicker() {
    Get.bottomSheet<void>(
      SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text('Add photos', style: h2.copyWith(fontSize: 18)),
              const SizedBox(height: 8),
              Text(
                'Up to $maxImages images. More photos help buyers trust your listing.',
                style: h4.copyWith(color: AppColors.hintColor, fontSize: 13),
              ),
              const SizedBox(height: 16),
              ListTile(
                contentPadding: EdgeInsets.zero,
                leading: const Icon(Icons.photo_camera_outlined, color: AppColors.mainColor),
                title: const Text('Take photo'),
                subtitle: const Text('Use camera'),
                onTap: () {
                  Get.back<void>();
                  pickFromCamera();
                },
              ),
              ListTile(
                contentPadding: EdgeInsets.zero,
                leading: const Icon(Icons.photo_library_outlined, color: AppColors.mainColor),
                title: const Text('Choose from gallery'),
                subtitle: const Text('Select one or more'),
                onTap: () {
                  Get.back<void>();
                  pickFromGallery();
                },
              ),
              const SizedBox(height: 8),
              TextButton(
                onPressed: () => Get.back<void>(),
                child: Text('Cancel', style: h4.copyWith(color: AppColors.hintColor)),
              ),
            ],
          ),
        ),
      ),
      backgroundColor: AppColors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
    );
  }

  Future<void> pickFromCamera() async {
    if (selectedImages.length >= maxImages) {
      Get.snackbar('Limit', 'You can add up to $maxImages images.');
      return;
    }
    final picker = ImagePicker();
    final picked = await picker.pickImage(
      source: ImageSource.camera,
      imageQuality: 85,
    );
    if (picked != null) {
      selectedImages.add(File(picked.path));
      Get.snackbar('Added', 'Photo added (${selectedImages.length}/$maxImages)');
    }
  }

  Future<void> pickFromGallery() async {
    final picker = ImagePicker();
    final remaining = maxImages - selectedImages.length;
    if (remaining <= 0) {
      Get.snackbar('Limit', 'You can add up to $maxImages images.');
      return;
    }
    final batch = await picker.pickMultiImage(imageQuality: 85, limit: remaining);
    if (batch.isEmpty) return;
    for (final x in batch) {
      if (selectedImages.length >= maxImages) break;
      selectedImages.add(File(x.path));
    }
    Get.snackbar('Added', '${batch.length} photo(s) added (${selectedImages.length}/$maxImages)');
  }

  void removeImageAt(int index) {
    if (index < 0 || index >= selectedImages.length) return;
    selectedImages.removeAt(index);
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
      request.headers['Authorization'] = 'Bearer $token';
      request.fields['data'] = _getProductDataJson();

      for (final file in selectedImages) {
        request.files.add(
          await http.MultipartFile.fromPath(
            'images',
            file.path,
            filename: file.path.split('/').last,
          ),
        );
      }

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
          Get.snackbar(
            'Error ${response.statusCode}',
            response.body.isNotEmpty ? response.body : 'No response body',
          );
        }
      }
    } catch (e) {
      isLoading.value = false;
      Get.snackbar('Exception', e.toString());
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
    if (selectedImages.isEmpty) {
      Get.snackbar('Error', 'Add at least one product photo');
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
    selectedImages.clear();
  }
}
