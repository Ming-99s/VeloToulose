import 'package:flutter/material.dart';
import 'package:velo_toulose/core/constant/app_color.dart';
import 'package:velo_toulose/core/constant/app_text_style.dart';
import 'package:velo_toulose/models/station.dart';

class StationTile extends StatelessWidget {
  
  final Station station;
  final VoidCallback onTap;

  const StationTile({super.key,required this.station, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: AppColor.primaryLight,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(Icons.pedal_bike, color: AppColor.primary),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(station.name, style: AppTextStyle.cardTitle),
                  const SizedBox(height: 2),
                  Text(
                    '${station.getAvailableBikes().length} bikes available',
                    style: AppTextStyle.subheading,
                  ),
                ],
              ),
            ),
            Icon(Icons.chevron_right, color: AppColor.textSecondary),
          ],
        ),
      ),
    );
  }
}
