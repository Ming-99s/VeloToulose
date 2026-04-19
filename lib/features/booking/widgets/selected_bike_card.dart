import 'package:flutter/material.dart';
import 'package:velo_toulose/core/constant/app_color.dart';
import 'package:velo_toulose/core/constant/app_text_style.dart';

class SelectedBikeCard extends StatelessWidget {
  final String bikeType;
  final String bikeId;
  final String slotLabel;

  const SelectedBikeCard({
    super.key,
    required this.bikeType,
    required this.bikeId,
    required this.slotLabel,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      decoration: BoxDecoration(
        color: AppColor.primaryLight,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Left: bike info
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('SELECTED BIKE', style: AppTextStyle.label),
              const SizedBox(height: 4),
              Text(
                '$bikeType #$bikeId',
                style: AppTextStyle.cardTitle.copyWith(fontSize: 18),
              ),
            ],
          ),
          // Right: slot info
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text('STATION SLOT', style: AppTextStyle.label),
              const SizedBox(height: 4),
              Text(
                slotLabel,
                style: AppTextStyle.cardTitle.copyWith(
                  fontSize: 18,
                  color: AppColor.primary,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}