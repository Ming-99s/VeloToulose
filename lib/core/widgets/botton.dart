import 'package:flutter/material.dart';
import 'package:velo_toulose/core/constant/app_color.dart';
import 'package:velo_toulose/core/constant/app_text_style.dart';

class AppButton extends StatelessWidget {
  final String label;
  final VoidCallback? onPressed;
  final IconData? trailingIcon;
  final bool isprimaryColor;

  const AppButton({
    super.key,
    required this.label,
    this.onPressed,
    this.trailingIcon,
    required this.isprimaryColor,
  });

  Color get backgroundColor =>
      isprimaryColor ? AppColor.primary : AppColor.background;
  Color get textColor =>
      isprimaryColor ? AppColor.background : AppColor.primary;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 56,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: backgroundColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          elevation: 0,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(label, style: TextStyle(color: textColor , fontSize: 18 ,fontWeight: FontWeight.w700)),
            if (trailingIcon != null) ...[
              const SizedBox(width: 8),
              Icon(trailingIcon, color: textColor, size: 20),
            ],
          ],
        ),
      ),
    );
  }
}
