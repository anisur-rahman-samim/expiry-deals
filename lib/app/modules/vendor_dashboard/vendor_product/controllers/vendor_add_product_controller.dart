import 'dart:convert';
import 'dart:io';
import 'package:expiry_deals/app/modules/vendor_dashboard/vendor_product/controllers/category_controller.dart';
import 'package:get/get.dart';
import 'package:expiry_deals/app/data/api.dart';
import 'package:expiry_deals/app/data/base_client.dart';
import 'package:expiry_deals/common/helper/local_store.dart';
import 'package:expiry_deals/common/app_constant/app_constant.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'package:expiry_deals/app/modules/vendor_dashboard/vendor_product/model/category_model.dart';

class VendorAddProductController extends GetxController {
  var isLoading = false.obs;
  final selectedImage = RxList<File>(); // To store selected images
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

  Future<void> pickImage() async {
    final picker = ImagePicker();
    final pickedFiles = await picker.pickMultiImage(imageQuality: 85);

    if (pickedFiles != null && pickedFiles.isNotEmpty) {
      selectedImage.clear();  // Clear previous images if any
      for (var pickedFile in pickedFiles) {
        selectedImage.add(File(pickedFile.path));
      }
    }
  }

  // Function to add product with image upload
  Future<void> addProduct() async {
    if (_validateFields()) {
      try {
        // Prepare data for API request
        String? token = LocalStorage.getData(key: AppConstant.token);
        if (token == null || token.isEmpty) {
          throw 'No authentication token found';
        }

        var headers = {
           'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        };

        isLoading.value = true;

        var uri = Uri.parse(Api.addProduct);
        var request = http.MultipartRequest('POST', uri)
          ..headers.addAll(headers)
          ..fields['data'] = _getProductDataJson(); // Pass product data as JSON string

        // Add images to the request
        for (var file in selectedImage) {
          request.files.add(await http.MultipartFile.fromPath('images', file.path));
        }

        // Send the request
        var response = await request.send();

        if (response.statusCode == 200) {
        //  Get.snackbar('Success', 'Product added successfully');
          print("Product added successfully");
          // Clear fields after successful submission
          clearFields();
          isLoading.value = false;
        } else {
        //  Get.snackbar('Error', 'Failed to add product. Please try again.');
        }
      } catch (e) {
        isLoading.value = false;
        print(e);
      //  Get.snackbar('Error', e.toString());
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
    if (selectedImage.isEmpty) {
      Get.snackbar('Error', 'Please pick at least one image for the product.');
      return false;
    }
    return true;
  }

  // Helper function to prepare the product data JSON
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

  // Clear fields after successful product creation
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
