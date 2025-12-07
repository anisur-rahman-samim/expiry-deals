import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../controllers/vendor_product_controller.dart';

class VendorProductView extends GetView<VendorProductController> {
  const VendorProductView({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('VendorProductView'),
        centerTitle: true,
      ),
      body: const Center(
        child: Text(
          'VendorProductView is working',
          style: TextStyle(fontSize: 20),
        ),
      ),
    );
  }
}
