import 'dart:io';
import 'package:expiry_deals/app/modules/vendor_dashboard/vendor_product/controllers/category_controller.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

class VendorAddProductController extends GetxController {
  final selectedImage = Rxn<File>();
  final itemName = ''.obs;
  final itemDetails = ''.obs;

  // ✅ store category id (best)
  final selectedCategoryId = ''.obs;
  final selectedCategoryName = ''.obs;

  final price = ''.obs;
  final quantity = ''.obs;
  final expiryDays = ''.obs;
  final discountPercent = ''.obs;

  // you already use these in view
  final expiryDate = Rxn<DateTime>();

  late final CategoryController categoryController;

  @override
  void onInit() {
    super.onInit();

    // ✅ One shared instance
    categoryController = Get.put(CategoryController());

    // ✅ when categories load, set default automatically
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
    final pickedFile = await picker.pickImage(source: ImageSource.gallery, imageQuality: 85);
    if (pickedFile != null) {
      selectedImage.value = File(pickedFile.path);
    }
  }
}
