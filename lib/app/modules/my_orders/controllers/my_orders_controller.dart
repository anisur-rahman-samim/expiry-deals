import 'package:get/get.dart';

class OrderItem {
  final String name;
  final double price;
  final int quantity;
  final String imageUrl;
  OrderItem({required this.name, required this.price, required this.quantity, this.imageUrl = ''});
}

class Order {
  final String id;
  final DateTime orderDate;
  final double total;
  final String status; // pending, processing, delivered, cancelled
  final List<OrderItem> items;
  final double shippingFee;
  final double tax;
  final String shippingAddress;

  Order({
    required this.id,
    required this.orderDate,
    required this.total,
    required this.status,
    required this.items,
    this.shippingFee = 9.99,
    this.tax = 5.50,
    required this.shippingAddress,
  });
}

class MyOrdersController extends GetxController {
  var isLoading = true.obs;

  var allOrders = <Order>[].obs;
  var pendingOrders = <Order>[].obs;
  var processingOrders = <Order>[].obs;
  var deliveredOrders = <Order>[].obs;
  var cancelledOrders = <Order>[].obs;

  @override
  void onInit() {
    fetchOrders();
    super.onInit();
  }

  Future<void> fetchOrders() async {
    isLoading(true);
    await Future.delayed(const Duration(seconds: 1));

    final sample = [
      Order(
        id: "129487",
        orderDate: DateTime.now().subtract(const Duration(hours: 5)),
        total: 89.99,
        status: "pending",
        shippingAddress: "123 Main St, Lagos, Nigeria",
        items: [
          OrderItem(name: "Wireless Earbuds Pro", price: 79.99, quantity: 1, imageUrl: ""),
        ],
      ),
      Order(
        id: "129486",
        orderDate: DateTime.now().subtract(const Duration(days: 1)),
        total: 199.50,
        status: "processing",
        shippingAddress: "456 Ikeja Road, Lagos",
        items: [
          OrderItem(name: "Smart Watch Series 8", price: 189.50, quantity: 1),
        ],
      ),
      Order(
        id: "129485",
        orderDate: DateTime.now().subtract(const Duration(days: 3)),
        total: 149.00,
        status: "delivered",
        shippingAddress: "789 Victoria Island",
        items: [
          OrderItem(name: "Bluetooth Speaker", price: 139.00, quantity: 1),
        ],
      ),
      Order(
        id: "129484",
        orderDate: DateTime.now().subtract(const Duration(days: 7)),
        total: 59.99,
        status: "cancelled",
        shippingAddress: "101 Lekki Phase 1",
        items: [
          OrderItem(name: "Phone Case", price: 29.99, quantity: 2),
        ],
      ),
    ];

    allOrders.assignAll(sample);
    pendingOrders.assignAll(sample.where((o) => o.status == 'pending'));
    processingOrders.assignAll(sample.where((o) => o.status == 'processing'));
    deliveredOrders.assignAll(sample.where((o) => o.status == 'delivered'));
    cancelledOrders.assignAll(sample.where((o) => o.status == 'cancelled'));

    isLoading(false);
  }
}