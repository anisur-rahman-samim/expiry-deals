import 'package:expiry_deals/app/modules/order_success/views/order_success_view.dart';
import 'package:expiry_deals/common/app_color/app_colors.dart';
import 'package:expiry_deals/common/app_text_style/styles.dart';
import 'package:expiry_deals/common/widgets/custom_button.dart';
import 'package:expiry_deals/common/widgets/custom_textfelid.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class BillingDetailsView extends StatefulWidget {
  BillingDetailsView({super.key});

  @override
  State<BillingDetailsView> createState() => _BillingDetailsViewState();
}

class _BillingDetailsViewState extends State<BillingDetailsView> {
  final TextEditingController addressController = TextEditingController();

  final TextEditingController cityController = TextEditingController();

  final TextEditingController stateController = TextEditingController();

  final TextEditingController zipCodeController = TextEditingController();

  final TextEditingController countryController = TextEditingController();

  // Payment method state
  int _paymentMethod = 1;
 // Default: 1 (Cash on Delivery)
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: AppBar(
        backgroundColor: AppColors.white,
        title: const Text('Order Details'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            // Address Field
            CustomTextField(
              width: MediaQuery.of(context).size.width,
              hintText: 'Enter your address',
              controller: addressController,
              preIcon: const Icon(Icons.home),
            ),
            const SizedBox(height: 16),

            // City Field
            CustomTextField(
              width: MediaQuery.of(context).size.width,
              hintText: 'Enter your city',
              controller: cityController,
              preIcon: const Icon(Icons.location_city),
            ),
            const SizedBox(height: 16),

            // State Field
            CustomTextField(
              width: MediaQuery.of(context).size.width,
              hintText: 'Enter your state',
              controller: stateController,
              preIcon: const Icon(Icons.account_balance),
            ),
            const SizedBox(height: 16),

            // Zip Code Field
            CustomTextField(
              width: MediaQuery.of(context).size.width,
              hintText: 'Enter your zip code',
              controller: zipCodeController,
              preIcon: const Icon(Icons.confirmation_number),
            ),
            const SizedBox(height: 16),

            // Country Field
            CustomTextField(
              width: MediaQuery.of(context).size.width,
              hintText: 'Enter your country',
              controller: countryController,
              preIcon: const Icon(Icons.public),
            ),
            const SizedBox(height: 16),

            // Payment Method Selector
            Text("Payment Method", style: h2),
            const SizedBox(height: 8),
            RadioListTile<int>(
              value: 1, // Cash on Delivery
              groupValue: _paymentMethod,
              onChanged: (int? value) {
                if (value != null) {
                  _paymentMethod = value;
                setState(() {

                });
                }
              },
              title: const Text('Cash on Delivery'),
              activeColor: AppColors.mainColor,
            ),
            RadioListTile<int>(
              value: 2, // Online Payment
              groupValue: _paymentMethod,
              onChanged: (int? value) {
                if (value != null) {
                  _paymentMethod = value;
                  setState(() {

                  });
                }
              },
              title: const Text('Online Payment'),
              activeColor: AppColors.mainColor,
            ),
            const SizedBox(height: 16),

            // Save Button
            CustomCenterButton(
              onTap: () {
                // Handle the order submission and display the selected payment method
                String paymentMethod = _paymentMethod == 1
                    ? "Cash on Delivery"
                    : "Online Payment";

                debugPrint(paymentMethod);
                Get.offAll(() => OrderSuccessView());
                Get.snackbar(
                  "Order Placed",
                  "You selected $paymentMethod as your payment method.",
                );
              },
              title: "Place Order",
              width: Get.width,
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  // Widget to display the entered billing details (optional)
  Widget _buildBillingDetails() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Address: ${addressController.text}'),
        Text('City: ${cityController.text}'),
        Text('State: ${stateController.text}'),
        Text('Zip Code: ${zipCodeController.text}'),
        Text('Country: ${countryController.text}'),
      ],
    );
  }
}
