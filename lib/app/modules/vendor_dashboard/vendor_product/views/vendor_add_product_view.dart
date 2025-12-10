// vendor_add_product_view.dart

import 'package:expiry_deals/app/modules/vendor_dashboard/vendor_product/controllers/vendor_add_product_controller.dart';
import 'package:expiry_deals/common/app_color/app_colors.dart';
import 'package:expiry_deals/common/size_box/custom_sizebox.dart';
import 'package:expiry_deals/common/widgets/custom_button.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';


class VendorAddProductView extends GetView<VendorAddProductController> {
  const VendorAddProductView({super.key});

  @override
  Widget build(BuildContext context) {
    Get.put(VendorAddProductController());

    return Scaffold(
      backgroundColor: AppColors.bgColor,
      appBar: AppBar(
        title: const Text('Add New Product'),
        centerTitle: true,
        backgroundColor: AppColors.mainColor,
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Upload Image', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: AppColors.textColor)),
            sh10,

            // Main Image Upload
            Obx(() => GestureDetector(
              onTap: controller.pickImage,
              child: Container(
                height: 180,
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: AppColors.grayLight, width: 2, style: BorderStyle.solid),
                  image: controller.selectedImage.value != null
                      ? DecorationImage(
                    image: FileImage(controller.selectedImage.value!),
                    fit: BoxFit.cover,
                  )
                      : null,
                ),
                child: controller.selectedImage.value == null
                    ? Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.add_a_photo_outlined, size: 48, color: AppColors.mainColor.withValues(alpha: 0.6),),
                    sh10,
                    Text('Upload', style: TextStyle(color: AppColors.mainColor, fontWeight: FontWeight.w600)),
                    Text('Upload', style: TextStyle(color: AppColors.hintColor)),
                  ],
                )
                    : null,
              ),
            )),

            sh20,

            // Item Name
            _buildTextField('Item Name'),
            _inputField(hint: 'e.g., Wireless Bluetooth Earbuds', onChanged: (v) => controller.itemName.value = v),

            sh16,
            _buildTextField('Item Details'),
            _inputField(hint: 'Describe your product...', maxLines: 3, onChanged: (v) => controller.itemDetails.value = v),

            sh16,
            _buildTextField('Category'),
            Obx(() => DropdownButtonFormField<String>(
              value: controller.categories.contains(controller.selectedCategory.value)
                  ? controller.selectedCategory.value
                  : controller.categories.first, // fallback to first item if invalid
              decoration: InputDecoration(
                filled: true,
                fillColor: Colors.white,
                hintText: 'Select category',
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide(color: AppColors.grayLight)),
                enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide(color: AppColors.grayLight)),
                focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide(color: AppColors.mainColor, width: 2)),
                contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
              ),
              items: controller.categories
                  .map((cat) => DropdownMenuItem(value: cat, child: Text(cat)))
                  .toList(),
              onChanged: (value) {
                if (value != null) controller.selectedCategory.value = value;
              },
            )),

            sh16,
            _buildTextField('Item Price'),
            _inputField(hint: '0.00', keyboardType: TextInputType.number, onChanged: (v) => controller.price.value = v),

            sh16,
            _buildTextField('Item Quantity'),
            _inputField(hint: '1', keyboardType: TextInputType.number, onChanged: (v) => controller.quantity.value = v),

            sh16,
            _buildTextField('Expiry date'),
            Row(
              children: [
                Expanded(
                  child: _inputField(hint: 'Days', keyboardType: TextInputType.number, onChanged: (v) => controller.expiryDays.value = v),
                ),
                sw14,
                Expanded(
                  child: _inputField(hint: 'Discount %', keyboardType: TextInputType.number, onChanged: (v) => controller.discountPercent.value = v),
                ),
              ],
            ),

            sh40,

            // Save Button
          CustomCenterButton(title: "Save Product", width: Get.width),

            sh30,
          ],
        ),
      ),
    );
  }

  Widget _buildTextField(String label) {
    return Text(
      label,
      style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600, color: AppColors.textColor),
    );
  }

  Widget _inputField({
    required String hint,
    int maxLines = 1,
    TextInputType keyboardType = TextInputType.text,
    required Function(String) onChanged,
  }) {
    return TextField(
      keyboardType: keyboardType,
      maxLines: maxLines,
      onChanged: onChanged,
      decoration: InputDecoration(
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
      ),
    );
  }
}