import 'package:flutter/material.dart';
import 'package:velo_toulose/core/constant/app_color.dart';
import 'package:velo_toulose/core/constant/app_text_style.dart';

class PassCard extends StatelessWidget {
  final String title;
  final String price;
  final String period;
  final List<String> features;
  final bool isSelected;
  final String? badge;
  final VoidCallback onTap;

  const PassCard({
    super.key,
    required this.title,
    required this.price,
    required this.period,
    required this.features,
    required this.isSelected,
    required this.onTap,
    this.badge,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: isSelected ? AppColor.primaryLight : AppColor.white,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: isSelected ? AppColor.primary : AppColor.border,
                width: isSelected ? 2 : 1,
              ),
            ),
            child: Row(
              children: [
                // Left side: title, price, features
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(title, style: AppTextStyle.cardTitle),
                      const SizedBox(height: 4),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.baseline,
                        textBaseline: TextBaseline.alphabetic,
                        children: [
                          Text(price, style: AppTextStyle.priceTag),
                          const SizedBox(width: 2),
                          Text(period, style: AppTextStyle.pricePeriod),
                        ],
                      ),
                      const SizedBox(height: 12),
                      ...features.map((f) => Padding(
                        padding: const EdgeInsets.only(bottom: 4),
                        child: Row(
                          children: [
                            Icon(Icons.check_circle_outline,
                                size: 16, color: AppColor.primary),
                            const SizedBox(width: 6),
                            Text(f, style: AppTextStyle.feature),
                          ],
                        ),
                      )),
                    ],
                  ),
                ),
                // Right side: radio indicator
                Container(
                  width: 24,
                  height: 24,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: isSelected ? AppColor.primary : AppColor.border,
                      width: 2,
                    ),
                  ),
                  child: isSelected
                      ? Center(
                          child: Container(
                            width: 12,
                            height: 12,
                            decoration: const BoxDecoration(
                              shape: BoxShape.circle,
                              color: AppColor.primary,
                            ),
                          ),
                        )
                      : null,
                ),
              ],
            ),
          ),
          // Badge (e.g. "BEST VALUE")
          if (badge != null)
            Positioned(
              top: -10,
              right: 16,
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: AppColor.primary,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  badge!,
                  style: const TextStyle(
                    color: AppColor.white,
                    fontSize: 10,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}