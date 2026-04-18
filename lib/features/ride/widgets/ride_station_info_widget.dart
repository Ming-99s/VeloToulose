import 'package:flutter/material.dart';
import 'package:velo_toulose/core/constant/app_color.dart';
import 'package:velo_toulose/core/constant/app_text_style.dart';

class RideStationInfoWidget extends StatelessWidget {
  const RideStationInfoWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 22),
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
      child: const Column(
        children: [
          _InfoLine(label: 'Returned To', value: 'Station#732'),
          SizedBox(height: 18),
          _InfoLine(label: 'Duration', value: '42 minutes'),
          SizedBox(height: 18),
          _InfoLine(label: 'Bike ID', value: 'Kinetic #8234'),
        ],
      ),
    );
  }
}

class _InfoLine extends StatelessWidget {
  final String label;
  final String value;

  const _InfoLine({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Text(
            label.toUpperCase(),
            style: AppTextStyle.label.copyWith(
              fontSize: 11,
              letterSpacing: 1.4,
              color: AppColor.textSecondary,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
        Text(value, style: AppTextStyle.cardTitle),
      ],
    );
  }
}
