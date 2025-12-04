// Model
import 'package:get/get.dart';

class AppNotification {
  final String id;
  final String title;
  final String body;
  final String type; // message, order, promo, etc.
  final DateTime createdAt;
  bool isRead;

  AppNotification({
    required this.id,
    required this.title,
    required this.body,
    this.type = 'general',
    required this.createdAt,
    this.isRead = false,
  });
}

// In NotificationsController
class NotificationsController extends GetxController {
  var notifications = <AppNotification>[].obs;
  var isLoading = true.obs;

  @override
  void onInit() {
    fetchNotifications();
    super.onInit();
  }

  Future<void> fetchNotifications() async {
    try {
      isLoading(true);
      // Simulate API call
      await Future.delayed(const Duration(seconds: 1));

      // Sample data
      notifications.assignAll([
        AppNotification(
          id: '1',
          title: 'New Message',
          body: 'John Doe sent you a new message',
          type: 'message',
          createdAt: DateTime.now().subtract(const Duration(minutes: 5)),
        ),
        AppNotification(
          id: '2',
          title: 'Order Delivered!',
          body: 'Your order #12345 has been delivered successfully',
          type: 'order',
          createdAt: DateTime.now().subtract(const Duration(hours: 3)),
          isRead: true,
        ),
      ]);
    } finally {
      isLoading(false);
    }
  }

  void markAsRead(String id) {
    final notif = notifications.firstWhere((n) => n.id == id);
    notif.isRead = true;
    notifications.refresh();
  }
}
