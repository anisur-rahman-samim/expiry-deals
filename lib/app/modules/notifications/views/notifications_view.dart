import 'package:expiry_deals/common/app_color/app_colors.dart';
import 'package:expiry_deals/common/app_text_style/styles.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import '../controllers/notifications_controller.dart';



class NotificationsView extends GetView {
   NotificationsView({super.key});
final NotificationsController controller = Get.put(NotificationsController());
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bgColor,
      appBar: AppBar(
        title: Text('Notifications',),
        centerTitle: true,
        backgroundColor: AppColors.bgColor,
        elevation: 0,
        foregroundColor: AppColors.black,
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(
            child: CircularProgressIndicator(color: AppColors.mainColor),
          );
        }

        if (controller.notifications.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.notifications_off_outlined, size: 80, color: AppColors.gray),
                const SizedBox(height: 16),
                Text('No notifications yet', style: h2.copyWith(color: AppColors.textColor)),
                const SizedBox(height: 8),
                Text(
                  'We\'ll notify you when something arrives',
                  style: h4.copyWith(color: AppColors.hintColor),
                ),
              ],
            ),
          );
        }

        return RefreshIndicator(
          onRefresh: controller.fetchNotifications,
          color: AppColors.mainColor,
          child: ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: controller.notifications.length,
            itemBuilder: (context, index) {
              final notification = controller.notifications[index];
              final isUnread = notification.isRead == false;

              return Container(
                margin: const EdgeInsets.only(bottom: 12),
                decoration: BoxDecoration(
                  color: AppColors.white,
                  borderRadius: BorderRadius.circular(16),
                  border: isUnread
                      ? Border.all(color: AppColors.mainColor, width: 2)
                      : Border.all(color: AppColors.grayLight),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.04),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: ListTile(
                  onTap: () {
                    controller.markAsRead(notification.id);
                    _showNotificationDialog(context, notification);
                  },
                  contentPadding: const EdgeInsets.all(16),
                  leading: Container(
                    width: 50,
                    height: 50,
                    decoration: BoxDecoration(
                      color: isUnread ? AppColors.mainColor : AppColors.grayLight,
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      _getIconForType(notification.type),
                      color: Colors.white,
                      size: 28,
                    ),
                  ),
                  title: Text(
                    notification.title,
                    style: isUnread
                        ? h3.copyWith(fontWeight: FontWeight.w700, color: AppColors.black)
                        : h3,
                  ),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 4),
                      Text(
                        notification.body,
                        style: h4.copyWith(color: AppColors.textColor.withOpacity(0.8)),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        _formatDate(notification.createdAt),
                        style: h5.copyWith(color: AppColors.hintColor),
                      ),
                    ],
                  ),
                  trailing: isUnread
                      ? Container(
                    width: 12,
                    height: 12,
                    decoration: const BoxDecoration(
                      color: AppColors.mainColor,
                      shape: BoxShape.circle,
                    ),
                  )
                      : null,
                ),
              );
            },
          ),
        );
      }),
    );
  }

  // Show full notification in popup
  void _showNotificationDialog(BuildContext context, AppNotification notification) {
    Get.dialog(
      Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        child: Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: AppColors.white,
            borderRadius: BorderRadius.circular(20),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    width: 56,
                    height: 56,
                    decoration: BoxDecoration(
                      color: AppColors.mainColor,
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      _getIconForType(notification.type),
                      color: Colors.white,
                      size: 32,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(notification.title, style: h2),
                        Text(
                          _formatDate(notification.createdAt),
                          style: h5.copyWith(color: AppColors.hintColor),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              Text(
                notification.body,
                style: h3.copyWith(height: 1.6, color: AppColors.textColor),
              ),
              const SizedBox(height: 24),
              Align(
                alignment: Alignment.centerRight,
                child: ElevatedButton(
                  onPressed: () => Get.back(),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.mainColor,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                  ),
                  child: Text('Close', style: GoogleFonts.dmSans(fontWeight: FontWeight.w600)),
                ),
              ),
            ],
          ),
        ),
      ),
      barrierDismissible: true,
    );
  }

  IconData _getIconForType(String type) {
    switch (type) {
      case 'message':
        return Icons.message_rounded;
      case 'order':
        return Icons.shopping_bag_rounded;
      case 'payment':
        return Icons.payment_rounded;
      case 'promo':
        return Icons.local_offer_rounded;
      default:
        return Icons.notifications_rounded;
    }
  }

  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final diff = now.difference(date);

    if (diff.inMinutes < 1) return 'Just now';
    if (diff.inMinutes < 60) return '${diff.inMinutes}m ago';
    if (diff.inHours < 24) return '${diff.inHours}h ago';
    if (diff.inDays < 2) return 'Yesterday';
    if (diff.inDays < 7) return DateFormat('EEEE').format(date);
    return DateFormat('dd MMM yyyy').format(date);
  }
}