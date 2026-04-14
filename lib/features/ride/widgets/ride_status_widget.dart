import 'package:flutter/material.dart';
import 'package:velo_toulose/core/constant/app_color.dart';
import 'package:velo_toulose/core/constant/app_text_style.dart';

class RideStatusWidget extends StatelessWidget {
  const RideStatusWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        children: [
          _StatusIcon(),
          SizedBox(height: 20),
          Text(
            'Ride Completed Successfully',
            textAlign: TextAlign.center,
            style: AppTextStyle.heading
          ),
          SizedBox(height: 10),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 20),
            child: Text(
              'Your bike has been safely locked at the docking station.',
              textAlign: TextAlign.center,
              style: AppTextStyle.subheading
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
          color: Color.fromARGB(255, 12, 165, 78),
          shape: BoxShape.circle,
        ),
        child: const Icon(Icons.check_rounded, color: AppColor.white, size: 34),
      ),
    );
  }
}
