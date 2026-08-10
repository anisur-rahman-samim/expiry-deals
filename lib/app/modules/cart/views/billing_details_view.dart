import 'package:expiry_deals/app/modules/cart/controllers/order_place_controller.dart';
import 'package:expiry_deals/app/modules/edit_profile/controllers/edit_profile_controller.dart';
import 'package:expiry_deals/common/app_color/app_colors.dart';
import 'package:expiry_deals/common/app_text_style/styles.dart';
import 'package:expiry_deals/common/widgets/custom_button.dart';
import 'package:expiry_deals/common/widgets/custom_loader.dart';
import 'package:expiry_deals/common/widgets/custom_textfield.dart';
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
  // final TextEditingController cityController = TextEditingController();
  // final TextEditingController stateController = TextEditingController();
  // final TextEditingController zipCodeController = TextEditingController();
  // final TextEditingController countryController = TextEditingController();
 final EditProfileController controller = Get.put(EditProfileController());

  final OrderPlaceController orderPlaceController = Get.put(OrderPlaceController());

  @override
  Widget build(BuildContext context) {
       ever(controller.profileData, (_) {
      final data = controller.profileData.value.data;
      if (data != null) {
        addressController.text = data.address ?? '';
      }
    });
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
              maxLines: 3,
            ),
            const SizedBox(height: 16),
            // CustomTextField(
            //   controller: cityController,
            //   hintText: 'Enter your city', width: Get.width,
            // ),
            // const SizedBox(height: 16),
            // CustomTextField(
            //   controller: stateController,
            //   hintText: 'Enter your state', width: Get.width,
            // ),
            // const SizedBox(height: 16),
            // CustomTextField(
            //   controller: zipCodeController,
            //   hintText: 'Enter your zip code', width: Get.width,
            // ),
            // const SizedBox(height: 16),
            // CustomTextField(
            //   controller: countryController,
            //   hintText: 'Enter your country', width: Get.width,
            // ),
            // const SizedBox(height: 16),

            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: AppColors.bgColor,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: AppColors.grayLight),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(Icons.lock_outline_rounded, color: AppColors.mainColor, size: 22),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      'Payment is online only. After you place the order, you’ll complete checkout securely in the next step.',
                      style: h4.copyWith(color: AppColors.hintColor, height: 1.35),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),

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
                  city: addressController.text,
                  state: addressController.text,
                  zipCode: addressController.text,
                  country: addressController.text,
                  paymentMethod: '2',
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
