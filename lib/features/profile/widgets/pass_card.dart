import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:velo_toulose/core/constant/app_color.dart';
import 'package:velo_toulose/core/constant/app_text_style.dart';
import 'package:velo_toulose/core/enum/pass_type.dart';
import 'package:velo_toulose/models/pass.dart';

class PassCard extends StatelessWidget {
  final Pass pass;

  const PassCard({super.key, required this.pass});

  String get _passLabel {
    switch (pass.type) {
      case PassType.day:
        return 'Day Pass';
      case PassType.monthly:
        return 'Monthly';
      case PassType.annual:
        return 'Year Pass';
      default:
        return pass.type.name;
    }
  }

  @override
  Widget build(BuildContext context) {
    final renewDate = DateFormat('MMM dd, yyyy').format(pass.endDate);

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 20),
      decoration: BoxDecoration(
        color: AppColor.background,
        borderRadius: BorderRadius.circular(30),
        boxShadow: const [
          BoxShadow(
            color: Color.fromARGB(29, 107, 114, 128),
            blurRadius: 2,
            offset: Offset(0, 1),
            spreadRadius: 2,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(30),
              color: AppColor.primaryLight,
            ),
            child: Text(
              'Current Plan'.toUpperCase(),
              style: TextStyle(
                color: AppColor.primary,
                fontSize: 10,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          const SizedBox(height: 5),
          Text(
            _passLabel,
            style: TextStyle(
              color: AppColor.primary,
              fontSize: 30,
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 10),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Renewal Date'.toUpperCase(),
                style: TextStyle(color: AppColor.textSecondary, fontSize: 12),
              ),
              Text(
                renewDate,
                style: TextStyle(
                  color: AppColor.textPrimary,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
