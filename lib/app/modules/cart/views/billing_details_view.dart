import 'package:expiry_deals/app/modules/cart/controllers/order_place_controller.dart';
import 'package:expiry_deals/app/modules/order_success/views/order_success_view.dart';
import 'package:expiry_deals/common/app_color/app_colors.dart';
import 'package:expiry_deals/common/app_text_style/styles.dart';
import 'package:expiry_deals/common/widgets/custom_button.dart';
import 'package:expiry_deals/common/widgets/custom_loader.dart';
import 'package:expiry_deals/common/widgets/custom_textfelid.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class BillingDetailsView extends StatefulWidget {
  final String authorId;
  final double totalPrice;
  final List<Map<String, dynamic>> items; // Added items list

  const BillingDetailsView({
    super.key,
    required this.authorId,
    required this.totalPrice,
    required this.items,
  });

  @override
  State<BillingDetailsView> createState() => _BillingDetailsViewState();
}

class _BillingDetailsViewState extends State<BillingDetailsView> {
  final TextEditingController addressController = TextEditingController();
  final TextEditingController cityController = TextEditingController();
  final TextEditingController stateController = TextEditingController();
  final TextEditingController zipCodeController = TextEditingController();
  final TextEditingController countryController = TextEditingController();

  final OrderPlaceController orderPlaceController = Get.put(OrderPlaceController());
  int _paymentMethod = 1; // Default to Cash on Delivery

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: AppBar(
        backgroundColor: AppColors.white,
        title: const Text('Billing Details'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            CustomTextField(
              controller: addressController,
              hintText: 'Enter your address',  width: Get.width,
            ),
            const SizedBox(height: 16),
            CustomTextField(
              controller: cityController,
              hintText: 'Enter your city', width: Get.width,
            ),
            const SizedBox(height: 16),
            CustomTextField(
              controller: stateController,
              hintText: 'Enter your state', width: Get.width,
            ),
            const SizedBox(height: 16),
            CustomTextField(
              controller: zipCodeController,
              hintText: 'Enter your zip code', width: Get.width,
            ),
            const SizedBox(height: 16),
            CustomTextField(
              controller: countryController,
              hintText: 'Enter your country', width: Get.width,
            ),
            const SizedBox(height: 16),

            // Payment Method Selection
            RadioListTile<int>(
              value: 1,
              groupValue: _paymentMethod,
              onChanged: (int? value) {
                setState(() {
                  if (value != null) _paymentMethod = value;
                });
              },
              title: const Text('Cash on Delivery'),
              activeColor: AppColors.mainColor,
            ),
            RadioListTile<int>(
              value: 2,
              groupValue: _paymentMethod,
              onChanged: (int? value) {
                setState(() {
                  if (value != null) _paymentMethod = value;
                });
              },
              title: const Text('Online Payment'),
              activeColor: AppColors.mainColor,
            ),

            // Place Order Button
            Obx(() => orderPlaceController.isLoading.value
                ? CustomLoaderButton()
                : CustomCenterButton(
              onTap: () {

                orderPlaceController.createOrder(
                  authorId: widget.authorId,
                  items: widget.items,
                  totalPrice: widget.totalPrice,
                  address: addressController.text,
                  city: cityController.text,
                  state: stateController.text,
                  zipCode: zipCodeController.text,
                  country: countryController.text,
                  paymentMethod: _paymentMethod.toString(),
                );
              },
              title: "Place Order",
              width: Get.width,
            ),
            ),
          ],
        ),
      ),
    );
  }
}
