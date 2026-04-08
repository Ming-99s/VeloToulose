import 'package:flutter/material.dart';
import 'app_color.dart';

class AppTextStyle {
  static const TextStyle heading = TextStyle(
    fontSize: 24,
    fontWeight: FontWeight.w700,
    color: AppColor.textPrimary,
  );

  static const TextStyle subheading = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w400,
    color: AppColor.textSecondary,
  );

  static const TextStyle priceTag = TextStyle(
    fontSize: 28,
    fontWeight: FontWeight.w800,
    color: AppColor.primary,
  );

  static const TextStyle pricePeriod = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w400,
    color: AppColor.textSecondary,
  );

  static const TextStyle cardTitle = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w600,
    color: AppColor.textPrimary,
  );

  static const TextStyle feature = TextStyle(
    fontSize: 13,
    fontWeight: FontWeight.w400,
    color: AppColor.textSecondary,
  );

  static const TextStyle buttonText = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w600,
    color: AppColor.white,
  );

  static const TextStyle label = TextStyle(
    fontSize: 11,
    fontWeight: FontWeight.w700,
    color: AppColor.primary,
    letterSpacing: 1.2,
  );
}