import 'package:flutter/material.dart';
import 'package:velo_toulose/core/constant/app_color.dart';
import 'package:velo_toulose/core/constant/app_text_style.dart';
import 'package:velo_toulose/models/ride.dart';

class SubscriptionMethodWidget extends StatelessWidget {
  final Ride ride;
  final bool hasPass;
  final String plan;

  const SubscriptionMethodWidget({
    super.key,
    required this.ride,
    required this.hasPass,
    required this.plan,
  });

  @override
  Widget build(BuildContext context) {
    const int freeMinutes = 30;

    final duration = ride.duration;
    final isOvertime = ride.isOvertime();
    final overtimeMinutes = isOvertime ? duration - freeMinutes : 0;
    final cost = ride.calculateCost(hasPass: hasPass);

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
          if (hasPass) ...[
            // pass holder — no unlock fee
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
                  child: Text(plan, style: AppTextStyle.buttonText),
                ),
                const Spacer(),
                Text(
                  'No unlock fee',
                  style: AppTextStyle.subheading.copyWith(
                    fontSize: 12,
                    color: AppColor.primary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 18),

            // show overtime if applicable
            if (isOvertime) ...[
              _CostLine(
                label: 'First 30 minutes',
                price: 'Free',
                priceColor: AppColor.primary,
                note: 'Included in your pass',
              ),
              const SizedBox(height: 18),
              _CostLine(
                label: 'Additional $overtimeMinutes minutes',
                price: '€${(overtimeMinutes * 0.05).toStringAsFixed(2)}',
                note: '€0.05/min overtime',
              ),
            ] else ...[
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
            ],

            const SizedBox(height: 18),
            const Divider(color: AppColor.border, thickness: 1),
            const SizedBox(height: 14),
            _TotalRow(
              amount: cost == 0 ? '€0.00' : '€${cost.toStringAsFixed(2)}',
              amountColor: cost == 0
                  ? AppColor.textSecondary
                  : AppColor.primary,
            ),
          ] else ...[
            // pay as you go
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
              label: 'Unlock fee',
              price: '€2.50',
              note: 'Pay-as-you-go base fare',
            ),
            const SizedBox(height: 18),

            const _CostLine(
              label: 'First 30 minutes',
              price: 'Free',
              priceColor: AppColor.primary,
              note: 'Base fare included',
            ),

            if (isOvertime) ...[
              const SizedBox(height: 18),
              _CostLine(
                label: 'Additional $overtimeMinutes minutes',
                price: '€${(overtimeMinutes * 0.05).toStringAsFixed(2)}',
                note: '€0.05/min overtime',
              ),
            ],

            const SizedBox(height: 18),
            const Divider(color: AppColor.border, thickness: 1),
            const SizedBox(height: 14),
            _TotalRow(
              amount: '€${cost.toStringAsFixed(2)}',
              amountColor: AppColor.primary,
            ),
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
