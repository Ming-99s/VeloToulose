import 'package:flutter/material.dart';
import 'package:velo_toulose/core/constant/app_color.dart';

class ConfirmDialog extends StatelessWidget {
  
  const ConfirmDialog({
    super.key,
    required this.title,
    required this.message,
    required this.confirmLabel,
    required this.cancelLabel,
    required this.isDanger,
    required this.onTap

  });

  final String title;
  final String message;
  final Function() onTap;
  final String confirmLabel;
  final bool isDanger;
  final String cancelLabel;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        backgroundColor: Colors.white,
        title: Text(
          title,
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        content: Text(message, style: const TextStyle(color: Colors.grey)),
        actions: [
          // Cancel
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text(
              cancelLabel,
              style: const TextStyle(color: Colors.grey),
            ),
          ),
          // Confirm
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: isDanger? Colors.red : AppColor.primary,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            onPressed: onTap,
            child: Text(
              confirmLabel,
              style: const TextStyle(color: Colors.white),
            ),
          ),
        ],
    );
  }
}
