import 'package:flutter/material.dart';
import 'package:velo_toulose/core/constant/app_color.dart';

class RideStatusWidget extends StatelessWidget {
  const RideStatusWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: const Column(
        children: [
          _StatusIcon(),
          SizedBox(height: 20),
          Text(
            'Ride Completed Successfully',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 32,
              height: 1.2,
              fontWeight: FontWeight.w800,
              color: AppColor.textPrimary,
            ),
          ),
          SizedBox(height: 10),
          Text(
            'Your bike has been safely locked at the docking station.',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 16,
              height: 1.4,
              color: AppColor.textSecondary,
            ),
          ),
        ],
      ),
    );
  }
}

class _StatusIcon extends StatelessWidget {
  const _StatusIcon();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 96,
      height: 96,
      decoration: const BoxDecoration(
        color: Color(0xFFDDF5E9),
        shape: BoxShape.circle,
      ),
      alignment: Alignment.center,
      child: Container(
        width: 52,
        height: 52,
        decoration: const BoxDecoration(
          color: Color(0xFF0FA06A),
          shape: BoxShape.circle,
        ),
        child: const Icon(Icons.check_rounded, color: AppColor.white, size: 34),
      ),
    );
  }
}
