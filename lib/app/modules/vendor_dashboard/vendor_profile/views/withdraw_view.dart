import 'package:flutter/material.dart';
import 'package:get/get.dart';

// ================== CONTROLLER ==================
class WithdrawalController extends GetxController {
  var availableBalance = 1250.75.obs;
  var withdrawalRequests = <WithdrawalRequest>[].obs;

  final TextEditingController amountController = TextEditingController();

  @override
  void onInit() {
    super.onInit();
    // Sample data — remove in production
    withdrawalRequests.addAll([
      WithdrawalRequest(id: "WD#1001", amount: 450, date: "2025-01-28", status: "Pending"),
      WithdrawalRequest(id: "WD#0998", amount: 1200, date: "2025-01-15", status: "Completed"),
      WithdrawalRequest(id: "WD#0992", amount: 300, date: "2025-01-10", status: "Rejected"),
    ]);
  }

  void requestWithdrawal(double amount) {
    if (amount <= 0) {
      Get.snackbar("Error", "Please enter a valid amount",
          backgroundColor: Colors.redAccent.withOpacity(0.9),
          colorText: Colors.white);
      return;
    }

    if (amount > availableBalance.value) {
      Get.snackbar("Insufficient Balance", "Not enough funds",
          backgroundColor: Colors.orangeAccent.withOpacity(0.9),
          colorText: Colors.white);
      return;
    }

    final newRequest = WithdrawalRequest(
      id: "WD#${1000 + withdrawalRequests.length + 1}",
      amount: amount,
      date: DateTime.now().toString().substring(0, 10),
      status: "Pending",
    );

    withdrawalRequests.insert(0, newRequest);
    availableBalance.value -= amount;

    Get.back();
    Get.snackbar("Success", "Withdrawal request submitted",
        backgroundColor: Colors.green.withOpacity(0.9),
        colorText: Colors.white);
  }
}

class WithdrawalRequest {
  final String id;
  final double amount;
  final String date;
  final String status;

  WithdrawalRequest({
    required this.id,
    required this.amount,
    required this.date,
    required this.status,
  });
}

// ================== VIEW ==================
class WithdrawalView extends StatelessWidget {
  const WithdrawalView({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(WithdrawalController());

    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0.5,
        shadowColor: Colors.black12,
        title: const Text(
          "Withdraw",
          style: TextStyle(
            color: Colors.black87,
            fontWeight: FontWeight.w700,
          ),
        ),
        centerTitle: true,
        iconTheme: const IconThemeData(color: Colors.black87),
      ),
      body: SafeArea(
        child: Column(
          children: [
            // Balance Card
            _buildBalanceCard(controller),

            const SizedBox(height: 16),

            // Header + List
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
                            backgroundColor: Colors.teal.shade600,
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30),
                            ),
                            elevation: 2,
                          ),
                        ),
                      ],
                    ),
                  ),

                  // Requests List
                  Expanded(
                    child: Obx(
                          () => controller.withdrawalRequests.isEmpty
                          ? Center(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(Icons.history, size: 64, color: Colors.grey.shade400),
                            const SizedBox(height: 16),
                            Text(
                              "No withdrawal requests yet",
                              style: TextStyle(
                                color: Colors.grey.shade600,
                                fontSize: 16,
                              ),
                            ),
                          ],
                        ),
                      )
                          : ListView.builder(
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                        itemCount: controller.withdrawalRequests.length,
                        itemBuilder: (context, index) {
                          final req = controller.withdrawalRequests[index];
                          return _buildRequestItem(req);
                        },
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

  Widget _buildBalanceCard(WithdrawalController controller) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 28, horizontal: 24),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.08),
              blurRadius: 16,
              offset: const Offset(0, 6),
            ),
          ],
          border: Border.all(color: Colors.grey.shade200),
        ),
        child: Column(
          children: [
            Text(
              "Available Balance",
              style: TextStyle(
                color: Colors.grey.shade700,
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 12),
            Obx(
                  () => Text(
                "\$${controller.availableBalance.value.toStringAsFixed(2)}",
                style: TextStyle(
                  fontSize: 42,
                  fontWeight: FontWeight.w800,
                  color: Colors.teal.shade800,
                  letterSpacing: -0.5,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRequestItem(WithdrawalRequest req) {
    Color statusColor;
    Color statusBg;

    switch (req.status.toLowerCase()) {
      case "completed":
        statusColor = Colors.green.shade700;
        statusBg = Colors.green.shade50;
        break;
      case "pending":
        statusColor = Colors.orange.shade800;
        statusBg = Colors.orange.shade50;
        break;
      case "rejected":
        statusColor = Colors.red.shade700;
        statusBg = Colors.red.shade50;
        break;
      default:
        statusColor = Colors.grey.shade700;
        statusBg = Colors.grey.shade100;
    }

    return Card(
      margin: const EdgeInsets.symmetric(vertical: 6),
      elevation: 1,
      shadowColor: Colors.black12,
      color: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  req.id,
                  style: TextStyle(
                    color: Colors.grey.shade800,
                    fontWeight: FontWeight.w600,
                    fontSize: 15,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  req.date,
                  style: TextStyle(color: Colors.grey.shade600, fontSize: 13),
                ),
              ],
            ),
            const Spacer(),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  "-\$${req.amount.toStringAsFixed(2)}",
                  style: const TextStyle(
                    fontSize: 19,
                    fontWeight: FontWeight.w700,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 8),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: statusBg,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    req.status,
                    style: TextStyle(
                      color: statusColor,
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _showWithdrawDialog(BuildContext context, WithdrawalController controller) {
    controller.amountController.clear();

    Get.dialog(
      AlertDialog(
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        title: const Text(
          "Request Withdrawal",
          style: TextStyle(
            color: Colors.black87,
            fontWeight: FontWeight.w700,
            fontSize: 20,
          ),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Available: \$${controller.availableBalance.value.toStringAsFixed(2)}",
              style: TextStyle(color: Colors.teal.shade700, fontSize: 15),
            ),
            const SizedBox(height: 24),
            TextField(
              controller: controller.amountController,
              keyboardType: const TextInputType.numberWithOptions(decimal: true),
              style: const TextStyle(color: Colors.black87, fontSize: 24),
              decoration: InputDecoration(
                hintText: "0.00",
                hintStyle: TextStyle(color: Colors.grey.shade500),
                prefixText: "\$ ",
                prefixStyle: const TextStyle(color: Colors.black87, fontSize: 24),
                filled: true,
                fillColor: Colors.grey.shade50,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                  borderSide: BorderSide(color: Colors.grey.shade300),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                  borderSide: BorderSide(color: Colors.grey.shade300),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                  borderSide: BorderSide(color: Colors.teal.shade600, width: 2),
                ),
                contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
              ),
            ),
          ],
        ),
        actionsPadding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
        actions: [
          TextButton(
            onPressed: Get.back,
            child: Text(
              "Cancel",
              style: TextStyle(color: Colors.grey.shade700, fontSize: 16),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              final amountText = controller.amountController.text.trim();
              final amount = double.tryParse(amountText) ?? 0;
              controller.requestWithdrawal(amount);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.teal.shade600,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 14),
              elevation: 2,
            ),
            child: const Text(
              "Confirm",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
          ),
        ],
      ),
    );
  }
}