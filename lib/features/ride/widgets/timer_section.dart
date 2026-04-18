import 'dart:async';

import 'package:flutter/material.dart';
import 'package:velo_toulose/core/constant/app_color.dart';
import 'package:velo_toulose/core/constant/app_text_style.dart';

class TimerSection extends StatefulWidget {
  const TimerSection({super.key});

  @override
  State<TimerSection> createState() => _TimerSectionState();
}

class _TimerSectionState extends State<TimerSection> {
  late final Stopwatch _stopwatch;
  Timer? _ticker;

  @override
  void initState() {
    super.initState();
    _stopwatch = Stopwatch()..start();
    _ticker = Timer.periodic(const Duration(seconds: 1), (_) {
      if (mounted) {
        setState(() {});
      }
    });
  }

  @override
  void dispose() {
    _ticker?.cancel();
    _stopwatch.stop();
    super.dispose();
  }

  String _twoDigits(int value) => value.toString().padLeft(2, '0');

  @override
  Widget build(BuildContext context) {
    final elapsed = _stopwatch.elapsed;
    final minutes = _twoDigits(elapsed.inMinutes.remainder(60));
    final seconds = _twoDigits(elapsed.inSeconds.remainder(60));

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
      decoration: BoxDecoration(
        color: AppColor.primaryLight,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColor.border),
      ),
      child: Column(
        children: [
          Text(
            '$minutes:$seconds',
            style: AppTextStyle.heading.copyWith(
              fontSize: 52,
              fontWeight: FontWeight.w800,
              color: AppColor.textPrimary,
            ),
          ),
          const SizedBox(height: 8),
          Text('Ride in progress', style: AppTextStyle.subheading),
        ],
      ),
    );
  }
}
