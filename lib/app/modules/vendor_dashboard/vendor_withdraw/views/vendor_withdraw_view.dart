import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../controllers/vendor_withdraw_controller.dart';

class VendorWithdrawView extends GetView<VendorWithdrawController> {
  const VendorWithdrawView({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('VendorWithdrawView'),
        centerTitle: true,
      ),
      body: const Center(
        child: Text(
          'VendorWithdrawView is working',
          style: TextStyle(fontSize: 20),
        ),
      ),
    );
  }
}
