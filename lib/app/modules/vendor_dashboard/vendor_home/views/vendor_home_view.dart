import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../controllers/vendor_home_controller.dart';

class VendorHomeView extends GetView<VendorHomeController> {
  const VendorHomeView({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('VendorHomeView'),
        centerTitle: true,
      ),
      body: const Center(
        child: Text(
          'VendorHomeView is working',
          style: TextStyle(fontSize: 20),
        ),
      ),
    );
  }
}
