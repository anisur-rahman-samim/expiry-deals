import 'dart:io';
import 'package:expiry_deals/app/modules/vendor_dashboard/vendor_product/controllers/vendor_edit_product_controller.dart';
import 'package:expiry_deals/common/app_color/app_colors.dart';
import 'package:expiry_deals/common/size_box/custom_sizebox.dart';
import 'package:expiry_deals/common/widgets/custom_button.dart';
import 'package:expiry_deals/common/widgets/custom_loader.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class VendorEditProductView extends GetView<VendorEditProductController> {
  final String productId;

  // Controllers — created once
  final TextEditingController nameController = TextEditingController();
  final TextEditingController detailsController = TextEditingController();
  final TextEditingController priceController = TextEditingController();
  final TextEditingController quantityController = TextEditingController();
  final TextEditingController discountController = TextEditingController();
  final TextEditingController expiryDateController = TextEditingController();
  final TextEditingController expiryDaysController = TextEditingController();

  // Flag to prevent onChanged updates before data is loaded
  final isDataLoaded = false.obs;

  VendorEditProductView({super.key, required this.productId});

  @override
  Widget build(BuildContext context) {
    Get.put(VendorEditProductController());

    // Fetch once
    controller.fetchProductDetails(productId);

    // When fetch completes → fill fields & allow editing
    ever(controller.isFetching, (fetching) {
      if (!fetching) {
        // Set initial values only once after fetch
        nameController.text = controller.itemName.value;
        detailsController.text = controller.itemDetails.value;
        priceController.text = controller.price.value;
        quantityController.text = controller.quantity.value;
        discountController.text = controller.discountPercent.value;
        expiryDaysController.text = controller.expiryDays.value;

        if (controller.expiryDate.value != null) {
          expiryDateController.text = DateFormat('dd MMM yyyy').format(controller.expiryDate.value!);
        }

        // Now allow typing to update controller values
        isDataLoaded.value = true;
      }
    });

    return Scaffold(
      backgroundColor: AppColors.bgColor,
      appBar: AppBar(
        title: const Text('Edit Product'),
        centerTitle: true,
        backgroundColor: AppColors.mainColor,
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: Obx(() {
        if (controller.isFetching.value) {
          return const Center(child: CircularProgressIndicator());
        }

        return SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Product Image',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: AppColors.textColor),
              ),
              sh10,

              Obx(() => GestureDetector(
                onTap: controller.pickImage,
                child: Container(
                  height: 180,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: AppColors.grayLight, width: 2),
                    image: controller.selectedImage.value != null
                        ? DecorationImage(
                      image: FileImage(controller.selectedImage.value!),
                      fit: BoxFit.cover,
                    )
                        : (controller.existingImageUrl.value != null
                        ? DecorationImage(
                      image: NetworkImage(controller.existingImageUrl.value!),
                      fit: BoxFit.cover,
                    )
                        : null),
                  ),
                  child: controller.selectedImage.value == null && controller.existingImageUrl.value == null
                      ? Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.add_a_photo_outlined, size: 48, color: AppColors.mainColor.withOpacity(0.6)),
                      sh10,
                      Text('Change Image', style: TextStyle(color: AppColors.mainColor, fontWeight: FontWeight.w600)),
                      Text('Tap to select new image', style: TextStyle(color: AppColors.hintColor)),
                    ],
                  )
                      : null,
                ),
              )),

              sh20,

              _buildLabel('Item Name'),
              _inputField(
                controller: nameController,
                hint: 'e.g., Wireless Bluetooth Earbuds',
                onChanged: isDataLoaded.value ? (v) => controller.itemName.value = v : null,
              ),

              sh16,

              _buildLabel('Item Details'),
              _inputField(
                controller: detailsController,
                hint: 'Describe your product...',
                maxLines: 3,
                onChanged: isDataLoaded.value ? (v) => controller.itemDetails.value = v : null,
              ),

              sh16,

              _buildLabel('Category'),
              Obx(() {
                final catCtrl = controller.categoryController;

                if (catCtrl.isLoading.value) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (catCtrl.categories.isEmpty) {
                  return const Text("No categories available");
                }

                return DropdownButtonFormField<String>(
                  value: controller.selectedCategoryId.value.isEmpty ? null : controller.selectedCategoryId.value,
                  decoration: _inputDecoration('Select category'),
                  items: catCtrl.categories.map((cat) {
                    return DropdownMenuItem<String>(
                      value: cat.id ?? '',
                      child: Text(cat.name ?? 'Unnamed'),
                    );
                  }).toList(),
                  onChanged: (value) {
                    if (value == null) return;
                    controller.selectedCategoryId.value = value;
                    final selected = catCtrl.categories.firstWhereOrNull((c) => c.id == value);
                    controller.selectedCategoryName.value = selected?.name ?? '';
                  },
                );
              }),

              sh16,

              _buildLabel('Item Price'),
              _inputField(
                controller: priceController,
                hint: '0.00',
                keyboardType: TextInputType.number,
                onChanged: isDataLoaded.value ? (v) => controller.price.value = v : null,
              ),

              sh16,

              _buildLabel('Item Quantity'),
              _inputField(
                controller: quantityController,
                hint: '1',
                keyboardType: TextInputType.number,
                onChanged: isDataLoaded.value ? (v) => controller.quantity.value = v : null,
              ),

              sh16,

              _buildLabel('Expiry Date'),
              Row(
                children: [
                  Expanded(
                    child: GestureDetector(
                      onTap: () async {
                        final pickedDate = await showDatePicker(
                          context: context,
                          initialDate: controller.expiryDate.value ?? DateTime.now().add(const Duration(days: 1)),
                          firstDate: DateTime.now(),
                          lastDate: DateTime.now().add(const Duration(days: 3650)),
                        );

                        if (pickedDate != null) {
                          controller.expiryDate.value = pickedDate;
                          final today = DateTime.now();
                          final days = pickedDate.difference(today).inDays;
                          controller.expiryDays.value = days.toString();
                        }
                      },
                      child: AbsorbPointer(
                        child: Obx(() {
                          expiryDateController.text = controller.expiryDate.value == null
                              ? ''
                              : DateFormat('dd MMM yyyy').format(controller.expiryDate.value!);
                          return TextField(
                            controller: expiryDateController,
                            decoration: _inputDecoration('Select expiry date'),
                          );
                        }),
                      ),
                    ),
                  ),
                  sw14,
                  Expanded(
                    child: Obx(() {
                      expiryDaysController.text = controller.expiryDays.value;
                      return TextField(
                        controller: expiryDaysController,
                        enabled: false,
                        decoration: _inputDecoration('Days left'),
                      );
                    }),
                  ),
                ],
              ),

              sh16,

              _buildLabel('Discount %'),
              _inputField(
                controller: discountController,
                hint: '0',
                keyboardType: TextInputType.number,
                onChanged: isDataLoaded.value ? (v) => controller.discountPercent.value = v : null,
              ),

              sh40,

              Obx(() => controller.isLoading.value
                  ? CustomLoaderButton()
                  : CustomCenterButton(
                title: "Update Product",
                width: Get.width,
                onTap: () => controller.updateProduct(productId: productId),
              )),

              sh30,
            ],
          ),
        );
      }),
    );
  }

  Widget _buildLabel(String label) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Text(
        label,
        style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600, color: AppColors.textColor),
      ),
    );
  }

  Widget _inputField({
    required TextEditingController controller,
    required String hint,
    int maxLines = 1,
    TextInputType keyboardType = TextInputType.text,
    Function(String)? onChanged, // now nullable
  }) {
    return TextField(
      controller: controller,
      keyboardType: keyboardType,
      maxLines: maxLines,
      onChanged: onChanged, // only active after data is loaded
      decoration: _inputDecoration(hint),
    );
  }

  InputDecoration _inputDecoration(String hint) {
    return InputDecoration(
      hintText: hint,
      hintStyle: TextStyle(color: AppColors.hintColor),
      filled: true,
      fillColor: Colors.white,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: AppColors.grayLight),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: AppColors.grayLight),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: AppColors.mainColor, width: 2),
      ),
    );
  }


}