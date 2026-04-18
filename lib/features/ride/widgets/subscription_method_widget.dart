import 'package:flutter/material.dart';
import 'package:velo_toulose/core/constant/app_color.dart';
import 'package:velo_toulose/core/constant/app_text_style.dart';

class SubscriptionMethodWidget extends StatelessWidget {
  final bool isMonthlyPass;

  const SubscriptionMethodWidget({super.key, required this.isMonthlyPass});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(22, 20, 22, 18),
      decoration: BoxDecoration(
        color: AppColor.primaryLight,
        borderRadius: BorderRadius.circular(22),
        boxShadow: [
          BoxShadow(
            color: AppColor.textPrimary.withValues(alpha: 0.04),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (isMonthlyPass) ...[
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: AppColor.primary,
                    borderRadius: BorderRadius.circular(999),
                  ),
                  child: const Text('MONTHLY PASS', style: AppTextStyle.label),
                ),
                const Spacer(),
                Text(
                  'Included in your pass',
                  style: AppTextStyle.subheading.copyWith(
                    fontSize: 12,
                    color: AppColor.primary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 18),
            Text(
              'First 30 minutes included.',
              style: AppTextStyle.feature.copyWith(fontSize: 13),
            ),
            Text(
              'No charge applied.',
              style: AppTextStyle.cardTitle.copyWith(
                fontSize: 16,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 18),
            const Divider(color: AppColor.border, thickness: 1),
            const SizedBox(height: 14),
            const _TotalRow(
              amount: '\$0.00',
              amountColor: AppColor.textSecondary,
            ),
          ] else ...[
            Text(
              'COST BREAKDOWN',
              style: AppTextStyle.label.copyWith(
                fontSize: 10,
                letterSpacing: 3,
                color: AppColor.textSecondary,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 22),
            const _CostLine(
              label: 'First 30 minutes',
              price: 'Free',
              priceColor: AppColor.primary,
              note: 'Base fare included',
            ),
            const SizedBox(height: 18),
            const _CostLine(
              label: 'Additional 12 minutes',
              price: '\$0.60',
              note: '\$0.05/min',
            ),
            const SizedBox(height: 18),
            const Divider(color: AppColor.border, thickness: 1),
            const SizedBox(height: 14),
            const _TotalRow(amount: '\$0.60', amountColor: AppColor.primary),
          ],
        ],
      ),
    );
  }
}

class _CostLine extends StatelessWidget {
  final String label;
  final String price;
  final String note;
  final Color? priceColor;

  const _CostLine({
    required this.label,
    required this.price,
    required this.note,
    this.priceColor,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(
              child: Text(
                label,
                style: AppTextStyle.cardTitle.copyWith(
                  fontSize: 15,
                  height: 1.25,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            Text(
              price,
              style: AppTextStyle.cardTitle.copyWith(
                fontSize: 15,
                color: priceColor ?? AppColor.textPrimary,
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
        ),
        const SizedBox(height: 2),
        Text(note, style: AppTextStyle.subheading.copyWith(fontSize: 14)),
      ],
    );
  }
}

class _TotalRow extends StatelessWidget {
  final String amount;
  final Color amountColor;

  const _TotalRow({required this.amount, required this.amountColor});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const Expanded(child: Text('Total', style: AppTextStyle.cardTitle)),
        Text(
          amount,
          style: AppTextStyle.priceTag.copyWith(
            fontSize: 20,
            color: amountColor,
            fontWeight: FontWeight.w800,
          ),
        ),
      ],
    );
  }
}
