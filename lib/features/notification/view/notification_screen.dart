import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:velo_toulose/core/constant/app_color.dart';
import 'package:velo_toulose/core/constant/app_text_style.dart';
import 'package:velo_toulose/core/enum/notification_type.dart';
import 'package:velo_toulose/features/auth/viewmodel/auth_view_model.dart';
import 'package:velo_toulose/features/notification/view/payment_summary.dart';
import 'package:velo_toulose/features/notification/view/ride_summary.dart';
import 'package:velo_toulose/features/notification/viewmodel/notification_view_model.dart';
import 'package:velo_toulose/features/notification/widgets/receipt_card.dart';
import 'package:velo_toulose/features/ride/viewmodel/ride_view_model.dart';
import 'package:velo_toulose/models/notification.dart';

class NotificationScreen extends StatelessWidget {
  const NotificationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<NotificationViewModel>();
    final userVm = context.read<AuthViewModel>();

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
          if (vm.unreadCount > 0)
            TextButton(
              onPressed: () => vm.markAllAsRead(userVm.currentUser!.userId),
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
                  onTap: () => _handleTap(context, notification, vm, userVm),
                );
              },
            ),
    );
  }

  void _handleTap(
    BuildContext context,
    AppNotification notification,
    NotificationViewModel vm,
    AuthViewModel userVm,
  ) async {
    if (!notification.isRead) {
      vm.markAsRead(notification.notificationId, userVm.currentUser!.userId);
    }

    switch (notification.type) {
      case NotificationType.overtimeFee:
        final rideId = vm.getRideIdForNotification(notification.notificationId);
        if (rideId == null) return;

        final rideVm = context.read<RideViewModel>();
        final ride = await rideVm.getRideById(rideId);
        if (!context.mounted) return;
        if (ride == null) return;

        final payment = await vm.getPaymentForNotification(
          notification.notificationId,
        );
        if (!context.mounted) return;

        final hasPass = payment?.passId != null;
        final plan = payment?.type.name ?? '';

        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) =>
                RideSummaryScreen(ride: ride, hasPass: hasPass, plan: plan),
          ),
        );

      case NotificationType.rideReceipt:
        final rideId = vm.getRideIdForNotification(notification.notificationId);
        if (rideId == null) return;

        final rideVm = context.read<RideViewModel>();
        final ride = await rideVm.getRideById(rideId);
        if (!context.mounted) return;
        if (ride == null) return;

        final payment = await vm.getPaymentForNotification(
          notification.notificationId,
        );
        if (!context.mounted) return;

        final hasPass = payment?.passId != null;
        final plan = payment?.type.name ?? '';

        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) =>
                RideSummaryScreen(ride: ride, hasPass: hasPass, plan: plan),
          ),
        );

      case NotificationType.unlockFee:
        final summary = await vm.getPaymentForNotification(notification.notificationId);
        if (!context.mounted) return;
        if (summary == null) return;

        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => PaymentSummaryScreen(
              notification: notification,
              payment: summary,
            ),
          ),
        );

      case NotificationType.passPurchase:
        final summary = await vm.getPassPaymentForNotification(notification.notificationId);
        if (!context.mounted) return;
        if (summary == null) return;

        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => PaymentSummaryScreen(
              notification: notification,
              payment: summary,
            ),
          ),
        );
    }
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
