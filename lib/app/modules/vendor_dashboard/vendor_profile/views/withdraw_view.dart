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
        actions: [
          IconButton(
            tooltip: 'Refresh balance & history',
            onPressed: () => controller.refreshAll(),
            icon: const Icon(Icons.refresh_rounded),
          ),
        ],
      ),
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: controller.refreshAll,
          child: Obx(
            () {
              final loading = controller.isLoading.value;
              final reqs = controller.withdrawalRequests;
              return CustomScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                slivers: [
                  SliverToBoxAdapter(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        _buildBalanceCard(controller),
                        const SizedBox(height: 16),
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
                      ],
                    ),
                  ),
                  if (loading)
                    const SliverFillRemaining(
                      hasScrollBody: false,
                      child: Center(child: CircularProgressIndicator()),
                    )
                  else if (reqs.isEmpty)
                    SliverFillRemaining(
                      hasScrollBody: false,
                      child: Center(
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
                      ),
                    )
                  else
                    SliverPadding(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      sliver: SliverList(
                        delegate: SliverChildBuilderDelegate(
                          (context, index) => _buildRequestItem(reqs[index]),
                          childCount: reqs.length,
                        ),
                      ),
                    ),
                ],
              );
            },
          ),
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
            BoxShadow(color: Colors.black.withValues(alpha: 0.08), blurRadius: 16, offset: const Offset(0, 6)),
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
                "\$${_formatWalletBalance(profileController.profileData.value.data?.balance)}",
                style: TextStyle(
                  fontSize: 42,
                  fontWeight: FontWeight.w800,
                  color: AppColors.mainColor,
                ),
              ),
            ),
            const SizedBox(height: 10),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 4),
              child: Text(
                'Wallet balance from your account. Pull down or tap refresh after admin approves a withdrawal. '
                'This is not the same as “Total revenue” on the home dashboard.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 12,
                  height: 1.35,
                  color: Colors.grey.shade700,
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
        statusColor = AppColors.mainColor;
        statusBg = AppColors.secColor.withValues(alpha: 0.14);
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
                  "-\$${formatWithdrawAmount(req.amount)}",
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
    controller.selectedPayoutMethod.value = PayoutMethod.ach;
    controller.chequeAddressConfirmed.value = false;
    controller.fetchMyShopSnapshot();

    final maxH = MediaQuery.of(context).size.height * 0.85;

    Get.dialog(
      Dialog(
        insetPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        child: ConstrainedBox(
          constraints: BoxConstraints(maxHeight: maxH),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 20, 12, 8),
                child: Row(
                  children: [
                    const Expanded(
                      child: Text(
                        'Request withdrawal',
                        style: TextStyle(fontWeight: FontWeight.w800, fontSize: 18),
                      ),
                    ),
                    IconButton(
                      onPressed: Get.back,
                      icon: const Icon(Icons.close),
                    ),
                  ],
                ),
              ),
              Flexible(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Obx(
                        () => Text(
                          'Available: \$${_formatWalletBalance(profileController.profileData.value.data?.balance)}',
                          style: TextStyle(color: Colors.teal.shade800, fontWeight: FontWeight.w600),
                        ),
                      ),
                      const SizedBox(height: 16),
                      const Text(
                        'Amount (USD)',
                        style: TextStyle(fontWeight: FontWeight.w600, fontSize: 13),
                      ),
                      const SizedBox(height: 8),
                      TextField(
                        controller: controller.amountController,
                        keyboardType: const TextInputType.numberWithOptions(decimal: true),
                        style: const TextStyle(fontSize: 22),
                        decoration: InputDecoration(
                          hintText: '0.00',
                          prefixText: '\$ ',
                          filled: true,
                          fillColor: Colors.grey.shade50,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide(color: Colors.grey.shade300),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide(color: AppColors.mainColor, width: 2),
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                      const Text(
                        'How should we send your funds?',
                        style: TextStyle(fontWeight: FontWeight.w700, fontSize: 15),
                      ),
                      const SizedBox(height: 8),
                      Obx(
                        () => Column(
                          children: [
                            _methodTile(
                              controller: controller,
                              title: 'ACH (bank transfer)',
                              subtitle: 'Electronic deposit to the bank account on file',
                              selected: controller.selectedPayoutMethod.value == PayoutMethod.ach,
                              method: PayoutMethod.ach,
                              icon: Icons.account_balance,
                            ),
                            const SizedBox(height: 8),
                            _methodTile(
                              controller: controller,
                              title: 'Cheque (mailed)',
                              subtitle: 'We mail a company check to your address',
                              selected: controller.selectedPayoutMethod.value == PayoutMethod.cheque,
                              method: PayoutMethod.cheque,
                              icon: Icons.mail_outline,
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 16),
                      Obx(() {
                        if (controller.selectedPayoutMethod.value == PayoutMethod.ach) {
                          return _infoBox(
                            color: Colors.blue.shade50,
                            border: Colors.blue.shade200,
                            icon: Icons.info_outline,
                            iconColor: Colors.blue.shade800,
                            child: Text(
                              WithdrawController.achFeeDisclosure,
                              style: TextStyle(color: Colors.blue.shade900, fontSize: 13, height: 1.4),
                            ),
                          );
                        }
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _infoBox(
                              color: Colors.amber.shade50,
                              border: Colors.amber.shade200,
                              icon: Icons.info_outline,
                              iconColor: Colors.amber.shade900,
                              child: Text(
                                WithdrawController.chequeDisclosure,
                                style: TextStyle(color: Colors.amber.shade900, fontSize: 13, height: 1.4),
                              ),
                            ),
                            const SizedBox(height: 12),
                            const Text(
                              'Mailing address for cheque',
                              style: TextStyle(fontWeight: FontWeight.w700, fontSize: 14),
                            ),
                            const SizedBox(height: 8),
                            Obx(
                              () {
                                // Observe shop snapshot + profile so Edit Shop address shows here.
                                final lines = _chequeMailingDisplay(
                                  profileController,
                                  controller,
                                );
                                return Container(
                                  width: double.infinity,
                                  padding: const EdgeInsets.all(14),
                                  decoration: BoxDecoration(
                                    color: Colors.grey.shade100,
                                    borderRadius: BorderRadius.circular(12),
                                    border: Border.all(color: Colors.grey.shade300),
                                  ),
                                  child: Text(
                                    lines.isEmpty
                                        ? 'No address on file. Add your shop address in Edit Shop, or your address in Edit profile.'
                                        : lines,
                                    style: TextStyle(
                                      fontSize: 13,
                                      height: 1.45,
                                      color: Colors.grey.shade900,
                                    ),
                                  ),
                                );
                              },
                            ),
                            const SizedBox(height: 12),
                            Obx(
                              () => CheckboxListTile(
                                contentPadding: EdgeInsets.zero,
                                controlAffinity: ListTileControlAffinity.leading,
                                value: controller.chequeAddressConfirmed.value,
                                onChanged: (v) =>
                                    controller.chequeAddressConfirmed.value = v ?? false,
                                title: const Text(
                                  'I confirm this is the correct address to mail my cheque. I understand the company is not responsible for loss due to an incorrect or outdated address.',
                                  style: TextStyle(fontSize: 13, height: 1.35),
                                ),
                              ),
                            ),
                          ],
                        );
                      }),
                    ],
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                child: Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        onPressed: Get.back,
                        child: const Text('Cancel'),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      flex: 2,
                      child: Obx(
                        () => controller.isLoading.value
                            ? const Center(child: Padding(
                                padding: EdgeInsets.all(12),
                                child: CircularProgressIndicator(),
                              ))
                            : FilledButton(
                                onPressed: () {
                                  final amount =
                                      double.tryParse(controller.amountController.text) ?? 0;
                                  controller.createWithdrawalRequest(amount);
                                },
                                style: FilledButton.styleFrom(
                                  backgroundColor: AppColors.mainColor,
                                  foregroundColor: Colors.white,
                                  padding: const EdgeInsets.symmetric(vertical: 14),
                                ),
                                child: const Text('Submit request'),
                              ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _methodTile({
    required WithdrawController controller,
    required String title,
    required String subtitle,
    required bool selected,
    required PayoutMethod method,
    required IconData icon,
  }) {
    return Material(
      color: selected ? AppColors.mainColor.withValues(alpha: 0.08) : Colors.grey.shade50,
      borderRadius: BorderRadius.circular(12),
      child: InkWell(
        onTap: () => controller.setPayoutMethod(method),
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
          child: Row(
            children: [
              Icon(icon, color: selected ? AppColors.mainColor : Colors.grey.shade600),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(title, style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 15)),
                    const SizedBox(height: 2),
                    Text(subtitle, style: TextStyle(fontSize: 12, color: Colors.grey.shade700)),
                  ],
                ),
              ),
              Icon(
                selected ? Icons.radio_button_checked : Icons.radio_button_off,
                color: selected ? AppColors.mainColor : Colors.grey,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _infoBox({
    required Color color,
    required Color border,
    required IconData icon,
    required Color iconColor,
    required Widget child,
  }) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: border),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 20, color: iconColor),
          const SizedBox(width: 10),
          Expanded(child: child),
        ],
      ),
    );
  }

  String _formatWalletBalance(dynamic balance) {
  if (balance == null) return '0.00';
  if (balance is num) return balance.toDouble().toStringAsFixed(2);
  return double.tryParse(balance.toString())?.toStringAsFixed(2) ?? '0.00';
}

String _formatMailingAddress(dynamic d) {
    if (d == null) return '';
    final parts = <String>[];
    void add(dynamic v) {
      if (v == null) return;
      final s = v.toString().trim();
      if (s.isNotEmpty) parts.add(s);
    }

    add(d.address);
    final city = d.city?.toString().trim();
    final state = d.state?.toString().trim();
    final zip = d.zipCode?.toString().trim();
    final cityLine = [city, state, zip].where((e) => e != null && e.toString().trim().isNotEmpty).join(', ');
    if (cityLine.isNotEmpty) parts.add(cityLine);
    add(d.country);
    return parts.join('\n');
  }

  /// Cheque mailing line: prefer shop address (Edit Shop), else profile.
  String _chequeMailingDisplay(
    ProfileController profileController,
    WithdrawController withdrawController,
  ) {
    final shop = withdrawController.shopSnapshot.value?.data?.address?.trim();
    if (shop != null && shop.isNotEmpty) return shop;
    return _formatMailingAddress(profileController.profileData.value.data);
  }
}
