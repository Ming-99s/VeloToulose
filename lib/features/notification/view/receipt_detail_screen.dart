import 'package:flutter/material.dart';
import 'package:velo_toulose/core/constant/app_color.dart';
import 'package:velo_toulose/core/constant/app_text_style.dart';
import 'package:velo_toulose/core/widgets/botton.dart';
import 'package:velo_toulose/models/ride.dart';

class ReceiptDetailScreen extends StatelessWidget {
  final Ride ride;
  final bool hasPass;

  const ReceiptDetailScreen({
    super.key,
    required this.ride,
    this.hasPass = false,
  });

  @override
  Widget build(BuildContext context) {
    final duration = ride.duration;
    final cost = ride.cost;
    final isFree = hasPass || duration <= Ride.freeSeconds;

    return Scaffold(
      backgroundColor: AppColor.background,
      appBar: AppBar(
        backgroundColor: AppColor.background,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColor.textPrimary),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text('Payment Receipt', style: AppTextStyle.heading),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: Column(
          children: [
            const SizedBox(height: 32),

            // Receipt icon
            Container(
              width: 72,
              height: 72,
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                color: AppColor.primaryLight,
              ),
              child: const Icon(
                Icons.receipt_long,
                color: AppColor.primary,
                size: 36,
              ),
            ),
            const SizedBox(height: 16),

            Text(
              'Ride Completed!',
              style: AppTextStyle.heading,
            ),
            const SizedBox(height: 8),
            Text(
              isFree ? (hasPass ? 'Covered by your pass' : 'Your ride was free') : 'Here is your receipt',
              style: AppTextStyle.subheading.copyWith(fontSize: 14),
            ),
            const SizedBox(height: 32),

            // Receipt card
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: AppColor.primaryLight,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                children: [
                  _receiptRow('Duration', '${duration}s'),
                  if (!hasPass) ...[
                    const SizedBox(height: 12),
                    const Divider(color: AppColor.border, height: 1),
                    const SizedBox(height: 12),
                    _receiptRow('Free time', '${Ride.freeSeconds}s'),
                    if (!isFree) ...[
                      const SizedBox(height: 12),
                      const Divider(color: AppColor.border, height: 1),
                      const SizedBox(height: 12),
                      _receiptRow(
                        'Overtime',
                        '${duration - Ride.freeSeconds}s × €0.05',
                      ),
                    ],
                  ],
                  const SizedBox(height: 12),
                  const Divider(color: AppColor.border, height: 1),
                  const SizedBox(height: 12),
                  _receiptRow(
                    'Total',
                    hasPass
                        ? 'Covered by pass'
                        : (isFree ? 'Free!' : '€${cost.toStringAsFixed(2)}'),
                    isBold: true,
                  ),
                ],
              ),
            ),

            const Spacer(),

            // Done button
            Padding(
              padding: const EdgeInsets.only(bottom: 32),
              child: AppButton(
                label: 'Done',
                isprimaryColor: true,
                onPressed: () => Navigator.pop(context),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _receiptRow(String label, String value, {bool isBold = false}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: AppTextStyle.subheading),
        Text(
          value,
          style: TextStyle(
            fontSize: isBold ? 20 : 14,
            fontWeight: isBold ? FontWeight.w700 : FontWeight.w600,
            color: isBold ? AppColor.primary : AppColor.textPrimary,
          ),
        ),
      ],
    );
  }
}
