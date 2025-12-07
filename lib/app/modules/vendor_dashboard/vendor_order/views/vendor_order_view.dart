import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../controllers/vendor_order_controller.dart';

class VendorOrderView extends GetView<VendorOrderController> {
  const VendorOrderView({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('VendorOrderView'),
        centerTitle: true,
      ),
      body: const Center(
        child: Text(
          'VendorOrderView is working',
          style: TextStyle(fontSize: 20),
        ),
      ),
    );
  }
}
