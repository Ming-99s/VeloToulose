import 'package:flutter/material.dart';
import 'package:velo_toulose/core/constant/app_color.dart';

class SubscriptionMethodWidget extends StatelessWidget {
  final bool isMonthlyPass;

  const SubscriptionMethodWidget({super.key, required this.isMonthlyPass});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(22, 20, 22, 18),
      decoration: BoxDecoration(
        color: const Color(0xFFF6F6F6),
        borderRadius: BorderRadius.circular(22),
        boxShadow: const [
          BoxShadow(
            color: Color(0x0A000000),
            blurRadius: 10,
            offset: Offset(0, 4),
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
                  child: const Text(
                    'MONTHLY PASS',
                    style: TextStyle(
                      color: AppColor.white,
                      fontSize: 8,
                      letterSpacing: 1.2,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ),
                const Spacer(),
                const Text(
                  'Included in your pass',
                  style: TextStyle(
                    fontSize: 12,
                    color: AppColor.primary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 18),
            const Text(
              'First 30 minutes included.',
              style: TextStyle(fontSize: 13, color: AppColor.textSecondary),
            ),
            const Text(
              'No charge applied.',
              style: TextStyle(
                fontSize: 16,
                color: AppColor.textPrimary,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 18),
            const Divider(color: Color(0xFFD9D9D9), thickness: 1),
            const SizedBox(height: 14),
            const _TotalRow(amount: '\$0.00', amountColor: Color(0xFFA3A8B2)),
          ] else ...[
            const Text(
              'COST BREAKDOWN',
              style: TextStyle(
                fontSize: 10,
                letterSpacing: 3,
                color: Color(0xFF67606A),
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 22),
            const _CostLine(
              label: 'First 30 minutes',
              price: 'Free',
              priceColor: Color(0xFF0FA06A),
              note: 'Base fare included',
            ),
            const SizedBox(height: 18),
            const _CostLine(
              label: 'Additional 12 minutes',
              price: '\$0.60',
              note: '\$0.05/min',
            ),
            const SizedBox(height: 18),
            const Divider(color: Color(0xFFD9D9D9), thickness: 1),
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
                style: const TextStyle(
                  fontSize: 15,
                  height: 1.25,
                  color: AppColor.textPrimary,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            Text(
              price,
              style: TextStyle(
                fontSize: 15,
                color: priceColor ?? AppColor.textPrimary,
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
        ),
        const SizedBox(height: 2),
        Text(
          note,
          style: const TextStyle(fontSize: 14, color: AppColor.textSecondary),
        ),
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
        const Expanded(
          child: Text(
            'Total',
            style: TextStyle(
              fontSize: 16,
              color: AppColor.textPrimary,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
        Text(
          amount,
          style: TextStyle(
            fontSize: 20,
            color: amountColor,
            fontWeight: FontWeight.w800,
          ),
        ),
      ],
    );
  }
}
