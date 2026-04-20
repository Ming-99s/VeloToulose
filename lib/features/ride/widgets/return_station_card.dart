import 'package:flutter/material.dart';
import 'package:velo_toulose/core/constant/app_color.dart';
import 'package:velo_toulose/core/constant/app_text_style.dart';
import 'package:velo_toulose/models/station.dart';

class StationCard extends StatelessWidget {
  final Station station;
  final int freeSlots;
  final bool hasSlots;
  final String? distanceLabel;
  final VoidCallback? onTap;

  const StationCard({
    super.key,
    required this.station,
    required this.freeSlots,
    required this.hasSlots,
    required this.distanceLabel,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final slotColor = hasSlots
        ? AppColor.primary
        : AppColor.textSecondary;

    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppColor.white,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(
            color: hasSlots
                ? const Color.fromARGB(53, 255, 94, 0)
                : AppColor.border,
            width: 1.5,
          ),
        ),
        child: Row(
          children: [
            // dock icon
            Container(
              width: 50,
              height: 50,
              decoration: BoxDecoration(
                color: hasSlots
                    ? AppColor.primaryLight
                    : AppColor.border,
                borderRadius: BorderRadius.circular(14),
              ),
              child: Icon(Icons.dock_rounded, color: slotColor, size: 26),
            ),

            const SizedBox(width: 14),

            // station info
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(station.name, style: AppTextStyle.cardTitle),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      // availability dot
                      Container(
                        width: 7,
                        height: 7,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: slotColor,
                        ),
                      ),
                      const SizedBox(width: 5),
                      Text(
                        hasSlots
                            ? '$freeSlots free dock${freeSlots > 1 ? 's' : ''}'
                            : 'Full — no docks',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                          color: slotColor,
                        ),
                      ),

                    ],
                  ),
                  
                ],
              ),
            ),

            const SizedBox(width: 10),

            // return button or full badge
            if (hasSlots)
              Column(
                
                children: [
                  if (distanceLabel != null) ...[
                    const SizedBox(width: 8),
                    const SizedBox(width: 8),
                    Text(
                      distanceLabel!,
                      style: AppTextStyle.subheading.copyWith(fontSize: 12),
                    ),
                  ],
                  SizedBox(height: 10,),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 14,
                      vertical: 9,
                    ),
                    decoration: BoxDecoration(
                      color: AppColor.primary,
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(
                          color: const Color.fromARGB(46, 255, 94, 0),
                          blurRadius: 8,
                          offset: const Offset(0, 3),
                        ),
                      ],
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Text(
                          'Return',
                          style: TextStyle(
                            color: AppColor.white,
                            fontSize: 13,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        const SizedBox(width: 4),
                        const Icon(
                          Icons.arrow_forward_rounded,
                          color: AppColor.white,
                          size: 14,
                        ),
                      ],
                    ),
                  ),
                ],
              )
            else
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 9,
                ),
                decoration: BoxDecoration(
                  color: AppColor.border,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  'Full',
                  style: TextStyle(
                    color: AppColor.textSecondary,
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
