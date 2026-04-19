import 'package:flutter/material.dart';
import 'package:velo_toulose/core/constant/app_color.dart';
import 'package:velo_toulose/core/constant/app_text_style.dart';
import 'package:velo_toulose/models/notification.dart';

class ReceiptCard extends StatelessWidget {
  final AppNotification notification;
  final VoidCallback onTap;

  const ReceiptCard({
    super.key,
    required this.notification,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final date = notification.sentAt;
    final months = [
      'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
      'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec',
    ];
    final dateText =
        '${date.day} ${months[date.month - 1]} ${date.year}, '
        '${date.hour.toString().padLeft(2, '0')}:'
        '${date.minute.toString().padLeft(2, '0')}';

    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: notification.isRead ? AppColor.background : AppColor.primaryLight,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: AppColor.border),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Receipt icon
            Container(
              width: 40,
              height: 40,
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                color: AppColor.primaryLight,
              ),
              child: const Icon(
                Icons.receipt_long,
                color: AppColor.primary,
                size: 20,
              ),
            ),
            const SizedBox(width: 12),

            // Message and date
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Payment Receipt',
                    style: AppTextStyle.cardTitle.copyWith(
                      fontWeight: notification.isRead
                          ? FontWeight.w500
                          : FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    notification.message,
                    style: AppTextStyle.feature,
                  ),
                  const SizedBox(height: 6),
                  Text(
                    dateText,
                    style: AppTextStyle.subheading.copyWith(fontSize: 11),
                  ),
                ],
              ),
            ),

            // Unread dot
            if (!notification.isRead)
              Container(
                width: 8,
                height: 8,
                margin: const EdgeInsets.only(top: 6),
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  color: AppColor.primary,
                ),
              ),
          ],
        ),
      ),
    );
  }
}
