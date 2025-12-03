import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../controllers/my_orders_controller.dart';

class MyOrdersView extends GetView<MyOrdersController> {
  const MyOrdersView({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('MyOrdersView'),
        centerTitle: true,
      ),
      body: const Center(
        child: Text(
          'MyOrdersView is working',
          style: TextStyle(fontSize: 20),
        ),
      ),
    );
  }
}
