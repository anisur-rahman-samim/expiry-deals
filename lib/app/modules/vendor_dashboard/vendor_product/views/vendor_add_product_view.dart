// vendor_add_product_view.dart

import 'dart:io';

import 'package:expiry_deals/app/modules/vendor_dashboard/vendor_product/controllers/vendor_add_product_controller.dart';
import 'package:expiry_deals/common/app_color/app_colors.dart';
import 'package:expiry_deals/common/size_box/custom_sizebox.dart';
import 'package:expiry_deals/common/widgets/custom_button.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class VendorAddProductView extends GetView<VendorAddProductController> {
  const VendorAddProductView({super.key});

  @override
  Widget build(BuildContext context) {
    Get.put(VendorAddProductController());

    final TextEditingController expiryDateController = TextEditingController();
    final TextEditingController expiryDaysController = TextEditingController();

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
            Text(
              'Upload Image',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: AppColors.textColor,
              ),
            ),
            sh10,

            /// IMAGE PICKER
            Obx(() => GestureDetector(
              onTap: controller.pickImage,
              child: Container(
                height: 180,
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: AppColors.grayLight,
                    width: 2,
                  ),
                  image: controller.selectedImage.value != null
                      ? DecorationImage(
                    image:
                    FileImage(controller.selectedImage.value!),
                    fit: BoxFit.cover,
                  )
                      : null,
                ),
                child: controller.selectedImage.value == null
                    ? Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.add_a_photo_outlined,
                      size: 48,
                      color: AppColors.mainColor
                          .withValues(alpha: 0.6),
                    ),
                    sh10,
                    Text(
                      'Upload',
                      style: TextStyle(
                        color: AppColors.mainColor,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    Text(
                      'Tap to select image',
                      style:
                      TextStyle(color: AppColors.hintColor),
                    ),
                  ],
                )
                    : null,
              ),
            )),

            sh20,

            /// ITEM NAME
            _buildLabel('Item Name'),
            _inputField(
              hint: 'e.g., Wireless Bluetooth Earbuds',
              onChanged: (v) => controller.itemName.value = v,
            ),

            sh16,

            /// ITEM DETAILS
            _buildLabel('Item Details'),
            _inputField(
              hint: 'Describe your product...',
              maxLines: 3,
              onChanged: (v) => controller.itemDetails.value = v,
            ),

            sh16,

            /// CATEGORY
            _buildLabel('Category'),
            Obx(() => DropdownButtonFormField<String>(
              value: controller.categories
                  .contains(controller.selectedCategory.value)
                  ? controller.selectedCategory.value
                  : controller.categories.first,
              decoration: _inputDecoration('Select category'),
              items: controller.categories
                  .map(
                    (cat) => DropdownMenuItem(
                  value: cat,
                  child: Text(cat),
                ),
              )
                  .toList(),
              onChanged: (value) {
                if (value != null) {
                  controller.selectedCategory.value = value;
                }
              },
            )),

            sh16,

            /// PRICE
            _buildLabel('Item Price'),
            _inputField(
              hint: '0.00',
              keyboardType: TextInputType.number,
              onChanged: (v) => controller.price.value = v,
            ),

            sh16,

            /// QUANTITY
            _buildLabel('Item Quantity'),
            _inputField(
              hint: '1',
              keyboardType: TextInputType.number,
              onChanged: (v) => controller.quantity.value = v,
            ),

            sh16,

            /// EXPIRY DATE + AUTO DAYS
            _buildLabel('Expiry Date'),
            Row(
              children: [
                /// DATE PICKER
                Expanded(
                  child: GestureDetector(
                    onTap: () async {
                      final pickedDate = await showDatePicker(
                        context: context,
                        initialDate: DateTime.now().add(const Duration(days: 1)),
                        firstDate: DateTime.now(),
                        lastDate:
                        DateTime.now().add(const Duration(days: 3650)),
                      );

                      if (pickedDate != null) {
                        controller.expiryDate.value = pickedDate;

                        final today = DateTime.now();
                        final days = pickedDate
                            .difference(
                          DateTime(today.year, today.month, today.day),
                        )
                            .inDays;

                        controller.expiryDays.value = days.toString();
                      }
                    },
                    child: AbsorbPointer(
                      child: Obx(() {
                        expiryDateController.text =
                        controller.expiryDate.value == null
                            ? ''
                            : DateFormat('dd MMM yyyy')
                            .format(controller.expiryDate.value!);

                        return TextField(
                          controller: expiryDateController,
                          decoration:
                          _inputDecoration('Select expiry date'),
                        );
                      }),
                    ),
                  ),
                ),

                sw14,

                /// AUTO DAYS (READ ONLY)
                Expanded(
                  child: Obx(() {
                    expiryDaysController.text =
                        controller.expiryDays.value;

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

            /// DISCOUNT
            _buildLabel('Discount %'),
            _inputField(
              hint: '0',
              keyboardType: TextInputType.number,
              onChanged: (v) => controller.discountPercent.value = v,
            ),

            sh40,

            /// SAVE BUTTON
            CustomCenterButton(
              title: "Save Product",
              width: Get.width,
            ),

            sh30,
          ],
        ),
      ),
    );
  }

  /// LABEL
  Widget _buildLabel(String label) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Text(
        label,
        style: TextStyle(
          fontSize: 15,
          fontWeight: FontWeight.w600,
          color: AppColors.textColor,
        ),
      ),
    );
  }

  /// INPUT FIELD
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
      decoration: _inputDecoration(hint),
    );
  }

  /// COMMON DECORATION
  InputDecoration _inputDecoration(String hint) {
    return InputDecoration(
      hintText: hint,
      hintStyle: TextStyle(color: AppColors.hintColor),
      filled: true,
      fillColor: Colors.white,
      contentPadding:
      const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
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
