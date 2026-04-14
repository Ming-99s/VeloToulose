import 'package:flutter/material.dart';
import 'package:velo_toulose/core/constant/app_color.dart';

class SubscriptionMethodWidget extends StatelessWidget {
  final bool isMonthlyPass;
  final VoidCallback onTap;

  const SubscriptionMethodWidget({
    super.key,
    required this.isMonthlyPass,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(22),
        child: Ink(
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
          child: AnimatedSwitcher(
            duration: const Duration(milliseconds: 300),
            switchInCurve: Curves.easeInOut,
            switchOutCurve: Curves.easeInOut,
            child: isMonthlyPass
                ? const _MonthlyPassContent(key: ValueKey('monthly-pass'))
                : const _CostBreakdownContent(key: ValueKey('cost-breakdown')),
          ),
        ),
      ),
    );
  }
}

class _MonthlyPassContent extends StatelessWidget {
  const _MonthlyPassContent({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
              decoration: BoxDecoration(
                color: AppColor.primary,
                borderRadius: BorderRadius.circular(999),
              ),
              child: const Text(
                'MONTHLY PASS',
                style: TextStyle(
                  color: AppColor.white,
                  fontSize: 11,
                  letterSpacing: 1.2,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ),
            const Spacer(),
            const Text(
              'Included in your pass',
              style: TextStyle(
                fontSize: 14,
                color: AppColor.primary,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
        const SizedBox(height: 18),
        const Text(
          'First 30 minutes included.',
          style: TextStyle(fontSize: 16, color: AppColor.textSecondary),
        ),
        const Text(
          'No charge applied.',
          style: TextStyle(
            fontSize: 18,
            color: AppColor.textPrimary,
            fontWeight: FontWeight.w700,
          ),
        ),
        const SizedBox(height: 18),
        const Divider(color: Color(0xFFD9D9D9), thickness: 1),
        const SizedBox(height: 14),
        const _TotalRow(amount: '\$0.00', amountColor: Color(0xFFA3A8B2)),
      ],
    );
  }
}

class _CostBreakdownContent extends StatelessWidget {
  const _CostBreakdownContent({super.key});

  @override
  Widget build(BuildContext context) {
    return const Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'COST BREAKDOWN',
          style: TextStyle(
            fontSize: 12,
            letterSpacing: 3,
            color: Color(0xFF67606A),
            fontWeight: FontWeight.w700,
          ),
        ),
        SizedBox(height: 22),
        _CostLine(
          label: 'First 30 minutes',
          price: 'Free',
          priceColor: Color(0xFF0FA06A),
          note: 'Base fare included',
        ),
        SizedBox(height: 18),
        _CostLine(
          label: 'Additional 12 minutes',
          price: '\$0.60',
          note: '\$0.05/min',
        ),
        SizedBox(height: 18),
        Divider(color: Color(0xFFD9D9D9), thickness: 1),
        SizedBox(height: 14),
        _TotalRow(amount: '\$0.60', amountColor: AppColor.primary),
      ],
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
                  fontSize: 18,
                  height: 1.25,
                  color: AppColor.textPrimary,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            Text(
              price,
              style: TextStyle(
                fontSize: 24,
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
              fontSize: 28,
              color: AppColor.textPrimary,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
        Text(
          amount,
          style: TextStyle(
            fontSize: 36,
            color: amountColor,
            fontWeight: FontWeight.w800,
          ),
        ),
      ],
    );
  }
}
