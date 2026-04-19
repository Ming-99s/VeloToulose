import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:velo_toulose/core/constant/app_color.dart';
import 'package:velo_toulose/core/constant/app_text_style.dart';
import 'package:velo_toulose/features/notification/viewmodel/notification_view_model.dart';
import 'package:velo_toulose/features/notification/view/receipt_detail_screen.dart';
import 'package:velo_toulose/features/notification/widgets/receipt_card.dart';

class NotificationScreen extends StatelessWidget {
  const NotificationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<NotificationViewModel>();

    return Scaffold(
      backgroundColor: AppColor.background,
      appBar: AppBar(
        backgroundColor: AppColor.background,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColor.textPrimary),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text('Notifications', style: AppTextStyle.heading),
        centerTitle: true,
        actions: [
          // "Mark all read" button — only show if there are unread
          if (vm.unreadCount > 0)
            TextButton(
              onPressed: () => vm.markAllAsRead(),
              child: Text(
                'Read all',
                style: AppTextStyle.subheading.copyWith(
                  color: AppColor.primary,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
        ],
      ),
      body: vm.notifications.isEmpty
          ? _buildEmptyState()
          : ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
              itemCount: vm.notifications.length,
              itemBuilder: (context, index) {
                final notification = vm.notifications[index];
                return ReceiptCard(
                  notification: notification,
                  onTap: () {
                    // Mark as read when tapped
                    if (!notification.isRead) {
                      vm.markAsRead(notification.notificationId);
                    }
                    // Open receipt detail screen
                    final ride = vm.getRideForNotification(
                      notification.notificationId,
                    );
                    if (ride != null) {
                      final hasPass = vm.hadPassForNotification(
                        notification.notificationId,
                      );
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => ReceiptDetailScreen(
                            ride: ride,
                            hasPass: hasPass,
                          ),
                        ),
                      );
                    }
                  },
                );
              },
            ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.notifications_off, size: 64, color: AppColor.border),
          const SizedBox(height: 16),
          Text(
            'No notifications yet',
            style: AppTextStyle.subheading.copyWith(fontSize: 16),
          ),
          const SizedBox(height: 8),
          Text(
            'Your payment receipts will appear here\nafter you finish a ride.',
            textAlign: TextAlign.center,
            style: AppTextStyle.feature,
          ),
        ],
      ),
    );
  }
}
