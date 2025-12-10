// vendor_order_controller.dart

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class OrderItem {
  final String name;
  final double price;
  final int quantity;

  OrderItem({required this.name, required this.price, required this.quantity});
}

class Order {
  String id;
  String status; // pending, processing, shipped, delivered, cancelled
  DateTime orderDate;
  List<OrderItem> items;
  double total;
  double shippingFee;
  double tax;
  String shippingAddress;

  Order({
    required this.id,
    required this.status,
    required this.orderDate,
    required this.items,
    required this.total,
    required this.shippingFee,
    required this.tax,
    required this.shippingAddress,
  });
}

class VendorOrderController extends GetxController {
  var isLoading = true.obs;
  var orders = <Order>[].obs;

  @override
  void onInit() {
    super.onInit();
    fetchOrders();
  }

  Future<void> fetchOrders() async {
    try {
      isLoading.value = true;

      // Simulate API delay
      await Future.delayed(const Duration(seconds: 1));

      // Dummy data - replace with real API call later
      orders.assignAll([
        Order(
          id: 'ORD-2025-001',
          status: 'pending',
          orderDate: DateTime.now().subtract(const Duration(hours: 2)),
          items: [
            OrderItem(name: 'Wireless Bluetooth Earbuds', price: 49.99, quantity: 2),
            OrderItem(name: 'Over-Ear Headphones', price: 89.99, quantity: 1),
          ],
          total: 189.97,
          shippingFee: 8.99,
          tax: 12.00,
          shippingAddress: '123 Main St, New York, NY 10001',
        ),
        Order(
          id: 'ORD-2025-002',
          status: 'processing',
          orderDate: DateTime.now().subtract(const Duration(days: 1)),
          items: [
            OrderItem(name: 'Floral Summer Maxi Dress', price: 74.99, quantity: 1),
          ],
          total: 82.99,
          shippingFee: 5.00,
          tax: 3.00,
          shippingAddress: '456 Oak Avenue, Los Angeles, CA 90210',
        ),
        Order(
          id: 'ORD-2025-003',
          status: 'shipped',
          orderDate: DateTime.now().subtract(const Duration(days: 2)),
          items: [
            OrderItem(name: 'Men\'s Slim Fit Denim Jacket', price: 89.99, quantity: 1),
            OrderItem(name: 'High-Waist Mom Jeans', price: 54.99, quantity: 1),
          ],
          total: 152.98,
          shippingFee: 0.00,
          tax: 8.00,
          shippingAddress: '789 Pine Road, Chicago, IL 60601',
        ),
        Order(
          id: 'ORD-2025-004',
          status: 'delivered',
          orderDate: DateTime.now().subtract(const Duration(days: 5)),
          items: [
            OrderItem(name: 'Leather Crossbody Bag', price: 120.00, quantity: 1),
          ],
          total: 130.00,
          shippingFee: 10.00,
          tax: 0.00,
          shippingAddress: '321 Elm Street, Miami, FL 33101',
        ),
        Order(
          id: 'ORD-2025-005',
          status: 'cancelled',
          orderDate: DateTime.now().subtract(const Duration(hours: 6)),
          items: [
            OrderItem(name: 'Classic White Sneakers', price: 79.99, quantity: 1),
          ],
          total: 0.00,
          shippingFee: 0.00,
          tax: 0.00,
          shippingAddress: '555 Cancelled Ave, Cancel City',
        ),
        Order(
          id: 'ORD-2025-005',
          status: 'cancelled',
          orderDate: DateTime.now().subtract(const Duration(hours: 6)),
          items: [
            OrderItem(name: 'Classic White Sneakers', price: 79.99, quantity: 1),
          ],
          total: 0.00,
          shippingFee: 0.00,
          tax: 0.00,
          shippingAddress: '555 Cancelled Ave, Cancel City',
        ),
        Order(
          id: 'ORD-2025-005',
          status: 'cancelled',
          orderDate: DateTime.now().subtract(const Duration(hours: 6)),
          items: [
            OrderItem(name: 'Classic White Sneakers', price: 79.99, quantity: 1),
          ],
          total: 0.00,
          shippingFee: 0.00,
          tax: 0.00,
          shippingAddress: '555 Cancelled Ave, Cancel City',
        ),
        Order(
          id: 'ORD-2025-005',
          status: 'cancelled',
          orderDate: DateTime.now().subtract(const Duration(hours: 6)),
          items: [
            OrderItem(name: 'Classic White Sneakers', price: 79.99, quantity: 1),
          ],
          total: 0.00,
          shippingFee: 0.00,
          tax: 0.00,
          shippingAddress: '555 Cancelled Ave, Cancel City',
        ),
      ]);
    } finally {
      isLoading.value = false;
    }
  }

  // Optional: Refresh orders (for pull-to-refresh)
  Future<void> refreshOrders() async {
    await fetchOrders();
    Get.snackbar('Refreshed', 'Order list updated', backgroundColor: Colors.green.withOpacity(0.2));
  }

  // Optional: Update status via API (call this from details view)
  Future<void> updateOrderStatus(String orderId, String newStatus) async {
    final order = orders.firstWhere((o) => o.id == orderId);
    order.status = newStatus.toLowerCase();
    orders.refresh(); // Trigger UI update

    // TODO: Call your real API here
    // await ApiService.updateOrderStatus(orderId, newStatus);
  }
}