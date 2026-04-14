import 'package:flutter/material.dart';
import 'package:velo_toulose/core/constant/app_color.dart';

class PrimaryButtonWidget extends StatelessWidget {
  final String label;
  final VoidCallback? onPressed;

  const PrimaryButtonWidget({super.key, required this.label, this.onPressed});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 56,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColor.primary,
          disabledBackgroundColor: AppColor.primary.withValues(alpha: 0.45),
          elevation: 0,
          shadowColor: const Color(0x3DFF5C00),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(24),
          ),
        ),
        child: Text(
          label,
          style: const TextStyle(
            color: AppColor.white,
            fontSize: 18,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
    );
  }
}
