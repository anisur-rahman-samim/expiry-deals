import 'package:expiry_deals/app/modules/vendor_dashboard/vendor_product/controllers/vendor_add_product_controller.dart';
import 'package:expiry_deals/common/app_color/app_colors.dart';
import 'package:expiry_deals/common/size_box/custom_sizebox.dart';
import 'package:expiry_deals/common/widgets/custom_button.dart';
import 'package:expiry_deals/common/widgets/custom_loader.dart';
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
              'Product photos',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: AppColors.textColor,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              'Add up to ${VendorAddProductController.maxImages} images. '
              'Several angles usually sell better than one.',
              style: TextStyle(
                fontSize: 13,
                height: 1.35,
                color: AppColors.hintColor,
              ),
            ),
            sh10,

            Obx(() {
              final files = controller.selectedImages;
              return SizedBox(
                height: 118,
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  children: [
                    ...files.asMap().entries.map((e) {
                      final i = e.key;
                      final f = e.value;
                      return Padding(
                        padding: const EdgeInsets.only(right: 10),
                        child: Stack(
                          clipBehavior: Clip.none,
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(14),
                              child: Image.file(
                                f,
                                width: 112,
                                height: 112,
                                fit: BoxFit.cover,
                              ),
                            ),
                            Positioned(
                              top: -6,
                              right: -6,
                              child: Material(
                                color: Colors.black.withValues(alpha: 0.55),
                                shape: const CircleBorder(),
                                child: InkWell(
                                  customBorder: const CircleBorder(),
                                  onTap: () => controller.removeImageAt(i),
                                  child: const Padding(
                                    padding: EdgeInsets.all(6),
                                    child: Icon(
                                      Icons.close_rounded,
                                      size: 16,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      );
                    }),
                    if (files.length < VendorAddProductController.maxImages)
                      GestureDetector(
                        onTap: controller.showImageSourcePicker,
                        child: Container(
                          width: 112,
                          height: 112,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(14),
                            border: Border.all(
                              color: AppColors.grayLight,
                              width: 2,
                            ),
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.add_photo_alternate_outlined,
                                size: 32,
                                color: AppColors.mainColor.withValues(alpha: 0.85),
                              ),
                              const SizedBox(height: 6),
                              Text(
                                'Add',
                                style: TextStyle(
                                  color: AppColors.mainColor,
                                  fontWeight: FontWeight.w600,
                                  fontSize: 13,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                  ],
                ),
              );
            }),

            sh20,

            /// Item Name
            _buildLabel('Item Name'),
            _inputField(
              hint: 'e.g., Wireless Bluetooth Earbuds',
              onChanged: (v) => controller.itemName.value = v,
            ),

            sh16,

            /// Item Details
            _buildLabel('Item Details'),
            _inputField(
              hint: 'Describe your product...',
              maxLines: 3,
              onChanged: (v) => controller.itemDetails.value = v,
            ),

            sh16,

            /// Category
            _buildLabel('Category'),
            Obx(() {
              final catCtrl = controller.categoryController;

              if (catCtrl.isLoading.value) {
                return const Padding(
                  padding: EdgeInsets.symmetric(vertical: 10),
                  child: Center(child: CircularProgressIndicator()),
                );
              }

              if (catCtrl.categories.isEmpty) {
                return Container(
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: AppColors.grayLight),
                  ),
                  child: Row(
                    children: [
                      Expanded(child: Text("No categories found", style: TextStyle(color: AppColors.textColor))),
                      TextButton(
                        onPressed: () => catCtrl.fetchCategories(),
                        child: const Text("Retry"),
                      ),
                    ],
                  ),
                );
              }

              final validSelected = catCtrl.categories.any((c) => c.id == controller.selectedCategoryId.value);
              final dropdownValue = validSelected ? controller.selectedCategoryId.value : (catCtrl.categories.first.id ?? '');

              return DropdownButtonFormField<String>(
                value: dropdownValue.isEmpty ? null : dropdownValue,
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

            /// Price
            _buildLabel('Item Price'),
            _inputField(
              hint: '0.00',
              keyboardType: TextInputType.text,
              onChanged: (v) => controller.price.value = v,
            ),

            sh16,

            /// Quantity
            _buildLabel('Item Quantity'),
            _inputField(
              hint: '1',
              keyboardType: TextInputType.number,
              onChanged: (v) => controller.quantity.value = v,
            ),

            sh16,

            /// Expiry Date + Days
            _buildLabel('Expiry Date'),
            Row(
              children: [
                Expanded(
                  child: GestureDetector(
                    onTap: () async {
                      final pickedDate = await showDatePicker(
                        context: context,
                        initialDate: DateTime.now().add(const Duration(days: 1)),
                        firstDate: DateTime.now(),
                        lastDate: DateTime.now().add(const Duration(days: 3650)),
                      );

                      if (pickedDate != null) {
                        controller.expiryDate.value = pickedDate;

                        final today = DateTime.now();
                        final days = pickedDate.difference(DateTime(today.year, today.month, today.day)).inDays;
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

            /// Discount
            _buildLabel('Discount %'),
            _inputField(
              hint: '0',
              keyboardType: TextInputType.number,
              onChanged: (v) => controller.discountPercent.value = v,
            ),

            sh40,

            /// Save Button
            Obx(() => controller.isLoading.value
                ? CustomLoaderButton()
                : CustomCenterButton(
              title: "Save Product",
              width: Get.width,
              onTap: controller.addProduct,
            )),

            sh30,
          ],
        ),
      ),
    );
  }

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