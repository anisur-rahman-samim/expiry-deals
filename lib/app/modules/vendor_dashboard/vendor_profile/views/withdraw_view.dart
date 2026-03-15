import 'package:expiry_deals/app/modules/profile/controllers/profile_controller.dart';
import 'package:expiry_deals/app/modules/vendor_dashboard/vendor_profile/controllers/withdraw_controller.dart';
import 'package:expiry_deals/app/modules/vendor_dashboard/vendor_profile/model/withdraw_model.dart';
import 'package:expiry_deals/common/app_color/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class WithdrawalView extends StatelessWidget {
   WithdrawalView({super.key});

  final ProfileController profileController = Get.put(ProfileController());

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(WithdrawController());

    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0.5,
        title: const Text(
          "Withdraw",
          style: TextStyle(color: Colors.black87, fontWeight: FontWeight.w700),
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Column(
          children: [
            // Balance Card (static for now – update if you fetch real balance)
            _buildBalanceCard(controller),

            const SizedBox(height: 16),

            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          "Withdrawal History",
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w700,
                            color: Colors.black87,
                          ),
                        ),
                        ElevatedButton.icon(
                          onPressed: () => _showWithdrawDialog(context, controller),
                          icon: const Icon(Icons.add, size: 18),
                          label: const Text("New Request"),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.mainColor,
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                          ),
                        ),
                      ],
                    ),
                  ),

                  Expanded(
                    child: Obx(
                          () => controller.isLoading.value
                          ? const Center(child: CircularProgressIndicator())
                          : controller.withdrawalRequests.isEmpty
                          ? Center(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(Icons.history, size: 64, color: Colors.grey.shade400),
                            const SizedBox(height: 16),
                            Text(
                              "No withdrawal requests yet",
                              style: TextStyle(color: Colors.grey.shade600, fontSize: 16),
                            ),
                          ],
                        ),
                      )
                          : RefreshIndicator(
                        onRefresh: controller.fetchWithdrawalRequests,
                        child: ListView.builder(
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                          itemCount: controller.withdrawalRequests.length,
                          itemBuilder: (context, index) {
                            final req = controller.withdrawalRequests[index];
                            return _buildRequestItem(req);
                          },
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBalanceCard(WithdrawController controller) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 28, horizontal: 24),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(color: Colors.black.withOpacity(0.08), blurRadius: 16, offset: const Offset(0, 6)),
          ],
          border: Border.all(color: Colors.grey.shade200),
        ),
        child: Column(
          children: [
            Text(
              "Available Balance",
              style: TextStyle(color: Colors.grey.shade700, fontSize: 16, fontWeight: FontWeight.w500),
            ),
            const SizedBox(height: 12),
            Obx(
                  () => Text(
                "\$${profileController.profileData.value.data?.balance.toStringAsFixed(2)}",
                style: TextStyle(
                  fontSize: 42,
                  fontWeight: FontWeight.w800,
                  color: AppColors.mainColor,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRequestItem(WithdrawRequest req) {
    Color statusColor;
    Color statusBg;

    switch (req.status?.toLowerCase()) {
      case "completed":
      case "approved":
        statusColor = Colors.green.shade700;
        statusBg = Colors.green.shade50;
        break;
      case "pending":
      case "processing":
        statusColor = Colors.orange.shade800;
        statusBg = Colors.orange.shade50;
        break;
      case "rejected":
      case "failed":
        statusColor = Colors.red.shade700;
        statusBg = Colors.red.shade50;
        break;
      default:
        statusColor = Colors.grey.shade700;
        statusBg = Colors.grey.shade100;
    }

    DateTime dateTime = DateTime.parse(req.createdAt.toString());

    String formattedDate = DateFormat('hh:mm a MM-dd-yyyy').format(dateTime);

    return Card(
      margin: const EdgeInsets.symmetric(vertical: 6),
      elevation: 1,
      color: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Request #${req.id?.substring(req.id!.length - 6) ?? '—'}",
                    style: TextStyle(color: Colors.grey.shade800, fontWeight: FontWeight.w600),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    formattedDate,
                    style: TextStyle(color: Colors.grey.shade600, fontSize: 13),
                  ),
                ],
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  "-\$${req.amount ?? 0}",
                  style: const TextStyle(fontSize: 19, fontWeight: FontWeight.w700, color: Colors.black87),
                ),
                const SizedBox(height: 8),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(color: statusBg, borderRadius: BorderRadius.circular(20)),
                  child: Text(
                    req.status ?? "Unknown",
                    style: TextStyle(color: statusColor, fontSize: 13, fontWeight: FontWeight.w600),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _showWithdrawDialog(BuildContext context, WithdrawController controller) {
    controller.amountController.clear();

    Get.dialog(
      AlertDialog(
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        title: const Text("Request Withdrawal", style: TextStyle(fontWeight: FontWeight.w700)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Available: \$${controller.availableBalance.value.toStringAsFixed(2)}",
              style: TextStyle(color: Colors.teal.shade700),
            ),
            const SizedBox(height: 24),
            TextField(
              controller: controller.amountController,
              keyboardType: const TextInputType.numberWithOptions(decimal: true),
              style: const TextStyle(fontSize: 24),
              decoration: InputDecoration(
                hintText: "0.00",
                prefixText: "\$ ",
                filled: true,
                fillColor: Colors.grey.shade50,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(color: Colors.grey.shade300),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(color: Colors.teal.shade600, width: 2),
                ),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(onPressed: Get.back, child: const Text("Cancel")),
          Obx(
                () => controller.isLoading.value
                ? const CircularProgressIndicator()
                : ElevatedButton(
              onPressed: () {
                final amount = double.tryParse(controller.amountController.text) ?? 0;
                controller.createWithdrawalRequest(amount);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.teal.shade600,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 14),
              ),
              child: const Text("Confirm"),
            ),
          ),
        ],
      ),
    );
  }
}