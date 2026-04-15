import 'package:flutter/material.dart';
import 'package:velo_toulose/core/constant/app_text_style.dart';

class RideStationInfoWidget extends StatelessWidget {
  const RideStationInfoWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 22),
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
            style: const TextStyle(
              fontSize: 11,
              letterSpacing: 1.4,
              color: Color(0xFFA3A8B2),
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
        Text(
          value,
          style: AppTextStyle.cardTitle
        ),
      ],
    );
  }
}
