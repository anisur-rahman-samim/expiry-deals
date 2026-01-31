import 'package:expiry_deals/app/modules/vendor_dashboard/vendor_profile/controllers/bank_details_controller.dart';
import 'package:expiry_deals/common/app_color/app_colors.dart';
import 'package:expiry_deals/common/widgets/custom_textfelid.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';




class BankDetailsView extends StatelessWidget {
  const BankDetailsView({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(BankDetailsController());

    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: AppBar(
        backgroundColor: AppColors.white,
        elevation: 1,
        iconTheme: const IconThemeData(color: Colors.black87),
        title: const Text(
          "Bank Details",
          style: TextStyle(
            color: Colors.black87,
            fontWeight: FontWeight.w700,
            fontSize: 20,
          ),
        ),
      ),
      body: Stack(
        children: [
          // Scrollable content
          SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(20, 16, 20, 120),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Security hint
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.blue.shade50,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: Colors.blue.shade200),
                  ),
                  child: Row(
                    children: const [
                      Icon(Icons.info_outline, color: Colors.blue, size: 20),
                      SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          "Your bank information is securely stored and encrypted.",
                          style: TextStyle(
                            color: Colors.blue,
                            fontSize: 13,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 28),

                _buildSectionTitle("Account Information"),
                const SizedBox(height: 12),

                CustomTextField(
                  width: double.infinity,
                  hintText: "Account Number",
                  controller: controller.accountNumberCtrl,

                  preIcon: const Icon(Icons.account_balance_wallet_outlined),
                ),
                const SizedBox(height: 16),

                CustomTextField(
                  width: double.infinity,
                  hintText: "Routing / ABA Number",
                  controller: controller.routingNumberCtrl,

                  preIcon: const Icon(Icons.pin),
                ),
                const SizedBox(height: 32),

                _buildSectionTitle("Bank Information"),
                const SizedBox(height: 12),

                CustomTextField(
                  width: double.infinity,
                  hintText: "Bank Name",
                  controller: controller.bankNameCtrl,
                  preIcon: const Icon(Icons.business),
                ),
                const SizedBox(height: 16),

                CustomTextField(
                  width: double.infinity,
                  hintText: "Account Holder Name",
                  controller: controller.holderNameCtrl,
                  preIcon: const Icon(Icons.person_outline),
                ),
                const SizedBox(height: 16),

                CustomTextField(
                  width: double.infinity,
                  hintText: "Bank Address",
                  controller: controller.bankAddressCtrl,
                  maxLines: 3,
                  preIcon: const Icon(Icons.location_on_outlined),
                ),

                const SizedBox(height: 40),
              ],
            ),
          ),

          // Bottom fixed Save button
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: Container(
              padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
              decoration: BoxDecoration(
                color: AppColors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.08),
                    blurRadius: 12,
                    offset: const Offset(0, -3),
                  ),
                ],
              ),
              child: ElevatedButton(
                onPressed: controller.saveBankDetails,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.black,
                  foregroundColor: AppColors.white,
                  padding: const EdgeInsets.symmetric(vertical: 15),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  elevation: 1,
                ),
                child: const Text(
                  "SAVE BANK DETAILS",
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    letterSpacing: 0.4,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: const TextStyle(
        fontSize: 17,
        fontWeight: FontWeight.w600,
        color: Colors.black87,
      ),
    );
  }
}